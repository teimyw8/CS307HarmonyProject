import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;   //user ID that created the post
  String username;
  String text;
  Timestamp dateTime;    //date of creation post
  String artist;
  String song;
  String isPost;
  String album;
  String playlist;
  String image;

  PostModel(
      {
        required this.uid,
        required this.username,
        required this.text,
        required this.dateTime,
        required this.artist,
        required this.song,
        required this.isPost,
        required this.album,
        required this.playlist,
        required this.image,
      });


  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uid: json["uid"],
    username: json["username"] ?? "",
    text: json["text"],
    dateTime: json["dateTime"],
    song: json["song"] ?? "",
    artist: json["artist"] ?? "",
    isPost: json["isPost"] ?? "",
    album: json["album"] ?? "",
    playlist: json["playlist"] ?? "",
    image: json ["image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "text": text,
    "dateTime": dateTime,
    "song": song,
    "artist": artist,
    "isPost": isPost,
    "album": album,
    "playlist": playlist,
    "image": image,
  };
}