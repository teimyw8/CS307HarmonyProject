import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String username;
  String text;
  Timestamp dateTime;


  PostModel(
      {
        required this.uid,
        required this.username,
        required this.text,
        required this.dateTime
      });


  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uid: json["uid"],
    username: json["username"] ?? "",
    text: json["text"],
    dateTime: json["dateTime"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "text": text,
    "dateTime": dateTime
  };
}