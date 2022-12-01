class UserModel {
  String email;
  String firstName;
  String lastName;
  String uid;
  String username;
  String bio;
  String spotifyToken;
  String profilepic;
  bool dailyNotifStatus;
  bool chatNotifStatus;
  int displayProfileTo;
  bool displayName; //whether or not we display the name is profile page
  List<dynamic> friends;
  List<dynamic> friendRequestsSent;
  List<dynamic> friendRequestsReceived;
  List<dynamic> blockedUsers;
  String tokenId;
  bool FRNotifStatus;

  UserModel(
      {required this.email,
      required this.dailyNotifStatus,
      required this.chatNotifStatus,
      required this.firstName,
      required this.lastName,
      required this.uid,
      required this.username,
      required this.FRNotifStatus,
      required this.bio,
      required this.friends,
      required this.displayProfileTo,
      required this.displayName,
      required this.spotifyToken,
      required this.profilepic,
      required this.friendRequestsReceived,
      required this.friendRequestsSent,
      required this.blockedUsers,
      required this.tokenId});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      bio: json["bio"] ?? "",
      dailyNotifStatus: json["dailyNotifStatus"] ?? true,
      friends: json["friends"] ?? [],
      uid: json["uid"] ?? "",
      FRNotifStatus: json["FRNotifStatus"] ?? true,
      profilepic: json["profilepic"] ?? "",
      username: json["username"] ?? "",
      displayProfileTo: json["displayProfileTo"] ?? 0,
      displayName: json["displayName"] ?? true,
      chatNotifStatus: json["chatNotifStatus"] ?? true,
      spotifyToken: json["spotifyToken"] ?? "",
      friendRequestsReceived: json["friendRequestsReceived"] ?? [],
      friendRequestsSent: json["friendRequestsSent"] ?? [],
      blockedUsers: json["blockedUsers"] ?? [],
      tokenId: json["tokenId"] ?? "");

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "bio": bio,
        "friends": friends,
        "dailyNotifStatus": dailyNotifStatus,
        "uid": uid,
        "FRNotifStatus": FRNotifStatus,
        "profilepic": profilepic,
        "username": username,
        "chatNotifStatus": chatNotifStatus,
        "displayProfileTo": displayProfileTo,
        "displayName": displayName,
        "spotifyToken": spotifyToken,
        "friendRequestsReceived": friendRequestsReceived,
        "friendRequestsSent": friendRequestsSent,
        "blockedUsers": blockedUsers,
        "tokenId": tokenId
      };

  @override
  String toString() {
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, uid: $uid, username: $username, bio: $bio, spotifyToken: $spotifyToken, profilepic: $profilepic, displayProfileTo: $displayProfileTo, displayName: $displayName, friends: $friends, friendRequestsSent: $friendRequestsSent, friendRequestsReceived: $friendRequestsReceived, blockedUsers: $blockedUsers, tokenId: $tokenId}';
  }
}
