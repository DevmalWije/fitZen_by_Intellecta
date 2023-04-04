import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/views/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: FadeTransition(
          opacity: _animationController,
          child: Image.asset(
            'assets/logo.png',
            width: 150.0,
            height: 150.0,
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(
//     MaterialApp(
//       title: 'Splash Screen App',
//       home: SplashScreen(),
//     ),
//   );
// }
