import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                  SizedBox(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Colors.white.withOpacity(0.25),
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    ),
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
