import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/user_controller.dart';
import 'package:fitzen_frontend/views/login.dart';
import 'package:fitzen_frontend/views/settings.dart';
import 'package:fitzen_frontend/views/tracking_screen.dart';
import 'package:fitzen_frontend/widgets/summary_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fitzen_frontend/widgets/button.dart';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 50,
                ),
                Expanded(child: SizedBox.shrink()),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => Settings(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 25,
                  ),
                ),
                SizedBox(width: 30),
                IconButton(
                  onPressed: () async {
                    await Provider.of<UserController>(context, listen: false).signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: kRed,
                    size: 25,
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
                    title: "Poor Postures",
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
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: kDarkGray,
                          width: 3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Previous Session",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: kDarkGray,
                              ),
                            ),
                            SizedBox(height: 20),

                            //chart
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PieChart(
                                        dataMap: {"Good": 25, "Bad": 75},
                                        animationDuration: Duration(milliseconds: 800),
                                        chartLegendSpacing: 40,
                                        colorList: [kGreen, kRed],
                                        chartType: ChartType.ring,
                                        ringStrokeWidth: 30,
                                        centerText: "Posture",
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.right,
                                          showLegends: true,
                                          legendShape: BoxShape.circle,
                                          legendTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: true,
                                          showChartValuesInPercentage: true,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SummaryCard(
                                            title: "Screen Time",
                                            value: "1hr 00mins",
                                            color: kBlue,
                                            padding: EdgeInsets.all(10),
                                            titleSize: 20,
                                            valueSize: 30,
                                          ),
                                          SizedBox(height: 10),
                                          SummaryCard(
                                            title: "Eye Strain Level",
                                            value: "Good",
                                            color: kGreen,
                                            padding: EdgeInsets.all(10),
                                            titleSize: 20,
                                            valueSize: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: kYellow, width: 2,),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/suggestion.png',
                                          width: 40,
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Text(
                                            "Want to prevent from computer related health issues?",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: kDarkGray,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: kYellow,
                                        textStyle: GoogleFonts.dmSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: Text("Suggestions"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          //start button
                          SizedBox(
                            width: double.infinity,
                            child: Button(
                              text: "Start Tracking",
                              icon: Icons.timer_outlined,
                              backgroundColor: kGreen,
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => TrackingScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
