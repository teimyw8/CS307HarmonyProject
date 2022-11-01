import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  ChatService get _chatService => GetIt.instance<ChatService>();

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  ///this function adds a new chat in firestore
  Future<void> createNewChat({required String partnerId}) async {
    try {
      String chatId = "${DateTime.now().microsecondsSinceEpoch}";
      ChatModel chatModel = ChatModel(
          uid1: authProvider.currentUserModel!.uid,
          uid2: partnerId,
          chatId: chatId,
          lastMessage: "",
          lastEdited: DateTime.now());
      await _chatService.createNewChatInFirebaseFirestore(chatModel: chatModel);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function sends a new message to chat
  Future<void> sendMessageToChat(
      {required String chatId, required String message}) async {
    try {
      MessageModel messageModel = MessageModel(
          message: message,
          dateSent: DateTime.now(),
          messageId: DateTime.now().toString(),
          isRead: false,
          fromUserId: authProvider.currentUserModel!.uid);
      _chatService.sendMessageToChat(
          messageModel: messageModel, chatId: chatId);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function retrieves a partnerUserModel for a chat from Firestore
  Future<dynamic> getPartnerUserModelFromFirestore(
      {required String uid}) async {
    try {
      print("HELLo");

      var userDoc = await _firestoreService.retrieveUserFromFirestore(uid: uid);
      print("userDoc: ${userDoc}");
      UserModel userModel = UserModel.fromJson(userDoc);
      return userModel;
    } on FirestoreException catch (e) {
      print(e.cause);
      _showErrorDialog(e.cause);
    } catch (e) {
      print(e);
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function shows an error dialog
  void _showErrorDialog(String message) {
    PopUpDialog.showAcknowledgePopUpDialog(
        title: "Error!",
        message: message,
        onOkClick: () {
          Get.close(1);
        });
  }
}
