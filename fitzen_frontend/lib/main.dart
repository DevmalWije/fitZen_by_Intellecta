import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){
  runApp(FitZen());
}

class FitZen extends StatelessWidget {
  const FitZen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: GoogleFonts.dmSansTextTheme(
          TextTheme(
            headline1: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            caption: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w400,
            ),
            button: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: Home(),
    );
  }
}
