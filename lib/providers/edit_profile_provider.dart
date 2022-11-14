import 'package:flutter/material.dart';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_exceptions.dart';
import '../helpers/service_constants.dart';
import '../helpers/security_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:get/get.dart';

import '../widgets/common_widgets/pop_up_dialog.dart';

class EditProfileProvider with ChangeNotifier {
  UserModel? currentUserModel;
  bool isEditing = false;
  AuthService get _authService => GetIt.instance<AuthService>();
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
  final formKey = GlobalKey<FormState>();

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
  }

  ///this function modifies user profile data in database
  Future<void> setUserInfo(UserModel temp) async {
    try {
      var usersDocRef =
          _firestoreService.firebaseFirestore.collection('users').doc(temp.uid);
      await usersDocRef.set(temp.toJson());
      currentUserModel = temp;
      _authProvider.currentUserModel = temp;
      notifyListeners();
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  Future<void> setProfilePic(UserModel temp, String url) async {
    try {
      var udc =  _firestoreService.firebaseFirestore.collection('users').doc(temp.uid);
      await udc.update({"profilepic": url});
      print(udc);
      currentUserModel = temp;
      _authProvider.currentUserModel = temp;
      _authProvider.updateProfilePic(url);
      notifyListeners();
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
    print(temp);
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
    String? username = currentUserModel?.username;
    username ??= "";
    return username;
  }

  String getBio() {
    String? bio = currentUserModel?.bio;
    bio ??= "";
    return bio;
  }

  String getUID() {
    String? uid = currentUserModel?.uid;
    uid ??= "";
    return uid;
  }

  String getDisplayProfileTo() {
    int? val = currentUserModel?.displayProfileTo;
    val ??= 1;
    if (val == 0) {
      return 'no one';
    }
    if (val == 1) {
      return 'only my friends';
    }
    if (val == 2) {
      return 'everyone';
    }
    return '';
  }

  String getDisplayName() {
    bool? val = currentUserModel?.displayName;
    val ??= false;
    if (val) {
      return 'my real name';
    } else {
      return 'my username';
    }
  }

  ///this function returns name or username of user depending on their security settings
  String getPrimaryName(UserModel temp) {
    if (temp.displayName) {
      String fullName = '${temp.firstName} ${temp.lastName}';
      if (fullName.length > 18) {
        fullName = '${fullName.substring(0, 15)}...';
      }
      return fullName;
    }
    return '@${temp.username}';
  }

  ///This function is triggered to send a confirmation email to a new email a user is trying to switch to.
  Future<void> validateNewEmail(String email) async {
    if (formKey.currentState!.validate()) {
      print('validate was true');
      _authProvider.startLoading();
      try {
        await _authService.firebaseAuth.currentUser
            ?.verifyBeforeUpdateEmail(email);
        PopUpDialog.showAcknowledgePopUpDialog(
            title: "Email Sent!",
            message: "Please check your inbox for new email to confirm it.",
            onOkClick: () {
              Get.close(1);
            });
      } on AuthException catch (e) {
        _authProvider.showErrorDialog(e.cause);
      } catch (e) {
        print(e.toString());
        _authProvider.showErrorDialog(e.toString());
      }
      _authProvider.stopLoading();
    }
  }

  ///this function is triggered when the user clicks on Reset button on ForgotPasswordScreen
  Future<void> onResetPassword() async {
    if (formKey.currentState!.validate()) {
      _authProvider.startLoading();
      try {
        await _authService.forgotPassword(email: currentUserModel!.email);
        PopUpDialog.showAcknowledgePopUpDialog(
            title: "Email Sent!",
            message:
                "Please check your inbox for instructions on how to reset your password",
            onOkClick: () {
              Get.close(1);
            });
      } on AuthException catch (e) {
        _authProvider.showErrorDialog(e.cause);
      } catch (e) {
        _authProvider.showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      }
      _authProvider.stopLoading();
    }
  }

  void uploadImage(String fileName) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);
  }

  String getUserProfilePic() {
    return currentUserModel!.profilepic;
  }

  ///this function shows an error dialog
  void showErrorDialog(String message) {
    PopUpDialog.showAcknowledgePopUpDialog(
        title: "Error!",
        message: message,
        onOkClick: () {
          Get.close(1);
        });
  }

  void updateDisplayName(String? value) {
    value ??= "";
    print(currentUserModel.toString());
    print(getUserProfilePic());
    UserModel temp = currentUserModel!;
    print(temp.toString());
    bool val = false;
    if (value == 'my real name') {
      val = true;
    } else if (value == 'my username') {
      val = false;
    }
    temp.displayName = val;
    print(temp.toString());
    try {
      setUserInfo(UserModel.fromJson(temp.toJson()));
    } on FirestoreException catch (e) {
      showErrorDialog(e.cause);
    }
  }

  void updateDisplayProfileTo(String? value) {
    value ??= "";
    UserModel temp = currentUserModel!;
    print(temp.toString());
    int val = -1;
    if (value == SecurityConstants.PROFILEPAGESETTINGS[SecurityConstants.NOONE]) {
      val = SecurityConstants.NOONE;
    } else if (value == SecurityConstants.PROFILEPAGESETTINGS[SecurityConstants.ONLYFRIENDS]) {
      val = SecurityConstants.ONLYFRIENDS;
    } else if (value == SecurityConstants.PROFILEPAGESETTINGS[SecurityConstants.EVERYONE]) {
      val = SecurityConstants.EVERYONE;
    }
    temp.displayProfileTo = val;
    print(temp.toString());
    try {
      setUserInfo(UserModel.fromJson(temp.toJson()));
    } on FirestoreException catch (e) {
      showErrorDialog(e.cause);
    }
  }

  Future<void> update(UserModel temp) async {
    _authProvider.startLoading();
    formKey.currentState!.save();
    try {
      if (currentUserModel!.username.compareTo(temp.username) != 0) {
        await _firestoreService.doesUsernameAlreadyExist(
            username: temp.username);
      }
      if (formKey.currentState!.validate()) {
        swapEditingMode();
        if (currentUserModel!.email.compareTo(temp.email) != 0) {
          validateNewEmail(temp.email);
        }
        if (!isEditing) {
          setUserInfo(UserModel.fromJson(temp.toJson()));
        }
      }
    } on FirestoreException catch (e) {
      showErrorDialog(e.cause);
    }
    _authProvider.stopLoading();
  }
}
