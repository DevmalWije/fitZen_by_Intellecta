import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class APIService {
  Future sendGETRequest(String endpoint, {Function? onError}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('idToken');
      var response = await http.get(
        Uri.parse("$API/$endpoint"),
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      String exception = "";
      bool isLogout = false;
      try {
        exception = jsonDecode(response.body)['error'];
        isLogout = true;
      } catch (e) {
        exception = response.body;
      }

      throw HttpException(exception, logout: isLogout);
    } catch (e) {
      if (e is HttpException) {
        if (onError != null) onError(e.message, e.logout);
        return null;
      }

      if (onError != null) onError(e.toString(), false);
      return null;
    }
  }

Future<Map?> sendPOSTRequest(String endpoint, Map<String, dynamic> body,
    {Function? onError}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> headers = {"Content-Type": "application/json"};
    headers['Authorization'] = 'Bearer $token';

    var response = await http.post(
      Uri.parse("$API/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    String exception = "";
    try {
      exception = jsonDecode(response.body)['error'];
    } catch (e) {
      exception = response.body;
    }

    throw HttpException(exception);
  } catch (e) {
    if (onError != null) onError(e);
    return null;
  }
}
}

class HttpException implements Exception {
  final String message;
  final bool logout;

  HttpException(this.message, {this.logout = false});

  @override
  String toString() {
    return message;
  }
}
