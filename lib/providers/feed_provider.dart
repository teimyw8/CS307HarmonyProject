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

  TextEditingController? songTextEditingController =
  TextEditingController();

  TextEditingController? artistTextEditingController =
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
            song: "",
            artist: "",
            text: textEditingController!.text,
            username: _authProvider.currentUserModel!.username,
            uid: _authProvider.currentUserModel!.uid,
            dateTime: Timestamp.now(),
            isPost: "true"
        );
      }
    } on FirestoreException catch (e) {
      debugPrint('failed addPostoFirestore');
      showErrorDialog(e.cause);
    }
  }

  Future<void> createDailyPost() async {
    _authProvider.startLoading();
    formKey.currentState!.save();

    try {
      print(textEditingController!.text);
      if (formKey.currentState!.validate()) {
        await _feedService.addPostToFirestore(
            song: songTextEditingController!.text,
            artist: artistTextEditingController!.text,
            text: "Here is my song of the day!",
            username: _authProvider.currentUserModel!.username,
            uid: _authProvider.currentUserModel!.uid,
            dateTime: Timestamp.now(),
            isPost: "false"
        );
      }
    } on FirestoreException catch (e) {
      debugPrint('failed addPostoFirestore');
      showErrorDialog(e.cause);
    }
  }

  List listOfUsers() {
    List uidList = (_authProvider.currentUserModel?.friends)!;
    if (!uidList.contains(_authProvider.currentUserModel!.uid)) {
      uidList.add(_authProvider.currentUserModel!.uid);
    }
    return uidList;
  }

  List<PostModel> lastDayOnly(List<PostModel> posts) {
    //filter chronologically from newest to oldest
    posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    //remove all the old ones.
    var it = posts.iterator;
    var toRemove = [];

    //you can't remove items directy when using an iterator
    while (it.moveNext()) {
      Duration difference = DateTime.now().difference(it.current.dateTime.toDate());
      if (difference.inHours > 24) {
        //add this elements for removal after this while.
        toRemove.add(it.current);
      }
    }

    //remove the elements marked
    posts.removeWhere((e) => toRemove.contains(e));


    return posts;
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