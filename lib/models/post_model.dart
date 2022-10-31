class PostModel {
  String uid;
  String username;
  String text;


  PostModel(
      {
        required this.uid,
        required this.username,
        required this.text
      });


  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    uid: json["uid"],
    username: json["username"] ?? "",
    text: json["text"]
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "text": text
  };
}