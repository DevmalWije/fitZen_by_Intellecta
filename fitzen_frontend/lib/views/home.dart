import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../widgets/button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MediaStream? _localStream;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  bool _isCameraOn = true;

  Future<void> getLocalCameraStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': true,
    };

    MediaStream mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    setState(() {
      _localStream = mediaStream;
      _localRenderer.srcObject = _localStream;
    });
  }

  void toggleCameraOnOff() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });

    if (_localStream != null) {
      final videoTrack = _localStream!.getVideoTracks()[0];
      videoTrack.enabled = _isCameraOn;
    }
  }

  void initializeRenderer() async {
    await _localRenderer.initialize();
    getLocalCameraStream();
  }

  @override
  void initState() {
    super.initState();
    initializeRenderer();
  }

  @override
  void dispose() {
    super.dispose();
    _localRenderer.dispose();
    _localStream?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          children: [
            //app bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 90,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            //summary tiles
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "Total Screen Time",
                    value: "5hrs 30mins",
                    color: kBlue,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  child: SummaryCard(
                    title: "No. of Times in Poor Posture",
                    value: "15",
                    color: kRed,
                  ),
                ),
                SizedBox(width: 35),
                Expanded(
                  child: SummaryCard(
                    title: "Time till last break",
                    value: "23 mins",
                    color: kYellow,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            //camera view and start button
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //camera view
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      //camera view
                      SizedBox(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RTCVideoView(
                            _localRenderer,
                            placeholderBuilder: (_){
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),

                      //toggle button
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: FloatingActionButton(
                          onPressed: toggleCameraOnOff,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          child: Icon(_isCameraOn ? Icons.videocam : Icons.videocam_off),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 150),

                  //start button
                  Button(
                    text: "Start Tracking",
                    icon: Icons.timer_outlined,
                    backgroundColor: kGreen,
                    onPressed: (){},
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
