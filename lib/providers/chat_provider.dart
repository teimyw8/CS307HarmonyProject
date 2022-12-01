import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/helper_functions.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/screens/chat_screen.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/common_widgets/loading_dialog_widget.dart';
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
  Future<void> createNewChat(
      {required String message, required ChatModel chatModel}) async {
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
      {required String message,
      required ChatModel chatModel,
      required String tokenId}) async {
    try {
      // first checking if the chat exists.
      // If it doesn't, then we create it first and then send the message
      if (!doesChatExistInFirestore) {
        await createNewChat(message: message, chatModel: chatModel);
        doesChatExistInFirestore = true;
        notifyListeners();
      }
      MessageModel messageModel = MessageModel(
          message: message,
          dateSent: dateTimeToEST(DateTime.now()),
          messageId: dateTimeToEST(DateTime.now()).toString(),
          isRead: false,
          fromUserId: authProvider.currentUserModel!.uid,
          messageType: 'message', postModel: null);
      _chatService.sendMessageToChat(
          messageModel: messageModel,
          chatId: chatModel.chatId,
          tokenId: tokenId);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function shows a send post response dialog that user fills out to send his/her response
  void showPostResponseDialog({required PostModel postModel}) {
    PopUpDialog.showTextFieldPopUpDialog(title: 'Respond!', message: 'Send a message to your friend', onSendClick: (value) async {
      final GlobalKey _LoaderDialog = new GlobalKey();

      LoaderDialog.showLoadingDialog(Get.context!, _LoaderDialog);
      try {
        //first retrieving a ChatModel from Firestore if one exists
        //else creating a new ChatModel
        late ChatModel chatModel;
        bool doesChatExist =
        await _chatService.doesChatExistInFirestore(uid1: authProvider.currentUserModel!.uid, uid2: postModel.uid);
        if (doesChatExist) {
          //retrieving ChatModel from Firestore
          var chatDoc =
          await _chatService.fetchChatFromFirestore(uid1: authProvider.currentUserModel!.uid, uid2: postModel.uid);
          chatModel = ChatModel.fromJson(chatDoc);
        } else {
          //creating a new ChatModel
          chatModel = ChatModel(
            uid1: authProvider.currentUserModel!.uid,
            uid2: postModel.uid,
            chatId: "${dateTimeToEST(DateTime.now()).microsecondsSinceEpoch}",
            lastMessage: "",
            lastEdited: dateTimeToEST(DateTime.now()),
            lastMessageSentFromUID: "",
          );
        }
        //retrieving tokenId
        var partnerUserModelDoc = await _firestoreService.retrieveUserFromFirestore(uid: postModel.uid);
        UserModel partnerUserModel = UserModel.fromJson(partnerUserModelDoc);
        String tokenId = partnerUserModel.tokenId;
        await _sendPostResponseToChat(message: value, chatModel: chatModel, tokenId: tokenId, postModel: postModel, doesChatExist: doesChatExist);
      } catch (e) {
        _showErrorDialog("Could not send message. Please try again.");
      }
      //popping loading dialog
      Navigator.of(_LoaderDialog.currentContext!,rootNavigator: true).pop();
      //popping message widget
      Navigator.pop(Get.context!);
    });
  }

  ///this function sends a new message to chat
  Future<void> _sendPostResponseToChat(
      {required String message,
        required ChatModel chatModel,
        required String tokenId,
        required PostModel postModel,
        required bool doesChatExist
      }) async {
    try {
      // first checking if the chat exists.
      // If it doesn't, then we create it first and then send the message
      if (!doesChatExist) {
        await createNewChat(message: message, chatModel: chatModel);
        doesChatExistInFirestore = true;
        notifyListeners();
      }
      MessageModel messageModel = MessageModel(
          message: message,
          dateSent: dateTimeToEST(DateTime.now()),
          messageId: dateTimeToEST(DateTime.now()).toString(),
          isRead: false,
          fromUserId: authProvider.currentUserModel!.uid,
          messageType: 'postResponse', postModel: postModel);
      _chatService.sendPostResponseToChat(
          messageModel: messageModel,
          chatId: chatModel.chatId,
          tokenId: tokenId);
    } on FirestoreException catch (e) {
      _showErrorDialog(e.cause);
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function checks if the chat exists between two specified users and returns a boolean value
  Future<dynamic> doesChatExist(
      {required String uid1, required String uid2}) async {
    try {
      bool doesExist =
          await _chatService.doesChatExistInFirestore(uid1: uid1, uid2: uid2);
      doesChatExistInFirestore = doesExist;
      notifyListeners();
      return doesExist;
    } catch (e) {
      _showErrorDialog(ServiceConstants.SOMETHINGWENTWRONG);
      return false;
    }
  }

  ///this function checks if the chat exists between two specified users and returns a boolean value
  void openChatScreenFromFriendListWidget(
      {required String uid1, required String uid2}) async {
    try {
      bool doesChatExist =
          await _chatService.doesChatExistInFirestore(uid1: uid1, uid2: uid2);
      ChatModel chatModel;
      if (doesChatExist) {
        var chatDoc =
            await _chatService.fetchChatFromFirestore(uid1: uid1, uid2: uid2);
        var chatId =
            await _chatService.fetchChatIdFromFirestore(uid1: uid1, uid2: uid2);
        chatModel = ChatModel.fromJson(chatDoc);
        var partnerUserModelDoc =
            await _firestoreService.retrieveUserFromFirestore(
                uid:
                    (authProvider.currentUserModel!.uid == uid1) ? uid2 : uid1);
        UserModel partnerUserModel = UserModel.fromJson(partnerUserModelDoc);
        Get.to(() => ChatScreen(
              doesChatExistInFirestore: doesChatExist,
              chatModel: chatModel,
              partnerUserModel: partnerUserModel,
              myUserModel: authProvider.currentUserModel!,
              chatId: chatId,
            ));
      } else {
        chatModel = ChatModel(
          uid1: uid1,
          uid2: uid2,
          chatId: "${dateTimeToEST(DateTime.now()).microsecondsSinceEpoch}",
          lastMessage: "",
          lastEdited: dateTimeToEST(DateTime.now()),
          lastMessageSentFromUID: "",
        );
        var partnerUserModelDoc =
            await _firestoreService.retrieveUserFromFirestore(
                uid:
                    (authProvider.currentUserModel!.uid == uid1) ? uid2 : uid1);
        UserModel partnerUserModel = UserModel.fromJson(partnerUserModelDoc);
        Get.to(() => ChatScreen(
              doesChatExistInFirestore: doesChatExist,
              chatModel: chatModel,
              partnerUserModel: partnerUserModel,
              myUserModel: authProvider.currentUserModel!,
              chatId: '',
            ));
      }
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

  ///this function checks if the user's last message is read
  Future<bool> isLastMessageRead({required String chatId}) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('chats')
          .doc("${chatId}")
          .collection('messages')
          .orderBy('dateSent')
          .get();
      List<MessageModel> messages = [];
      for (dynamic doc in data.docs) {
        messages.add(MessageModel.fromJson(doc.data()));
      }
      MessageModel lastMessage =
          MessageModel.fromJson(data.docs[data.docs.length - 1].data());
      if (lastMessage.fromUserId == authProvider.currentUserModel!.uid) {
        return true;
      }
      return lastMessage.isRead;
    } catch (e) {
      return false;
    }
  }
}
