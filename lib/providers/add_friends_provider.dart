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
  Future<void> initializeVariables() async {
    areVariablesInitialized = false;

    searchBarEditingController = TextEditingController();
    isLoading = false;
    suggestedFriendsList = await getSuggestedFriends();

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

/*  int getUserModelIndex(List<dynamic> userModels, String uid) {
    for (int i = 0; i < userModels.length; i++) {
      if (userModels[i] == uid) {
        return i;
      }
    }
    print("ERROR: uid didn't match to any UserModels in friends list.");
    return -1;
  }*/

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
    friends = [];
    for (int i = 0; i < friendsLists.length; i++) {
      friends = friendsLists[i];
      for (int j = 0; j < friends.length; j++) {
        String friendUid = friends[j];
        if (currentUser.uid != friendUid &&
            !currentUser.friends.contains(friendUid)) {
/*          if (!overlap.containsKey(friendUid)) {
            var userDocData =
            await _firestoreService.retrieveUserFromFirestore(uid: friendUid);
            friends.add(UserModel.fromJson(userDocData!));
            if (!friends.last.blockedUsers.contains(currentUser.uid)) {
              overlap.update(friendUid, (value) => value++, ifAbsent: () => 1);
            }
          } else {
            overlap.update(friendUid, (value) => value++, ifAbsent: () => 1);
          }*/
          overlap.update(friendUid, (value) => ++value, ifAbsent: () => 1);
        }
      }
    }

    List<Pair> pairs = [];
    overlap.forEach((key, value) {
      pairs.add(Pair(key, value));
    });
    pairs.sort((a, b) => a.appearances.compareTo(b.appearances));

    List<dynamic> toReturn = [];
    int index;
    int count = 0;
    for (index = pairs.length - 1; index >= 0 && count < 30; index--) {
/*      int friendsInd = getUserModelIndex(friends, pairs[index].uid);
      toReturn.add(friends[friendsInd]);
      friends.removeAt(friendsInd);*/
      var userDocData =
      await _firestoreService.retrieveUserFromFirestore(uid: pairs[index].uid);
      friend = UserModel.fromJson(userDocData!);
      print(pairs[index]);
      if (!friend.blockedUsers.contains(currentUser.uid)) {
        toReturn.add(friend);
        count++;
      }
    }

    return toReturn;
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

class Pair {
  String uid;
  int appearances;
  Pair(this.uid, this.appearances);

  @override
  String toString() {
    return '{ ${this.uid}, ${this.appearances} }';
  }
}
