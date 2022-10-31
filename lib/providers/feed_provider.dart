import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

class FeedProvider with ChangeNotifier {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot<Object?>>? currentSnapshot;

  bool isLoading = false;
  bool areVariablesInitialized = false;

  void initializeVariables() {
    areVariablesInitialized = false;
    isLoading = false;

    areVariablesInitialized = true;
    notifyListeners();
  }




}