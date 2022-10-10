import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firestore_service.dart';

class EditProfileProvider with ChangeNotifier {
  bool isEditing = false;
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();


  ///this function is used to swap into or out of editing mode
  void swapEditingMode() {
    if (isEditing) {
      isEditing = false;
    } else {
      isEditing = true;
    }
  }
}