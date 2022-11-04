import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/security_constants.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';
import 'edit_profile_provider.dart';

class FriendsListProvider with ChangeNotifier {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  var currUser;
  late List<dynamic> friendsList;
  UserModel? temp;

  void refresh() {
    Consumer<AuthProvider>(
      builder:
          (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
        myAuthProvider.updateCurrentUser();
        currUser = (myAuthProvider.currentUserModel?.uid);
        friendsList = (myAuthProvider.currentUserModel?.friends)!;
        return const SizedBox.shrink();
      },
    );
  }

  ///this function retrieves user information for requested uid
  Future<void> setUserModel(String uid) async {
    var userDocData =
        await _firestoreService.retrieveUserFromFirestore(uid: uid);
    temp = UserModel.fromJson(userDocData!);
  }

  ///this function returns true if currUser can't see temp's full profile, false otherwise
  bool isPrivateUser(UserModel temp) {
    if (temp.displayProfileTo == SecurityConstants.NOONE) {
      return true;
    }
    if (temp.displayProfileTo == SecurityConstants.ONLYFRIENDS &&
        !temp.friends.contains(_editProfileProvider.currentUserModel?.uid)) {
      return true;
    }
    return false;
  }
}
