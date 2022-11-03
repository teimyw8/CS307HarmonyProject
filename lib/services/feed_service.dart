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
      required Timestamp dateTime,
      required String song,
      required String artist,
      required String isPost}) async {
    try {
      var postsDocRef = firebaseFirestore.collection('posts');
      await postsDocRef.add({
        "username": username,
        "text": text,
        "uid": uid,
        "dateTime": dateTime,
        "song": song,
        "artist": artist,
        "isPost": isPost
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  Future<bool> checkTime() async {
    try {
      var userDoc = await firebaseFirestore.collection('activity_times').doc('Daily_Activity_Times').get();
      var userDocData = userDoc.data()!;
      if (!userDoc.exists) {
        throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
      }
      DateTime k = DateTime(9999);
      int p = 0;
      for(int i = 0; i < userDocData.length; i++) {
        p = i + 1;
        k = userDocData[p.toString()][0].toDate();
        if (k.month == DateTime.now().month && k.day == DateTime.now().day) {
          break;
        }
      }
      print(k);
      print(p);
      if (DateTime.now().compareTo(userDocData[p.toString()][1].toDate()) <= 0 &&
          DateTime.now().compareTo(userDocData[p.toString()][0].toDate()) >= 0) {
        return true;
      }
      return false;
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  
}
