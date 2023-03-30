import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:fitzen_frontend/constants.dart';

class TrackingController extends ChangeNotifier {
  bool _isStarted = false;
  bool _isLoading = false;
  String _posture = "N/A";
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  RTCDataChannelInit? _dataChannelDict;
  MediaStream? _localStream;
  Timer? _timer;

  bool get isStarted => _isStarted;
  bool get isLoading => _isLoading;
  String get posture => _posture;
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

  Future<void> _negotiateRemoteConnection() async {
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
            Uri.parse(API),
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
            data = await response.stream.bytesToString();
            var dataMap = json.decode(data);
            await _peerConnection!.setRemoteDescription(
              RTCSessionDescription(
                dataMap["sdp"],
                dataMap["type"],
              ),
            );
          } else {
            print(response.reasonPhrase);
          }
        });
  }

  Future<void> startConnection() async {
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
    _dataChannel!.onMessage = (RTCDataChannelMessage message) {
      posture = message.text;
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
        await Future.delayed(Duration(milliseconds: 100));
        final userVideoTrack = stream.getVideoTracks()[0];
        videoSender.replaceTrack(userVideoTrack);
      });

      await _negotiateRemoteConnection();
    } catch (e) {
      print(e.toString());
    }

    isStarted = true;
    isLoading = false;
  }

  void stopConnection() async {
    try {
      await _localStream?.dispose();
      await _dataChannel?.close();
      await _peerConnection?.close();
      _peerConnection = null;
      _localRenderer.srcObject = null;
      _timer?.cancel();
    } catch (e) {
      print(e.toString());
    }
    isStarted = false;
  }
}
