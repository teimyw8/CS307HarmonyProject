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
        "userName": userName,
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
    try {
      var usersDocRef = await firebaseFirestore.collection('users').where('username', isEqualTo: username).limit(1).get();
      final QuerySnapshot result = await firebaseFirestore
          .collection('company')
          .where('username', isEqualTo: username)
          .limit(1).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length > 0) {
        throw FirestoreException(ServiceConstants.USERNAMEALREADYTAKEN);
      }
    } catch (e) {
      print(e as FirestoreException);
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }
}
