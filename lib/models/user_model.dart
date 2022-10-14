class UserModel {
  String email;
  String firstName;
  String lastName;
  String uid;
  String userName;
  var friends;

  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.uid,
      required this.userName,
      //required this.friendRequests,
      required this.friends}
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    friends: json["friends"],
    //friendRequests: json["friendRequests"],
    uid: json["uid"],
    userName: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "friends": friends,
    //"friendRequests": friendRequests,
    "uid": uid,
    "username": userName,
  };

  @override
  String toString() {
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, friends: $friends, uid: $uid, username: $userName}';
  }
}
