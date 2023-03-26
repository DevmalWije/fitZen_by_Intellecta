import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/views/login.dart';
import 'package:fitzen_frontend/views/signup.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/views/settings.dart';
import 'package:fitzen_frontend/views/tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    center: true,
    title: "FitZen",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.setResizable(false);
    await windowManager.setMaximizable(false);
    await windowManager.focus();
  });
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
        primaryColor: kBlue,
        textTheme: GoogleFonts.dmSansTextTheme(
          TextTheme(
            headline1: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            headline2: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0xff505050),
            ),
            caption: TextStyle(
              fontSize: 24,
              color: Colors.white,
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
      home: Login(),
    );
  }
}
