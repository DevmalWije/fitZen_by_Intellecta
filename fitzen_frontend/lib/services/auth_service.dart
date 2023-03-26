import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';

class AuthService{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password, {required Function onError}) async {
    try {
      User user = await auth.signUp(email, password);
      return user;
    } on AuthException catch (e) {
      onError(e);
      return null;
    } catch(e){
      onError(e);
      return null;
    }
  }

  Future<String> getIDToken() async {
    return await auth.tokenProvider.idToken;
  }

  void signOut() async {
    auth.signOut();
  }
}