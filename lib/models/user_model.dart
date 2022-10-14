class UserModel {
  String email;
  String firstName;
  String lastName;
  String uid;
  String username;
  String spotifyToken;
  var friends;
  List<dynamic> friendRequestsSent;
  List<dynamic> friendRequestsReceived;

  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.uid,
      required this.username,
      required this.friends,
      required this.spotifyToken,
      required this.friendRequestsReceived,
      required this.friendRequestsSent}
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    friends: json["friends"],
    uid: json["uid"],
    username: json["username"] ?? "",
    spotifyToken: json["spotifyToken"] ?? "",
    friendRequestsReceived: json["friendRequestsReceived"] ?? [],
    friendRequestsSent: json["friendRequestsSent"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
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
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, uid: $uid, username: $username, spotifyToken: $spotifyToken, friends: $friends, friendRequestsSent: $friendRequestsSent, friendRequestsReceived: $friendRequestsReceived}';
  }
}
