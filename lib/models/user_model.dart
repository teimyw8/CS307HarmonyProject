class UserModel {
  String email;
  String firstName;
  String lastName;
  String uid;
  String username;
  String spotifyToken;
  var friends;

  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.uid,
      required this.username,
      required this.friends,
      required this.spotifyToken});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        friends: json["friends"],
        //friendRequests: json["friendRequests"],
        uid: json["uid"],
        username: json["username"],
        spotifyToken: json["spotifyToken"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "friends": friends,
        //"friendRequests": friendRequests,
        "uid": uid,
        "username": username,
        "spotifyToken": spotifyToken,
      };

  @override
  String toString() {
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, friends: $friends, uid: $uid, username: $username}';
  }
}
