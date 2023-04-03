import 'package:fitzen_frontend/controllers/settings_controller.dart';
import 'package:fitzen_frontend/controllers/user_controller.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    super.initState();
    Provider.of<SettingsController>(context, listen: false).fetchFromStorage();
  }
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

        return snapshot.data! ? Home() : Login();
      },
    );
  }
}
