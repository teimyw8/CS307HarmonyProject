import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/custom_exceptions.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/feed_service.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/services/shared_preferences_service.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screens/share_daily_activity_screen.dart';

class FeedProvider with ChangeNotifier {
  AuthProvider _authProvider =
  Provider.of<AuthProvider>(Get.context!, listen: false);

  Stream<QuerySnapshot<Object?>>? currentSnapshot;
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  SharedPreferencesService get _sharedPreferencesService => GetIt.instance<SharedPreferencesService>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FeedService get _feedService => GetIt.instance<FeedService>();

  bool isLoading = false;
  bool isLoadingFeed = false;

  bool areVariablesInitialized = false;
  final formKeyPosts = GlobalKey<FormState>();
  final formKeyDaily = GlobalKey<FormState>();

  ///this are for the regular posts
  TextEditingController? textEditingController = TextEditingController();
  TextEditingController spotifyTextEditingController = TextEditingController();

  ///this are for the daily activity
  TextEditingController? songTextEditingController = TextEditingController();
  TextEditingController? artistTextEditingController = TextEditingController();

  void initializeVariables() async {
    areVariablesInitialized = false;
    isLoading = true;
    notifyListeners();
    if (_authProvider.currentUserModel == null) {
      String uid = await _sharedPreferencesService.getUserUid();
      var userDoc = await _firestoreService.retrieveUserFromFirestore(uid: uid);
      UserModel tempUserModel = UserModel.fromJson(userDoc);
      _authProvider.setCurrentUserModel(tempUserModel);
    }
    if (_authProvider.currentUserModel!.dailyNotifStatus) {
      scheduleNotification();
    }
    isLoading = false;
    isLoadingFeed = false;

    areVariablesInitialized = true;
    notifyListeners();
  }

  Future<void> createPost(String option, String image, String album, String artist) async {
    formKeyPosts.currentState!.save();
    if (option == "Artist") {
      try {
        debugPrint(textEditingController!.text);
        if (formKeyPosts.currentState!.validate()) {
          await _feedService.addPostToFirestore(
              image: image,
              song: "",
              artist: spotifyTextEditingController.text,
              album: "",
              playlist: "",
              text: textEditingController!.text,
              username: _authProvider.currentUserModel!.username,
              uid: _authProvider.currentUserModel!.uid,
              dateTime: Timestamp.now(),
              isPost: "true",
              likes: []);
        }
      } on FirestoreException catch (e) {
        debugPrint('failed addPostoFirestore');
        showErrorDialog(e.cause);
      }
    } else if (option == "Song") {
      try {
        debugPrint(textEditingController!.text);
        if (formKeyPosts.currentState!.validate()) {
          await _feedService.addPostToFirestore(
              image: image,
              song: spotifyTextEditingController.text,
              artist: artist,
              album: album,
              playlist: "",
              text: textEditingController!.text,
              username: _authProvider.currentUserModel!.username,
              uid: _authProvider.currentUserModel!.uid,
              dateTime: Timestamp.now(),
              isPost: "true", likes: []);
        }
      } on FirestoreException catch (e) {
        debugPrint('failed addPostoFirestore');
        showErrorDialog(e.cause);
      }
    } else if (option == "Album") {
      try {
        debugPrint(textEditingController!.text);
        if (formKeyPosts.currentState!.validate()) {
          await _feedService.addPostToFirestore(
              image: image,
              song: "",
              artist: artist,
              album: spotifyTextEditingController.text,
              playlist: "",
              text: textEditingController!.text,
              username: _authProvider.currentUserModel!.username,
              uid: _authProvider.currentUserModel!.uid,
              dateTime: Timestamp.now(),
              isPost: "true", likes: [],);
        }
      } on FirestoreException catch (e) {
        debugPrint('failed addPostoFirestore');
        showErrorDialog(e.cause);
      }
    } else if (option == "Playlist") {
      try {
        debugPrint(textEditingController!.text);
        if (formKeyPosts.currentState!.validate()) {
          await _feedService.addPostToFirestore(
              image: image,
              song: "",
              artist: "",
              album: "",
              playlist: spotifyTextEditingController.text,
              text: textEditingController!.text,
              username: _authProvider.currentUserModel!.username,
              uid: _authProvider.currentUserModel!.uid,
              dateTime: Timestamp.now(),
              isPost: "true", likes: []);
        }
      } on FirestoreException catch (e) {
        debugPrint('failed addPostoFirestore');
        showErrorDialog(e.cause);
      }
    }
  }

  Future<void> createDailyPost() async {
    formKeyDaily.currentState!.save();

    try {
      print(textEditingController!.text);
      if (formKeyDaily.currentState!.validate()) {
        await _feedService.addPostToFirestore(
            song: songTextEditingController!.text,
            artist: artistTextEditingController!.text,
            text: "Here is my song of the day!",
            username: _authProvider.currentUserModel!.username,
            uid: _authProvider.currentUserModel!.uid,
            dateTime: Timestamp.now(),
            isPost: "false",
            likes: [],
            album: "",
            playlist: "",
            image: "",
        );
      }
    } on FirestoreException catch (e) {
      showErrorDialog(e.cause);
    }
  }

  handleLikes(uid, dateTime) {
    return _feedService.handleLiked(uid, dateTime, _authProvider.currentUserModel!.uid);
  }

  Future<bool> isLiked(uid, dateTime) async {
    // print(_feedService.checkLiked(uid,dateTime, _authProvider.currentUserModel!.uid));
    if (await _feedService.isLiked(uid,dateTime, _authProvider.currentUserModel!.uid) == true) {
      return true;
    }

    return false;
  }

  List listOfUsers() {
    List uidList = (_authProvider.currentUserModel?.friends)!;
    if (!uidList.contains(_authProvider.currentUserModel!.uid)) {
      uidList.add(_authProvider.currentUserModel!.uid);
    }
    return uidList;
  }

  List<PostModel> lastDayOnly(List<PostModel> posts) {
    //filter chronologically from newest to oldest
    posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    //remove all the old ones.
    var it = posts.iterator;
    var toRemove = [];

    //you can't remove items directy when using an iterator
    while (it.moveNext()) {
      Duration difference =
          DateTime.now().difference(it.current.dateTime.toDate());
      if (difference.inHours > 24) {
        //add this elements for removal after this while.
        toRemove.add(it.current);
      }
    }

    //remove the elements marked
    posts.removeWhere((e) => toRemove.contains(e));

    return posts;
  }

  Future<void> scheduleNotification() async {
    final StreamController<String?> selectNotificationStream =
        StreamController<String?>.broadcast();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == 'id_3') {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
    );
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    Future<DateTime> notif = _feedService.getDailyActivityTime();
    DateTime a = await notif;
    if (DateTime.now().compareTo(a) > 0) {
      return;
    }
    var scheduledDate = tz.TZDateTime.from(a, tz.getLocation(timeZoneName));
    print(notif.toString() + 'notiftime');

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to share your daily song, head to the homepage!',
        'Remember: You only have 5 minutes!',
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'full screen channel id', 'full screen channel name',
                channelDescription: 'full screen channel description',
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  activityTimeCheck(BuildContext context) async {
    if (await _feedService.checkTime()) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => DailyActivity()));
    } else {
      showErrorDialog(
          "It is not time for the daily activity yet! Check back again soon!");
    }
  }

  Future<String> getLikes(uid, dateTime) {
    return _feedService.countLikes(uid,dateTime);
  }




}

///this function shows an error dialog
void showErrorDialog(String message) {
  PopUpDialog.showAcknowledgePopUpDialog(
      title: "Error!",
      message: message,
      onOkClick: () {
        Get.close(1);
      });
}
