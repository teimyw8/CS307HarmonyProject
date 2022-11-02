import 'package:harmony_app/helpers/helper_functions.dart';
import 'package:harmony_app/models/message_model.dart';

class ChatModel {
  String uid1;
  String uid2;
  String chatId;
  String lastMessage;
  DateTime lastEdited;
  String lastMessageSentFromUID;


  ChatModel(
      {
      required this.uid1,
      required this.uid2,
      required this.chatId,
        required this.lastMessage,
        required this.lastEdited,
        required this.lastMessageSentFromUID
      });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      uid1: json['uid1'] ?? "",
      uid2: json['uid2'] ?? "",
      chatId: json['chatId'] ?? "",
      lastMessage: json['lastMessage'] ?? '',
      lastEdited: (json["lastEdited"] == null) ? dateTimeToEST(DateTime.now()) : json["lastEdited"].toDate(),
      lastMessageSentFromUID: json['lastMessageSentFromUID'] ?? '',);

  Map<String, dynamic> toJson() => {
        "uid1": uid1,
        "uid2": uid2,
        "chatId": chatId,
        "lastMessage": lastMessage,
        "lastMessageSentFromUID": lastMessageSentFromUID,
      };

  @override
  String toString() {
    return 'ChatModel{uid1: $uid1, uid2: $uid2, chatId: $chatId}';
  }
}
