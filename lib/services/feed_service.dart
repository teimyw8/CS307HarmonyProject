import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/custom_exceptions.dart';
import '../helpers/service_constants.dart';

class FeedService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addPostToFirestore(
      {required String text,
      required String username,
      required String uid,
      required Timestamp dateTime}) async {
    try {
      var postsDocRef = firebaseFirestore.collection('posts');
      await postsDocRef.add({
        "username": username,
        "text": text,
        "uid": uid,
        "dateTime": dateTime,
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }
}
