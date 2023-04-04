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

      print("$API/$endpoint");
      String exception = "";
      try {
        exception = jsonDecode(response.body)['error'];
      } catch (e) {
        exception = response.body;
      }

      throw HttpException(exception);
    } catch (e) {
      if (onError != null) onError(e.toString());
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
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
