import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String username;
  String text;
  Timestamp dateTime;
  String artist;
  String song;
  String isPost;


  PostModel(
      {
        required this.uid,
        required this.username,
        required this.text,
        required this.dateTime,
        required this.artist,
        required this.song,
        required this.isPost
      });


  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uid: json["uid"],
    username: json["username"] ?? "",
    text: json["text"],
    dateTime: json["dateTime"],
    song: json["song"] ?? "",
    artist: json["artist"] ?? "",
    isPost: json["isPost"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "text": text,
    "dateTime": dateTime,
    "song": song,
    "artist": artist,
    "isPost": isPost
  };
}