import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';

class ChatService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ///this function creates a new chat in Firebase Firestore
  Future<void> createNewChatInFirebaseFirestore({required ChatModel chatModel}) async {
    try {
      var chatsCollectionReference = firebaseFirestore
          .collection('chats').doc(chatModel.chatId);
      await chatsCollectionReference.set(chatModel.toJson());
    } catch (e) {
      throw FirestoreException("Could not create a chat!");
    }
  }

  ///this function checks if the chat exists between two specified users and returns a boolean value
  Future<bool> doesChatExistInFirestore({required String uid1, required String uid2}) async {
    try {
      var chatReference1 = await firebaseFirestore.collection('chats').where('uid1', isEqualTo: uid1).where('uid2', isEqualTo: uid2).limit(1).get();
      var chatReference2 = await firebaseFirestore.collection('chats').where('uid2', isEqualTo: uid1).where('uid1', isEqualTo: uid2).limit(1).get();
      final List<DocumentSnapshot> chatDocuments1 = chatReference1.docs;
      final List<DocumentSnapshot> chatDocuments2 = chatReference2.docs;
      if (chatDocuments1.length == 1) {
        return true;
      }
      if (chatDocuments2.length == 1) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
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

  ///this function receives chat updates from Firebase Firestore
  Future<dynamic> fetchChatFromFirestore({required String uid1, required String uid2}) async {
    try {
      var chatReference1 = await firebaseFirestore.collection('chats').where('uid1', isEqualTo: uid1).where('uid2', isEqualTo: uid2).limit(1).get();
      var chatReference2 = await firebaseFirestore.collection('chats').where('uid2', isEqualTo: uid1).where('uid1', isEqualTo: uid2).limit(1).get();
      final List<DocumentSnapshot> chatDocuments1 = chatReference1.docs;
      final List<DocumentSnapshot> chatDocuments2 = chatReference2.docs;
      if (chatDocuments1.length == 1) {
        return chatDocuments1[0].data();
      }
      if (chatDocuments2.length == 1) {
        return chatDocuments2[0].data();
      }
    } catch (e) {
      throw FirestoreException("Could not get messages!");
    }
  }


  ///this function sends a chat message to Firebase Firestore chat
  Future<void> sendMessageToChat({required String chatId, required MessageModel messageModel}) async {
    try {
      var messagesReference = await firebaseFirestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');
      messagesReference.add(messageModel.toJson());
      var chatDocRef = firebaseFirestore.collection('chats').doc(chatId);
      await chatDocRef.update({
        'lastMessage': messageModel.message,
        'lastEdited': messageModel.dateSent
      });
    } catch (e) {
      //throw FirestoreException("Could not send a message!");
    }
  }

}