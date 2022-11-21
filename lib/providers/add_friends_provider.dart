import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class AddFriendsProvider with ChangeNotifier {
  TextEditingController? searchBarEditingController;

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider _authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot<Object?>>? currentSnapshot;
  List<dynamic> suggestedFriendsList = [];

  bool isLoading = false;
  bool areVariablesInitialized = false;
  void initializeVariables() {
    areVariablesInitialized = false;

    searchBarEditingController = TextEditingController();
    isLoading = false;
    suggestedFriendsList = getSuggestedFriends();

    areVariablesInitialized = true;
    notifyListeners();
  }

  void disposeVariables() {
    searchBarEditingController!.dispose();
    searchBarEditingController = null;
    isLoading = false;
    areVariablesInitialized = false;
    notifyListeners();
  }

  void sendFriendRequest({required String sendToUID}) {
    startLoading();
    try {
      _firestoreService.sendFriendRequestToUser(
          sendToUID: sendToUID,
          sendFromUID: _authProvider.currentUserModel!.uid);
      _authProvider.currentUserModel!.friendRequestsSent.add(sendToUID);
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

  Future<List> getSuggestedFriends() async {
    UserModel currentUser = _authProvider.currentUserModel!;
    List<List<dynamic>> friendsLists = [];
    List<dynamic> friends = currentUser.friends;
    UserModel friend;

    //retrieves all of friends' friends
    for (int i = 0; i < friends.length; i++) {
      var userDocData =
          await _firestoreService.retrieveUserFromFirestore(uid: friends[i]);
      friend = UserModel.fromJson(userDocData!);
      friendsLists.add(friend.friends);
    }

    //counts how many times a friends' friend appears
    Map<String, int> overlap = HashMap();
    for(int i = 0; i < friendsLists.length; i++) {
      friends = friendsLists[i];
      for (int j = 0; j < friends.length; j++) {
        String friendUid = friends[j];
        if (currentUser.uid != friendUid && !currentUser.friends.contains(friendUid)) {
          if (!overlap.containsKey(friendUid)) {
            var userDocData =
            await _firestoreService.retrieveUserFromFirestore(uid: friendUid);
            friend = UserModel.fromJson(userDocData!);
            if (!friend.blockedUsers.contains(currentUser.uid)) {
              overlap.update(friendUid, (value) => value++, ifAbsent: () => 1);
            }
          } else {
            overlap.update(friendUid, (value) => value++, ifAbsent: () => 1);
          }
        }
      }
    }
    return [];
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
