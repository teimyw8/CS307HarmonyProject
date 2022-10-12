import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'package:get/get.dart';

class EditProfileProvider with ChangeNotifier {
  UserModel? currentUserModel;
  bool isEditing = false;
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
