import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/tracking_controller.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fitzen_frontend/widgets/button.dart';
import 'package:provider/provider.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  void startTracking() async {
    await Provider.of<TrackingController>(context, listen: false).initializeRenderer();
    await Provider.of<TrackingController>(context, listen: false).startConnection(context);
  }

  @override
  void initState() {
    super.initState();
    startTracking();
  }

  @override
  void dispose() {
    Provider.of<TrackingController>(context, listen: false).stopConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var trackingController = Provider.of<TrackingController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: SizedBox(
          height: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
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
                          trackingController.localRenderer,
                          placeholderBuilder: (_) {
                            if (trackingController.isLoading) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    //suggestions
                    Expanded(
                      flex: 1,
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
                                  fontSize: 20,
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
                                    width: 50,
                                  ),
                                  SizedBox(width: 30),
                                  Expanded(
                                    child: Text(
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting"
                                      " industry. Lorem Ipsum has been the industry's standard"
                                      " dummy text ever since the 1500s,",
                                      style: TextStyle(
                                        fontSize: 16,
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
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SummaryCard(
                      title: "Current Posture",
                      value: trackingController.posture,
                      color: kGreen,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    ),
                    SizedBox(height: 10),
                    SummaryCard(
                      title: "Current Eye Health",
                      value: trackingController.eyeHealth,
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
                    Expanded(child: SizedBox.shrink()),
                    Button(
                      text: "Stop Tracking",
                      icon: Icons.timer_outlined,
                      isLoading: trackingController.isLoading,
                      backgroundColor: kRed,
                      onPressed: () {
                        if (trackingController.isStarted) {
                          trackingController.stopConnection();
                          Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
