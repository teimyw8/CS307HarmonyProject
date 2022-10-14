import 'package:firebase_auth/firebase_auth.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/service_constants.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///this function makes a Login request to FirebaseAuth.
  ///THROWS AuthException IF FAILS
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        throw AuthException(ServiceConstants.ACCOUNTNOTFOUND);
      } else if (e.code == 'wrong-password') {
        throw AuthException(ServiceConstants.WRONGCREDENTIALS);
      }
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    } catch (e) {
      print(e);
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function makes a SignUp request to FirebaseAuth.
  ///THROWS AuthException IF FAILS
  Future<void> signUpUser(
      {required String email,
      required String password,}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException(ServiceConstants.ACCOUNTALREADYEXISTS);
      }
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    } catch (e) {
      print('threw from something else');
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function makes a Logout request to FirebaseAuth.
  ///THROWS AuthException IF FAILS
  Future<void> logoutUser() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function makes a forgot password request to FirebaseAuth.
  ///THROWS AuthException IF FAILS
  Future<void> forgotPassword(
      {required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(ServiceConstants.ACCOUNTNOTFOUND);
      }
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    } catch (e) {
      throw AuthException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

}
