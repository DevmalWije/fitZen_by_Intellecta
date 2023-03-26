import 'package:firedart/auth/user_gateway.dart';
import 'package:fitzen_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  final AuthService _authService = AuthService();

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
      prefs.clear();
    }
  }

}