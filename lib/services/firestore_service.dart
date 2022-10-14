import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/helpers/service_constants.dart';

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
      required String password}) async {
    try {
      var usersDocRef =  firebaseFirestore.collection('users').doc(uid);
      await usersDocRef.set({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "username": userName,
        "uid": uid,
        "password": password,
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  ///this function checks if a user with this username already exists
  Future<void> doesUsernameAlreadyExist(
      {required String username,}) async {
    //try {
      print("username: $username");
      final QuerySnapshot result = await firebaseFirestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1).get();
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


  ///this function updates the friendRequestsReceived for the user to whom the current user just sent the request
  Future<dynamic> sendFriendRequestToUser({required String sendToUID, required String sendFromUID}) async {
    try {
      var userDoc = await firebaseFirestore.collection('users').doc(sendToUID).get();
      var userDocData = userDoc.data();
      List<dynamic> friendRequestsReceived = userDocData!.containsKey('friendRequestsReceived') ? userDocData['friendRequestsReceived'] : [];
      if (!friendRequestsReceived.contains(sendFromUID)) {
        friendRequestsReceived.add(sendFromUID);
        print("friendRequestsReceived: ${friendRequestsReceived}");
        await firebaseFirestore.collection("users").doc(sendToUID).update({
          'friendRequestsReceived': friendRequestsReceived
        });
      }
    } catch (e) {
      print(e);
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

}
