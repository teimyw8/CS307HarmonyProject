import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';

class ChatService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ///this function creates a new chat in Firebase Firestore
  Future<void> createNewChatInFirebaseFirestore({required String partnerId}) async {
    try {
      ChatModel chatModel = ChatModel(messages: [], partnerUserId: partnerId, chatId: "${DateTime.now().microsecondsSinceEpoch}");
      var chatsCollectionReference = firebaseFirestore
          .collection('chats');
      await chatsCollectionReference.add(chatModel.toJson());
    } catch (e) {
      throw FirestoreException("Could not create a chat!");
    }
  }


  ///this function receives chat updates from Firebase Firestore
  Future<dynamic> fetchUpdatesFromChat({required String chatId}) async {
    try {
      var chatDoc = await firebaseFirestore
          .collection('chats')
          .doc(chatId)
          .get();
      var chatDocData = chatDoc.data();
      List<dynamic> messages =
      chatDocData!.containsKey('messages')
          ? chatDocData['messages']
          : [];
      return messages;
    } catch (e) {
      throw FirestoreException("Could not get messages!");
    }
  }


  ///this function sends a chat message to Firebase Firestore chat
  Future<void> sendMessageToChat({required String chatId, required MessageModel messageModel}) async {
    try {
      var chatDoc = await firebaseFirestore
          .collection('chats')
          .doc(chatId)
          .get();
      var chatDocData = chatDoc.data();
      List<dynamic> messages =
      chatDocData!.containsKey('messages')
          ? chatDocData['messages']
          : [];
      messages.add(messageModel.toJson());
      var chatDocRef = firebaseFirestore.collection('chats').doc(chatId);
      await chatDocRef.set({
        "messages": messages,
      });
    } catch (e) {
      throw FirestoreException("Could not send a message!");
    }
  }

}