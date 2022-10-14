import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/services/firestore_service.dart';

class AddFriendsProvider with ChangeNotifier {
  TextEditingController? searchBarEditingController;
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  Stream<QuerySnapshot<Object?>>? currentSnapshot;

  void initializeVariables() {
    searchBarEditingController = TextEditingController();
  }

  void disposeVariables() {
    searchBarEditingController!.dispose();
    searchBarEditingController = null;
  }

  void onSearchQueryChanged() async {
    currentSnapshot = await _firestoreService.getUsersSnapshotByUsernameQuery(usernameQuery: searchBarEditingController!.text);
  }

}