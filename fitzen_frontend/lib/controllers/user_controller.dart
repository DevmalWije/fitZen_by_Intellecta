import 'dart:async';

import 'package:firedart/auth/user_gateway.dart';
import 'package:fitzen_frontend/models/user_data.dart';
import 'package:fitzen_frontend/services/api_service.dart';
import 'package:fitzen_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  final AuthService _authService = AuthService();
  final APIService _apiService = APIService();

  Future<bool> signUp(String email, String password, {required Function onError}) async {
    User? user = await _authService.signUp(email, password, onError: onError);
    if(user != null){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('uid', user.id);
      String idToken = await _authService.getIDToken();
      preferences.setString('idToken', idToken);
    }

    return user != null;
  }

  Future<bool> signIn(String email, String password, {required Function onError}) async {
    User? user = await _authService.signIn(email, password, onError: onError);
    if(user != null){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('uid', user.id);
      String idToken = await _authService.getIDToken();
      preferences.setString('idToken', idToken);
    }

    return user != null;
  }

  Future<bool> isUserSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idToken = prefs.getString("idToken");
    return idToken != null;
  }

  Future<void> signOut() async {
    try{
      _authService.signOut();
    } finally {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('idToken');
      prefs.remove('uid');
    }
  }


  Future<UserData?> fetchData(BuildContext context) async {
    //fetch user data from the database
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";

    Map? result = await _apiService.sendGETRequest("sessions?uid=$uid", onError: (e) async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e),
        backgroundColor: Colors.red,
      ));
    });

    if(result != null){
      UserData userData = UserData.fromJson(result);
      return userData;
    }

    return null;
  }
}