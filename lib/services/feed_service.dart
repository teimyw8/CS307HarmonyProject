import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/custom_exceptions.dart';
import '../helpers/service_constants.dart';

class FeedService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  DateTime k = DateTime(9999);



  Future<void> addPostToFirestore(
      {required String text,
      required String username,
      required String uid,
      required Timestamp dateTime,
      required String song,
      required String artist,
      required String isPost,
        required List likes,
      required String isPost,
      required String album,
      required String playlist,
      required String image,
      }) async {
    try {
      var postsDocRef = firebaseFirestore.collection('posts');
      await postsDocRef.add({
        "username": username,
        "text": text,
        "uid": uid,
        "dateTime": dateTime,
        "song": song,
        "artist": artist,
        "isPost": isPost,
        "likes": likes
        "isPost": isPost,
        "album": album,
        "playlist": playlist,
        "image": image
      });
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

   Future<String> countLikes(uid, dateTime) async {
    try {
      var userDoc = await firebaseFirestore.collection('posts').where('uid', isEqualTo: uid).where("dateTime", isEqualTo: dateTime).get();
      var len =  userDoc.docs[0].get('likes').length;
      return len.toString();
    }
    catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  Future<DateTime> getDailyActivityTime() async {
    try {
      var userDoc = await firebaseFirestore.collection('activity_times').doc(
          'Daily_Activity_Times').get();
      var userDocData = userDoc.data()!;
      if (!userDoc.exists) {
        throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
      }
      int p = 0;
      for (int i = 0; i < userDocData.length; i++) {
        p = i + 1;
        k = userDocData[p.toString()][0].toDate();
        // print(k);
        // if (k.month == DateTime.now().toUtc().month && k.day == DateTime.now().toUtc().day) {
        //   break;
        // }
        if (k.month == DateTime
            .now()
            .month && k.day == DateTime
            .now()
            .day) {
          break;
        }
      }
      return k;
    }
    catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  Future<bool> checkTime() async {
    // return true;
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
        // if (k.month == DateTime.now().toUtc().month && k.day == DateTime.now().toUtc().day) {
        //   break;
        // }
        if (k.month == DateTime.now().month && k.day == DateTime.now().day) {
          break;
        }
      }
      // if (DateTime.now().toUtc().compareTo(userDocData[p.toString()][1].toDate()) <= 0 &&
      //     DateTime.now().toUtc().compareTo(userDocData[p.toString()][0].toDate()) >= 0) {
      //   return true;
      // }
      if (DateTime.now().compareTo(userDocData[p.toString()][1].toDate()) <= 0 &&
          DateTime.now().compareTo(userDocData[p.toString()][0].toDate()) >= 0) {
        return true;
      }
      return false;
    } catch (e) {
      throw FirestoreException(ServiceConstants.SOMETHINGWENTWRONG);
    }
  }

  Future<bool> isLiked(uid, dateTime, curUserUid) async {
    var userDoc = await firebaseFirestore.collection('posts').where('uid', isEqualTo: uid).where("dateTime", isEqualTo: dateTime).get();
    var allLikes = userDoc.docs[0].get('likes');
    if (allLikes.contains(curUserUid)) {
      return true;
    }
    return false;
  }

  handleLiked(uid, dateTime, curUserUid) async {
    var userDoc = await firebaseFirestore.collection('posts').where('uid', isEqualTo: uid).where("dateTime", isEqualTo: dateTime).get();
    var l = userDoc.docs[0];
    var e = await firebaseFirestore.collection("posts").doc(l.id);
    if (await isLiked(uid, dateTime, curUserUid) == false) {
        e.update({"likes": FieldValue.arrayUnion([curUserUid]),
        });
    }
    else {
      e.update({"likes": FieldValue.arrayRemove([curUserUid]),
      });
    }
  }

}
