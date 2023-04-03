import 'package:fitzen_frontend/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier{
  int _poorPostureNotificationInterval = 5;
  int _lowBlinkCountNotification = ON;
  int _twentyTwentyTwentyNotification = ON;

  int get poorPostureNotificationInterval => _poorPostureNotificationInterval;

  int get lowBlinkCountNotification => _lowBlinkCountNotification;

  int get twentyTwentyTwentyNotification => _twentyTwentyTwentyNotification;

  set poorPostureNotificationInterval(int value) {
    _poorPostureNotificationInterval = value;
    notifyListeners();
    _saveToStorage();
  }

  set twentyTwentyTwentyNotification(int value) {
    _twentyTwentyTwentyNotification = value;
    notifyListeners();
    _saveToStorage();
  }

  set lowBlinkCountNotification(int value) {
    _lowBlinkCountNotification = value;
    notifyListeners();
    _saveToStorage();
  }

  _saveToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(POOR_POSTURE_KEY, _poorPostureNotificationInterval);
    prefs.setInt(LOW_BLINK_COUNT_KEY, _lowBlinkCountNotification);
    prefs.setInt(TWENTY_TWENTY_TWENTY_KEY, _twentyTwentyTwentyNotification);
  }

  fetchFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _poorPostureNotificationInterval = prefs.getInt(POOR_POSTURE_KEY) ?? _poorPostureNotificationInterval;
    _lowBlinkCountNotification = prefs.getInt(LOW_BLINK_COUNT_KEY) ?? _lowBlinkCountNotification;
    _twentyTwentyTwentyNotification = prefs.getInt(TWENTY_TWENTY_TWENTY_KEY) ?? _twentyTwentyTwentyNotification;
  }
}