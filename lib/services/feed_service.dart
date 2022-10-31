import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/custom_exceptions.dart';
import '../helpers/service_constants.dart';

class FeedService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addPostToFirestore(
      {required String text,
      required String username,
      required String uid}) async {
    try {
      var postsDocRef = firebaseFirestore.collection('posts').doc(uid);
      await postsDocRef.set({
        "username": username,
        "text": text,
        "friends": [],
        "uid": uid,
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }
}
