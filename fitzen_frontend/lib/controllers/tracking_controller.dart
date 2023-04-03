import 'dart:async';
import 'dart:convert';

import 'package:fitzen_frontend/controllers/settings_controller.dart';
import 'package:fitzen_frontend/models/session.dart';
import 'package:fitzen_frontend/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:fitzen_frontend/constants.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingController extends ChangeNotifier {
  bool _isStarted = false;
  bool _isLoading = false;
  String _posture = "N/A";
  String _eyeHealth = "N/A";
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  RTCDataChannelInit? _dataChannelDict;
  MediaStream? _localStream;
  Timer? _timer;
  PausableTimer? _elapsedTimer;
  int _elapsedSeconds = 0;
  DateTime? _lastNotificationTime;
  Session? _session;

  bool get isStarted => _isStarted;

  bool get isLoading => _isLoading;

  String get posture => _posture;
  String get eyeHealth => _eyeHealth;
  String get elapsedSeconds {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds ~/ 60) % 60;
    final seconds = _elapsedSeconds % 60;
    final timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return timeString;
  }

  RTCVideoRenderer get localRenderer => _localRenderer;

  set isStarted(bool value) {
    _isStarted = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set posture(String value) {
    _posture = value;
    notifyListeners();
  }

  set eyeHealth(String value) {
    _eyeHealth = value;
    notifyListeners();
  }

  Future<void> initializeRenderer() async {
    await _localRenderer.initialize();
  }

  Future<bool> _waitForGatheringComplete(_) async {
    print("WAITING FOR GATHERING COMPLETE");
    if (_peerConnection!.iceGatheringState == RTCIceGatheringState.RTCIceGatheringStateComplete) {
      return true;
    } else {
      await Future.delayed(Duration(seconds: 1));
      return await _waitForGatheringComplete(_);
    }
  }

  Future<void> _negotiateRemoteConnection(BuildContext context, SettingsController settingsController) async {
    return _peerConnection!
        .createOffer()
        .then((offer) {
          return _peerConnection!.setLocalDescription(offer);
        })
        .then(_waitForGatheringComplete)
        .then((_) async {
          var des = await _peerConnection!.getLocalDescription();
          var headers = {
            'Content-Type': 'application/json',
          };
          var request = http.Request(
            'POST',
            Uri.parse("$API/offer"),
          );
          request.body = json.encode(
            {
              "sdp": des!.sdp,
              "type": des.type,
            },
          );
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          String data = "";
          if (response.statusCode == 200) {
            _elapsedTimer = PausableTimer(Duration(seconds: 1), () {
              _elapsedSeconds++;

              //sending 20-20-20 notification
              if(settingsController.twentyTwentyTwentyNotification == ON && _elapsedSeconds % (1 * 60) == 0 && _elapsedSeconds != 0){
                LocalNotification notification = LocalNotification(
                    title: "Take a break!",
                    body: "Please take a 20-second break and look at something 20 feet away to give your eyes"
                        " a chance to relax!"
                );
                notification.show();
              }

              notifyListeners();
              _elapsedTimer!..reset()..start();
            })..start();
            data = await response.stream.bytesToString();
            var dataMap = json.decode(data);
            await _peerConnection!.setRemoteDescription(
              RTCSessionDescription(
                dataMap["sdp"],
                dataMap["type"],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.reasonPhrase ?? "Something went Wrong!"),
                backgroundColor: Colors.red,
              ),
            );
            print(response.reasonPhrase);
          }
        });
  }

  void _sendNotifications(RTCDataChannelMessage message, SettingsController settingsController){
    Map dataMap = jsonDecode(message.text);
    switch(dataMap["posture"]){
      case "proper_posture":{
        posture = "Good";
      }
      break;

      case "bad_posture":{
        posture = "Bad";
      }
      break;

      case "no pose detected":{
        posture = "No Pose Detected";
      }
      break;

      case "too_close":{
        posture = "Too Close";
      }
      break;

      default: {
        posture = "N/A";
      }
      break;
    }

    eyeHealth = dataMap["eye_strain"] == 0 ? "Good" : "Bad";
    _session = Session.fromJson(dataMap);
    _lastNotificationTime ??= DateTime.now().subtract(Duration(seconds: 20));

    //sending poor posture notification
    if(posture == "Bad" && settingsController.poorPostureNotificationInterval != OFF){
      DateTime now = DateTime.now();
      if(now.difference(_lastNotificationTime!).inSeconds > settingsController.poorPostureNotificationInterval * 60){
        LocalNotification notification = LocalNotification(
          title: "Poor Posture Detected!",
        );
        notification.show();
        _lastNotificationTime = DateTime.now();
      }
    }

    //sending low blink count notification
    if(settingsController.lowBlinkCountNotification == ON && eyeHealth == "Bad"){
      LocalNotification notification = LocalNotification(
        title: "Low Blink Count!",
        body: "Your blink count has been low in the past 30 seconds. Please blink more!"
      );
      notification.show();
    }

    //pause and resume the timer based on detection of pose
    if(posture == "No Pose Detected"){
        _elapsedTimer?.pause();
    } else if(_elapsedTimer?.isPaused ?? false){
      _elapsedTimer?.start();
    }
  }

  Future<void> startConnection(BuildContext context, SettingsController settingsController) async {
    isLoading = true;
    //* Create Peer Connection
    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection({
      'sdpSemantics': 'unified-plan',
    });

    //* Create Data Channel
    _dataChannelDict = RTCDataChannelInit();
    _dataChannelDict!.ordered = true;
    _dataChannel = await _peerConnection!.createDataChannel(
      "data",
      _dataChannelDict!,
    );
    _dataChannel!.onMessage = (RTCDataChannelMessage message){
      _sendNotifications(message, settingsController);
    };

    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '800',
          'minHeight': '800',
          'minFrameRate': '1',
          'maxFrameRate': '1',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream = stream;
       _localRenderer.srcObject = _localStream;
      stream.getTracks().forEach((element) {
        _peerConnection!.addTrack(element, stream);
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        List<RTCRtpTransceiver> transceivers = await _peerConnection!.getTransceivers();
        RTCRtpTransceiver videoTransceiver = transceivers.firstWhere(
          (transceiver) => transceiver.sender.track?.kind == 'video',
        );
        RTCRtpSender videoSender = videoTransceiver.sender;
        videoSender.replaceTrack(null);
        await Future.delayed(Duration(milliseconds: 300));
        final userVideoTrack = stream.getVideoTracks()[0];
        videoSender.replaceTrack(userVideoTrack);
      });

      await _negotiateRemoteConnection(context, settingsController);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
      print(e.toString());
      await stopConnection();
      Navigator.pop(context);
    }

    isStarted = true;
    isLoading = false;
  }

  Future<void> stopConnection() async {
    try {
      if(_session != null){
        await sendDataToDatabase(_session!);
      }
      isStarted = false;
      _peerConnection = null;
      _localRenderer.srcObject = null;
      _timer?.cancel();
      _elapsedTimer?.cancel();
      _elapsedSeconds = 0;
      await _peerConnection?.close();
      await _dataChannel?.close();
      await _localStream?.dispose();
    } catch (e) {
      print(e.toString());
    }
  }

  sendDataToDatabase(Session session) async {
    isLoading = true;
    session.elapsedSeconds = _elapsedSeconds;
    APIService apiService = APIService();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString("uid")!;
    await apiService.sendPOSTRequest('add-session', {
      'elapsedSeconds': session.elapsedSeconds,
      'blinkCount': session.blinkCount,
      'goodPostureCount': session.goodPostureCount,
      'badPostureCount': session.badPostureCount,
      'uid': uid,
    }, onError: (e){
      print(e);
    });
    isLoading = false;
  }
}
