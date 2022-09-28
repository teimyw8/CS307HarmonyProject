import 'package:firebase_auth/firebase_auth.dart';
import 'package:harmony_app/helpers/service_constants.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ///this function makes a Login request to FirebaseAuth.
  ///RETURN VALUES:
  /// SUCCESS
  /// WRONGCREDENTIALS
  /// ACCOUNTNOTFOUND
  /// SOMETHINGWENTWRONG
  Future<String> loginUser({required String email, required String password}) async {
    try {
      print("BEFORE LOGIN");
      var loginInResult = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print("loginInResult: $loginInResult");
      return ServiceConstants.SUCCESS;
    } catch (e) {
      print(e);
      return ServiceConstants.SOMETHINGWENTWRONG;
    }
  }

  ///this function makes a Logout request to FirebaseAuth.
  ///RETURN VALUES:
  /// SUCCESS
  /// SOMETHINWENTWRONG
  Future<String> logoutUser() async {
    try {
      await firebaseAuth.signOut();
      return ServiceConstants.SUCCESS;
    } catch (e) {
      return ServiceConstants.SOMETHINGWENTWRONG;
    }
  }
}