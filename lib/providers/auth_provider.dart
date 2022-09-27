import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  //this is a key used for Form inside LoginScreen()
  final loginKey = GlobalKey<FormState>();

  ///this function logs user in. If the login is successful, then they get redirected to HomeScreen. Else a pop up message
  ///with an appropriate error shows up.
  Future<void> loginUser() async {
    if (loginKey.currentState!.validate()) {
      //todo log user in through Firebase and redirect user to HomePage
    }
  }

  ///this function is triggered when the user clicks on ForgotPassword text
  Future<void> onForgotPasswordTextClicked() async {

  }

  ///this function is triggered when the user clicks on SignUp text
  Future<void> onSignUpTextClicked() async {

  }
}