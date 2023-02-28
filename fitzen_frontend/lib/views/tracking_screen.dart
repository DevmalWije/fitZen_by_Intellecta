import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          children: [
            //camera view and status
            IntrinsicHeight(
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

                  //start button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Stop Tracking",
                          style: Theme.of(context).textTheme.button,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
