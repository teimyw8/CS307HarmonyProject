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
  Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ServiceConstants.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ServiceConstants.ACCOUNTNOTFOUND;
      } else if (e.code == 'wrong-password') {
        return ServiceConstants.WRONGCREDENTIALS;
      }
      return ServiceConstants.SOMETHINGWENTWRONG;
    } catch (e) {
      return ServiceConstants.SOMETHINGWENTWRONG;
    }
  }

  ///this function makes a SignUp request to FirebaseAuth.
  /// RETURN VALUES:
  /// SUCCESS
  /// ACCOUNTALREADYEXISTS
  /// SOMETHINGWENTWRONG
  Future<dynamic> signUpUser(
      {required String email,
      required String password,}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return ServiceConstants.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-already-exists') {
        return ServiceConstants.ACCOUNTALREADYEXISTS;
      }
      return ServiceConstants.SOMETHINGWENTWRONG;
    } catch (e) {
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
