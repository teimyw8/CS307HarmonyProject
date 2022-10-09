class UserModel {
  String email;
  String firstName;
  String lastName;
  String uid;
  String userName;

  UserModel(
      {required this.email,
        required this.firstName,
        required this.lastName,
        required this.uid,
        required this.userName});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    uid: json["uid"],
    userName: json["userName"],

  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "uid": uid,
    "userName": userName,
  };

  @override
  String toString() {
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, uid: $uid, userName: $userName}';
  }
}
