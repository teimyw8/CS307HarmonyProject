class TopArtistModel {
  String link;
  String firstName;
  String lastName;
  String uid;
  String username;
  String spotifyToken;
  List<dynamic> friends;
  List<dynamic> friendRequestsSent;
  List<dynamic> friendRequestsReceived;

  TopArtistModel(
      {required this.link,
        required this.firstName,
        required this.lastName,
        required this.uid,
        required this.username,
        required this.friends,
        required this.spotifyToken,
        required this.friendRequestsReceived,
        required this.friendRequestsSent}
      );

  factory TopArtistModel.fromJson(Map<String, dynamic> json) => TopArtistModel(
    link: json["href"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    friends: json["friends"] ?? [],
    uid: json["uid"],
    username: json["username"] ?? "",
    spotifyToken: json["spotifyToken"] ?? "",
    friendRequestsReceived: json["friendRequestsReceived"] ?? [],
    friendRequestsSent: json["friendRequestsSent"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "email": link,
    "firstName": firstName,
    "lastName": lastName,
    "friends": friends,
    "uid": uid,
    "username": username,
    "spotifyToken": spotifyToken,
    "friendRequestsReceived": friendRequestsReceived,
    "friendRequestsSent": friendRequestsSent,
  };

  @override
  String toString() {
    return 'UserModel{email: $link, firstName: $firstName, lastName: $lastName, friends: $friends, uid: $uid, username: $username, spotifyToken: $spotifyToken, friends: $friends, friendRequestsSent: $friendRequestsSent, friendRequestsReceived: $friendRequestsReceived}';
  }
}
