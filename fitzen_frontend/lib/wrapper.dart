import 'package:fitzen_frontend/controllers/user_controller.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/views/login.dart';
import 'package:fitzen_frontend/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context);

    return FutureBuilder<bool>(
      future: userController.isUserSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return snapshot.data! ? SplashScreen() : Login();
      },
    );
  }
}
