import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class FriendScreenProvider with ChangeNotifier {
  FirestoreService get firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
  bool isLoading = false;

  // ///this function blocks the user
  // Future<void> blockUser({required String uid}) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     await firestoreService.blockUser(
  //         currentUserUID: authProvider.currentUserModel!.uid, blockUID: uid);
  //   } catch (e) {
  //
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }
}
