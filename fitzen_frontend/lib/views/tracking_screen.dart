import 'dart:convert';

import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import '../widgets/button.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCDataChannel? _dataChannel;
  RTCDataChannelInit? _dataChannelDict;

  void _onDataChannelState(RTCDataChannelState? state) {
    switch (state) {
      case RTCDataChannelState.RTCDataChannelClosed:
        print("channel Closed!!!!!!!");
        break;
      case RTCDataChannelState.RTCDataChannelOpen:
        print("channel Opened!!!!!!!");
        break;
      default:
        print("Data Channel State: $state");
    }
  }

  Future<bool> _waitForGatheringComplete(_) async {
    print("WAITING FOR GATHERING COMPLETE");
    if (_peerConnection!.iceGatheringState ==
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
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

  void _onTrack(RTCTrackEvent event) {
    if (event.track.kind == "video") {
      _localRenderer.srcObject = event.streams[0];
    }
  }

  Future<void> createConnection() async {
    // setState(() {
    //   _loading = true;
    // });

    //* Create Peer Connection
    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection({
      'sdpSemantics': 'unified-plan',
    });

    _peerConnection!.onTrack = _onTrack;

    //* Create Data Channel
    _dataChannelDict = RTCDataChannelInit();
    _dataChannelDict!.ordered = true;
    _dataChannel = await _peerConnection!.createDataChannel(
      "data",
      _dataChannelDict!,
    );
    _dataChannel!.onDataChannelState = _onDataChannelState;
    _dataChannel!.onMessage = (RTCDataChannelMessage message){
      print('Data channel message received: ${message.text}');
    };

    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '700',
          'minHeight': '700',
          'minFrameRate': '5',
        },
        'facingMode': 'user',
        // 'facingMode': 'environment',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream = stream;

      stream.getTracks().forEach((element) {
        _peerConnection!.addTrack(element, stream);
      });

      await _negotiateRemoteConnection();
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {});
  }

  void initializeRenderer() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initializeRenderer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          children: [
            //camera view and status
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //camera view
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RTCVideoView(
                        _localRenderer,
                        placeholderBuilder: (_) {
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 45),

                  //status cards
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SummaryCard(
                          title: "Current Posture",
                          value: "Good",
                          color: kGreen,
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                        ),
                        SizedBox(height: 10),
                        SummaryCard(
                          title: "Current Eye Health",
                          value: "Bad",
                          color: kRed,
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                        ),
                        SizedBox(height: 10),
                        SummaryCard(
                          title: "Current Screen Time",
                          value: "02:15:12",
                          color: kBlue,
                          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // //camera view and start button
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //camera view
                  SizedBox(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Card(
                      color: Colors.black.withOpacity(0.11),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Suggestions",
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff505050),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 20),

                            //text
                            Row(
                              children: [
                                Image.asset(
                                  "assets/suggestion.png",
                                  width: 60,
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: Text(
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting"
                                    " industry. Lorem Ipsum has been the industry's standard"
                                    " dummy text ever since the 1500s,",
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.4,
                                      color: Color(0xff505050),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: SizedBox.shrink()),

                            //button
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: kBlue,
                                ),
                                child: Text("View All"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 150),

                  //stop button
                  Button(
                    text: "Stop Tracking",
                    icon: Icons.timer_outlined,
                    backgroundColor: kRed,
                    onPressed: () {createConnection();},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
