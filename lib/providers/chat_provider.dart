import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/helper_functions.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/chat_screen.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  ChatService get _chatService => GetIt.instance<ChatService>();

  bool doesChatExistInFirestore = true;
  bool areVariablesInitialized = false;

  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  void initializeVariables({required bool doesChatExist}) {
    doesChatExistInFirestore = doesChatExist;
    areVariablesInitialized = true;
    notifyListeners();
  }
  void disposeVariables() {
    doesChatExistInFirestore = true;
    areVariablesInitialized = false;
    notifyListeners();
  }

  ///this function adds a new chat in Firestore
  Future<void> createNewChat({required String message, required ChatModel chatModel}) async {
    try {
      await _chatService.createNewChatInFirebaseFirestore(chatModel: chatModel);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function sends a new message to chat
  Future<void> sendMessageToChat(
      {required String message, required ChatModel chatModel, required String tokenId}) async {
    try {
      // first checking if the chat exists.
      // If it doesn't, then we create it first and then send the message
      if (!doesChatExistInFirestore) {
        print("creaing a new chat");
        await createNewChat(message: message, chatModel: chatModel);
        doesChatExistInFirestore = true;
        notifyListeners();
      }
      MessageModel messageModel = MessageModel(
          message: message,
          dateSent: dateTimeToEST(DateTime.now()),
          messageId: dateTimeToEST(DateTime.now()).toString(),
          isRead: false,
          fromUserId: authProvider.currentUserModel!.uid);
      _chatService.sendMessageToChat(
          messageModel: messageModel, chatId: chatModel.chatId, tokenId: tokenId);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function checks if the chat exists between two specified users and returns a boolean value
  Future<dynamic> doesChatExist({required String uid1, required String uid2}) async {
    try {
      bool doesExist = await _chatService.doesChatExistInFirestore(uid1: uid1, uid2: uid2);
      doesChatExistInFirestore = doesExist;
      notifyListeners();
      return doesExist;
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      return false;
    }
  }

  ///this function checks if the chat exists between two specified users and returns a boolean value
  void openChatScreenFromFriendListWidget({required String uid1, required String uid2}) async {
    try {
      bool doesChatExist = await _chatService.doesChatExistInFirestore(uid1: uid1, uid2: uid2);
      ChatModel chatModel;
      if (doesChatExist) {
        var chatDoc = await _chatService.fetchChatFromFirestore(uid1: uid1, uid2: uid2);
        chatModel = ChatModel.fromJson(chatDoc);
      } else {
        chatModel = ChatModel(uid1: uid1, uid2: uid2, chatId: "${dateTimeToEST(DateTime.now()).microsecondsSinceEpoch}", lastMessage: "", lastEdited: dateTimeToEST(DateTime.now()), lastMessageSentFromUID: "");
      }
      var partnerUserModelDoc = await _firestoreService.retrieveUserFromFirestore(uid: (authProvider.currentUserModel!.uid == uid1) ? uid2 : uid1);
      UserModel partnerUserModel = UserModel.fromJson(partnerUserModelDoc);
      Get.to(() => ChatScreen(doesChatExistInFirestore: doesChatExist, chatModel: chatModel, partnerUserModel: partnerUserModel, myUserModel: authProvider.currentUserModel!));
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function retrieves a partnerUserModel for a chat from Firestore
  Future<dynamic> getPartnerUserModelFromFirestore(
      {required String uid}) async {
    try {
      var userDoc = await _firestoreService.retrieveUserFromFirestore(uid: uid);
      UserModel userModel = UserModel.fromJson(userDoc);
      return userModel;
    } on FirestoreException catch (e) {
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
