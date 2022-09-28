import 'package:cloud_firestore/cloud_firestore.dart';
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
        return null;
      }
      return userDocData;
    } catch (e) {
      return null;
    }
  }

  ///this function makes a Logout request to FirebaseAuth.
  ///RETURN VALUES:
  /// SUCCESS
  /// SOMETHINGWENTWRONG
  Future<dynamic> addUserToFirestore(
      {required String email,
      required String firstName,
      required String lastName,
      required String userName}) async {
    try {
      var usersCollection =  firebaseFirestore.collection('users');
      usersCollection.add({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName
      });
      return ServiceConstants.SUCCESS;
    } catch (e) {
      return ServiceConstants.SOMETHINGWENTWRONG;
    }
  }
}
