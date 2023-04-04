import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/settings_controller.dart';
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
    await Provider.of<TrackingController>(context, listen: false)
        .startConnection(context, Provider.of<SettingsController>(context, listen: false));
  }

  @override
  void initState() {
    super.initState();
    startTracking();
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
              SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SummaryCard(
                      title: "Current Posture",
                      value: trackingController.posture,
                      color: trackingController.posture == "Good" ? kGreen : kRed,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    ),
                    SizedBox(height: 10),
                    SummaryCard(
                      title: "Last 30 Seconds Eye Strain Level",
                      value: trackingController.eyeHealth,
                      color: trackingController.eyeHealth == "Good" ? kGreen : kRed,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    ),
                    SizedBox(height: 10),
                    SummaryCard(
                      title: "Current Screen Time",
                      value: trackingController.elapsedSeconds,
                      color: kBlue,
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    ),
                    Expanded(child: SizedBox.shrink()),
                    Button(
                      text: "Stop Tracking",
                      icon: Icons.timer_outlined,
                      isLoading: trackingController.isLoading,
                      backgroundColor: kRed,
                      onPressed: () async {
                        if (trackingController.isStarted) {
                          await trackingController.stopConnection();
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
