import 'package:harmony_app/models/message_model.dart';

class ChatModel {
  String uid1;
  String uid2;
  String chatId;
  String lastMessage;
  DateTime lastEdited;

  ChatModel(
      {
      required this.uid1,
      required this.uid2,
      required this.chatId,
        required this.lastMessage,
        required this.lastEdited
      });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      uid1: json['uid1'] ?? "",
      uid2: json['uid2'] ?? "",
      chatId: json['chatId'] ?? "",
      lastMessage: json['lastMessage'] ?? '',
      lastEdited: (json["lastEdited"] == null) ? DateTime.now() : json["lastEdited"].toDate(),);

  Map<String, dynamic> toJson() => {
        "uid1": uid1,
        "uid2": uid2,
        "chatId": chatId,
        "lastMessage": lastMessage
      };

  @override
  String toString() {
    return 'ChatModel{uid1: $uid1, uid2: $uid2, chatId: $chatId}';
  }
}
