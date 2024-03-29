import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/service_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';

import '../providers/auth_provider.dart';

class FirestoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ///this function makes a Logout request to FirebaseAuth.
  ///RETURN VALUES:
  /// userDocData: if SUCCESSFUL
  /// null: if unsuccessful
  Future<dynamic> retrieveUserFromFirestore({required String uid}) async {
    try {
      var userDoc = await firebaseFirestore.collection('users').doc(uid).get();
      var userDocData = userDoc.data();
      if (!userDoc.exists) {
        throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
      }
      return userDocData;
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function makes a Logout request to FirebaseAuth.
  ///THROWS AuthException IF FAILS
  Future<void> addUserToFirestore(
      {required String uid,
      required String email,
      required String firstName,
      required String lastName,
      required String userName,
      required String bio,
      required int displayProfileTo,
      required bool displayName,
      required List<String> friends,
      required String password,
      required bool dailyNotifStatus,
      required String profilepic,
      required String tokenId,
        required bool chatNotifStatus, required bool FRNotifStatus}) async {
    try {
      var usersDocRef = firebaseFirestore.collection('users').doc(uid);
      await usersDocRef.set({
        "email": email,
        "FRNotifStatus": FRNotifStatus,
        "firstName": firstName,
        "lastName": lastName,
        "username": userName,
        "bio": bio,
        "dailyNotifStatus": dailyNotifStatus,
        "displayProfileTo": displayProfileTo,
        "displayName": displayName,
        "friends": [],
        "chatNotifStatus": chatNotifStatus,
        "uid": uid,
        "password": password,
        "profilepic":
            "https://firebasestorage.googleapis.com/v0/b/harmony-5a238.appspot.com/o/image_picker5045730262574777780.jpg?alt=media&token=86fc8768-63f9-4fb8-b98c-055e08fe5fd7",
        "tokenId": tokenId
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function updates tokenId in Firestore
  ///THROWS AuthException IF FAILS
  Future<void> updateTokenIdInFirestore(
      {required String uid,
        required String tokenId}) async {
    try {
      var usersDocRef = firebaseFirestore.collection('users').doc(uid);
      await usersDocRef.update({
        "uid": uid,
        "tokenId": tokenId,
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }


  ///this function checks if a user with this username already exists
  Future<void> doesUsernameAlreadyExist({
    required String username,
  }) async {
    //try {
    print("username: $username");
    final QuerySnapshot result = await firebaseFirestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    print("documents: $documents");
    if (documents.isNotEmpty) {
      print("THROWING USERNAMEALREADYTAKEN");
      throw FirestoreException(ServiceConstants.USERNAMEALREADYTAKEN);
    }
    // } catch (e) {
    //   throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    // }
  }

  Future<void> sendNotificationToOtherUser(
      {required String body,
        required String title,
        required DateTime dateTime,
        required String tokenId}) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendFriendRequestNotification');
      final response = await callable.call({
        'body': body,
        'token': tokenId,
        'title': title,
        'timestamp': DateFormat('MM ddd – kk:mm').format(dateTime)
      });
      print(response.data);
    } catch (e) {}
  }

  ///this function updates the friendRequestsReceived for the user to whom the current user just sent the request
  Future<dynamic> sendFriendRequestToUser(
      {required String sendToUID, required String sendFromUID, required UserModel myUserModel, required UserModel userModelToRequest}) async {
    try {
      var sendToUserDoc =
          await firebaseFirestore.collection('users').doc(sendToUID).get();
      var sendFromUserDoc =
          await firebaseFirestore.collection('users').doc(sendFromUID).get();

      var sendToUserDocData = sendToUserDoc.data();
      var sendFromUserDocData = sendFromUserDoc.data();
      List<dynamic> friendRequestsReceived =
          sendToUserDocData!.containsKey('friendRequestsReceived')
              ? sendToUserDocData['friendRequestsReceived']
              : [];
      if (!friendRequestsReceived.contains(sendFromUID)) {
        friendRequestsReceived.add(sendFromUID);
        await firebaseFirestore
            .collection("users")
            .doc(sendToUID)
            .update({'friendRequestsReceived': friendRequestsReceived});
      }
      List<dynamic> friendRequestsSent =
          sendFromUserDocData!.containsKey('friendRequestsSent')
              ? sendFromUserDocData['friendRequestsSent']
              : [];
      if (!friendRequestsSent.contains(sendToUID)) {
        friendRequestsSent.add(sendToUID);
        await firebaseFirestore
            .collection("users")
            .doc(sendFromUID)
            .update({'friendRequestsSent': friendRequestsSent});
      }
      AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
      if(userModelToRequest.FRNotifStatus) {
        sendNotificationToOtherUser(
            body: '${myUserModel.username} sent you a friend request',
            title: 'New Friend Request',
            dateTime: DateTime.now(),
            tokenId: userModelToRequest.tokenId);
      }
    } catch (e) {
      print(e);
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function retrieves FriendRequestsReceived for a user from Firestore
  Future<List<dynamic>> getFriendRequestsReceived(
      {required String currentUserModelUID}) async {
    try {
      var currentUserDoc = await firebaseFirestore
          .collection('users')
          .doc(currentUserModelUID)
          .get();
      var currentUserDocData = currentUserDoc.data();
      List<dynamic> friendRequestsReceived =
          currentUserDocData!.containsKey('friendRequestsReceived')
              ? currentUserDocData['friendRequestsReceived']
              : [];
      return friendRequestsReceived;
    } catch (e) {
      return [];
    }
  }

  ///this function accepts a user request in firebase
  Future<void> acceptFriendRequest(
      {required String currentUserUID, required String otherUserUID}) async {
    try {
      var currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUserUID).get();
      var otherUserDoc =
          await firebaseFirestore.collection('users').doc(otherUserUID).get();

      var currentUserDocData = currentUserDoc.data();
      var otherUserDocData = otherUserDoc.data();

      //updating requests sent and requests received for both users
      List<dynamic> currentUserFriendRequestsReceived =
          currentUserDocData!.containsKey('friendRequestsReceived')
              ? currentUserDocData['friendRequestsReceived']
              : [];
      List<dynamic> otherUserFriendRequestsSent =
          otherUserDocData!.containsKey('friendRequestsSent')
              ? otherUserDocData['friendRequestsSent']
              : [];

      currentUserFriendRequestsReceived.remove(otherUserUID);
      await firebaseFirestore.collection("users").doc(currentUserUID).update(
          {'friendRequestsReceived': currentUserFriendRequestsReceived});

      otherUserFriendRequestsSent.remove(currentUserUID);
      await firebaseFirestore
          .collection("users")
          .doc(otherUserUID)
          .update({'friendRequestsSent': otherUserFriendRequestsSent});

      //adding both users as each other's friends
      List<dynamic> currentUserFriends =
          currentUserDocData.containsKey('friends')
              ? currentUserDocData['friends']
              : [];
      List<dynamic> otherUserFriends = otherUserDocData.containsKey('friends')
          ? otherUserDocData['friends']
          : [];

      currentUserFriends.add(otherUserUID);
      otherUserFriends.add(currentUserUID);
      await firebaseFirestore
          .collection("users")
          .doc(currentUserUID)
          .update({'friends': currentUserFriends});
      await firebaseFirestore
          .collection("users")
          .doc(otherUserUID)
          .update({'friends': otherUserFriends});

      return;
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function denies user friend request
  Future<void> denyFriendRequest(
      {required String currentUserUID, required String otherUserUID}) async {
    try {
      var currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUserUID).get();
      var otherUserDoc =
          await firebaseFirestore.collection('users').doc(otherUserUID).get();

      var currentUserDocData = currentUserDoc.data();
      var otherUserDocData = otherUserDoc.data();

      //updating requests sent and requests received for both users
      List<dynamic> currentUserFriendRequestsReceived =
          currentUserDocData!.containsKey('friendRequestsReceived')
              ? currentUserDocData['friendRequestsReceived']
              : [];
      List<dynamic> otherUserFriendRequestsSent =
          otherUserDocData!.containsKey('friendRequestsSent')
              ? otherUserDocData['friendRequestsSent']
              : [];

      currentUserFriendRequestsReceived.remove(otherUserUID);
      await firebaseFirestore.collection("users").doc(currentUserUID).update(
          {'friendRequestsReceived': currentUserFriendRequestsReceived});

      otherUserFriendRequestsSent.remove(currentUserUID);
      await firebaseFirestore
          .collection("users")
          .doc(otherUserUID)
          .update({'friendRequestsSent': otherUserFriendRequestsSent});
      return;
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function blocks a specified user in Firestore
  Future<void> blockUser(
      {required String currentUserUID, required String blockUID}) async {
    try {
      var currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUserUID).get();
      List<dynamic> blockedUsers =
          currentUserDoc.data()!.containsKey('blockedUsers')
              ? currentUserDoc.data()!['blockedUsers']
              : [];
      blockedUsers.add(blockUID);
      await firebaseFirestore
          .collection("users")
          .doc(currentUserUID)
          .update({'blockedUsers': blockedUsers});
    } catch (e) {
      print(e);
    }
  }

  ///this function blocks a specified user in Firestore
  Future<void> unblockUser(
      {required String currentUserUID, required String blockUID}) async {
    try {
      var currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUserUID).get();
      List<dynamic> blockedUsers =
          currentUserDoc.data()!.containsKey('blockedUsers')
              ? currentUserDoc.data()!['blockedUsers']
              : [];
      if (blockedUsers.contains(blockUID)) {
        blockedUsers.remove(blockUID);
      }
      await firebaseFirestore
          .collection("users")
          .doc(currentUserUID)
          .update({'blockedUsers': blockedUsers});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getDailyNotifStatus(String uid) async {
    var userDoc = await firebaseFirestore
        .collection("users")
        .doc(uid).get();
    var userDocData = userDoc.data()!;
    if (!userDoc.exists) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
    print(userDocData["dailyNotifStatus"]);
    print("^");
    return userDocData["dailyNotifStatus"];

  }

  Future<bool> getChatNotifStatus(String uid) async {
    var userDoc = await firebaseFirestore
        .collection("users")
        .doc(uid).get();
    var userDocData = userDoc.data()!;
    if (!userDoc.exists) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
    print(userDocData["chatNotifStatus"]);
    print("^");
    return userDocData["chatNotifStatus"];

  }

  Future<void> swapDailyNotification(String uid, bool b) async {
    print(uid);
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({'dailyNotifStatus': !b});
  }

  void swapChatNotification(String uid, bool b) async{
    print(uid);
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({'chatNotifStatus': !b});
  }

  void swapFRNotification(String uid, bool b) async{
    print(uid);
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .update({'FRNotifStatus': !b});
  }

  Future<bool> getFRNotifStatus(String uid) async {
    var userDoc = await firebaseFirestore
        .collection("users")
        .doc(uid).get();
    var userDocData = userDoc.data()!;
    if (!userDoc.exists) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
    print(userDocData["FRNotifStatus"]);
    print("^");
    return userDocData["FRNotifStatus"];

  }

}
