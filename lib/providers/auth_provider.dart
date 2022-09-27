import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/screens/sign_up_screen.dart';

import '../screens/forgot_password_screen.dart';

class AuthProvider with ChangeNotifier {
  //this is a key used for Form inside LoginScreen()
  final loginKey = GlobalKey<FormState>();

  //this is a key used for Form inside SignUpScreen()
  final signUpKey = GlobalKey<FormState>();

  //this is a key used for Form inside ResetPasswordScreen()
  final resetPasswordKey = GlobalKey<FormState>();

  ///this function logs user in. If the login is successful, then they get redirected to HomeScreen. Else a pop up message
  ///with an appropriate error shows up.
  Future<void> loginUser() async {
    if (loginKey.currentState!.validate()) {
      //todo log user in through Firebase and redirect user to HomePage
    }
  }

  ///this function is triggered when the user clicks on Sign Up button on SignUpScreen
  Future<void> signUpUser() async {
    if (signUpKey.currentState!.validate()) {}
  }

  ///this function is triggered when the user clicks on ForgotPassword text
  Future<void> onForgotPasswordTextClicked() async {
    Get.to(() => ForgotPasswordScreen());
  }

  ///this function is triggered when the user clicks on SignUp text
  Future<void> onSignUpTextClicked() async {
    Get.to(() => SignUpScreen());
  }

  ///this function is triggered when the user clicks on Reset button on ForgotPasswordScreen
  Future<void> onResetPasswordClicked() async {
    if (resetPasswordKey.currentState!.validate()) {}
  }
}
