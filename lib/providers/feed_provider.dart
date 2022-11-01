import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/feed_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

class FeedProvider with ChangeNotifier {
  AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot<Object?>>? currentSnapshot;

  FeedService get _feedService => GetIt.instance<FeedService>();


  bool isLoading = false;
  bool areVariablesInitialized = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController? textEditingController =
  TextEditingController();

  void initializeVariables() {
    areVariablesInitialized = false;
    isLoading = false;

    areVariablesInitialized = true;
    notifyListeners();
  }

  Future<void> createPost() async {
    _authProvider.startLoading();
    formKey.currentState!.save();

    try {
      debugPrint(textEditingController!.text);
      if (formKey.currentState!.validate()) {
        await _feedService.addPostToFirestore(
            text: textEditingController!.text,
            username: _authProvider.currentUserModel!.username,
            uid: _authProvider.currentUserModel!.uid,
            dateTime: Timestamp.now()
        );
      }
    } on FirestoreException catch (e) {
      debugPrint('failed addPostoFirestore');
      showErrorDialog(e.cause);
    }

  }

}


///this function shows an error dialog
void showErrorDialog(String message) {
  PopUpDialog.showAcknowledgePopUpDialog(
      title: "Error!",
      message: message,
      onOkClick: () {
        Get.close(1);
      });
}