import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:harmony_app/screens/sign_up_screen.dart';
import 'package:harmony_app/services/auth_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';

import '../screens/forgot_password_screen.dart';

class AuthProvider with ChangeNotifier {
  AuthService get _authService => GetIt.instance<AuthService>();

  //LoginScreen text editing controllers
  TextEditingController loginEmailTextEditingController =
      TextEditingController();
  TextEditingController loginPasswordTextEditingController =
      TextEditingController();

  //ForgotPasswordScreen text editing controllers
  TextEditingController forgotPasswordEmailTextEditingController =
      TextEditingController();

  //SignUpScreen text editing controllers
  TextEditingController signUpEmailTextEditingController =
      TextEditingController();
  TextEditingController signUpPasswordTextEditingController =
      TextEditingController();
  TextEditingController signUpReEnterPasswordTextEditingController =
      TextEditingController();
  TextEditingController signUpFirstNameTextEditingController =
      TextEditingController();
  TextEditingController signUpLastNameTextEditingController =
      TextEditingController();

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
      String loginResult = await _authService.loginUser(
          email: loginEmailTextEditingController.text,
          password: loginPasswordTextEditingController.text);
      print(loginResult);
      if (loginResult == ServiceConstants.SUCCESS) {
        //todo redirect user to HomePage
      } else {
        PopUpDialog.showAcknowledgePopUpDialog(
            title: "Error!",
            message: loginResult,
            onOkClick: () {
              Get.close(1);
            });
      }
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
