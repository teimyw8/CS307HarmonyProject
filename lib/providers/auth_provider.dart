import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  //this is a key used for Form inside LoginScreen()
  final loginKey = GlobalKey<FormState>();

  ///this function logs user in. If the login is successful, then they get redirected to HomeScreen. Else a pop up message
  ///with an appropriate error shows up.
  Future<void> loginUser() async {
    if (loginKey.currentState!.validate()) {

    }
  }
}