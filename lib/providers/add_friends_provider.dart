import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class AddFriendsProvider with ChangeNotifier {
  TextEditingController? searchBarEditingController;
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider _authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot<Object?>>? currentSnapshot;

  void initializeVariables() {
    searchBarEditingController = TextEditingController();
  }

  void disposeVariables() {
    searchBarEditingController!.dispose();
    searchBarEditingController = null;
  }


  void sendFriendRequest({required String sendToUID}) {
    try {
      _firestoreService.sendFriendRequestToUser(sendToUID: sendToUID, sendFromUID: _authProvider.currentUserModel!.uid);
    } catch (e) {

    }
  }

}