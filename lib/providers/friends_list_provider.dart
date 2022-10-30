import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

class FriendsListProvider with ChangeNotifier {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();

  var currUser;
  late List<dynamic> friendsList;

  void refresh() {
    Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider myAuthProvider,
          Widget? child) {
        myAuthProvider.updateCurrentUser();
        currUser = (myAuthProvider.currentUserModel?.uid);
        friendsList = (myAuthProvider.currentUserModel?.friends)!;
        return const SizedBox.shrink();
      },
    );
  }

  ///this function retrieves user information for requested uid
  Future<void> getUserModel(UserModel? temp, String uid) async {
    var userDocData = await _firestoreService.retrieveUserFromFirestore(
        uid: uid);
    temp = UserModel.fromJson(userDocData!);
  }

}