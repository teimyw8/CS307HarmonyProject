import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:get/get.dart';

class EditProfileProvider with ChangeNotifier {
  UserModel? currentUserModel;
  bool isEditing = false;
  AuthService get _authService => GetIt.instance<AuthService>();
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  EditProfileProvider() {
    currentUserModel = _authProvider.currentUserModel;
  }

  ///this function is used to swap into or out of editing mode
  void swapEditingMode() {
    if (isEditing) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    print(isEditing);
  }

  ///this function modifies user profile data in database
  Future<void> setUserInfo(String uid, String json) async {

    notifyListeners();
  }

  bool meetsUsernameReqs(String username) {
    if (username.length < 5 || username.length > 15) {
      return false;
    }

    for (int i = 0; i < username.length; i++) {
      String c = username.substring(i, i + 1);
      if (!c.isNum && !c.isAlphabetOnly && c.compareTo(".") != 0) {
        return false;
      }
    }

    //TODO: check to see if username already exists
    return true;
  }

  bool meetsPasswordReqs(String password) {
    if (password.length < 8 || password.length > 26) {
      return false;
    }

    bool containsNum = false;
    bool containsSpecial = false;
    for (int i = 0; i < password.length; i++) {
      String c = password.substring(i, i + 1);
      if (c.isNum) {
        containsNum = true;
      } else if (!c.isAlphabetOnly) {
        containsSpecial = true;
      }
    }
    return containsNum && containsSpecial;
  }

  String getUserEmail() {
    return currentUserModel!.email;
  }

  String getUserFirst() {
    return currentUserModel!.firstName;

  }

  String getUserLast() {
    return currentUserModel!.lastName;
  }

  String getUserName() {
    String? username = currentUserModel?.userName;
    username ??= "";
    return username;
  }

  /*
  Future<void> syncProfile() {

  }

   */
}
