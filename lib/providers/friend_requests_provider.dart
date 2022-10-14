import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

class FriendRequestsProvider with ChangeNotifier {

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot<Object?>>? currentSnapshot;

  List<UserModel> friendRequestsReceived = [];

  bool isLoading = false;

  void initializeVariables() {
    isLoading = false;
    friendRequestsReceived = [];
    getFriendRequestsReceived();
    notifyListeners();
  }

  void disposeVariables() {
    isLoading = false;
    friendRequestsReceived = [];
    notifyListeners();
  }

  ///this function retrieves every user that sent a friend request to the current user
  void getFriendRequestsReceived() async {
    startLoading();
    try {
      List<dynamic> friendRequestsReceived = await _firestoreService.getFriendRequestsReceived(
          currentUserModelUID: _authProvider.currentUserModel!.uid);
      for (String uid in friendRequestsReceived) {
        var userDoc = await _firestoreService.retrieveUserFromFirestore(uid: uid);
        UserModel userModel = UserModel.fromJson(userDoc);
        friendRequestsReceived.add(userModel);
      }
      notifyListeners();
    } on FirestoreException catch (e) {
      PopUpDialog.showAcknowledgePopUpDialog(
          title: "Error!",
          message: e.cause,
          onOkClick: () {
            Get.close(1);
          });
    }
    stopLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }
  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }


}