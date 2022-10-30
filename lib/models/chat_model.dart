import 'package:harmony_app/models/message_model.dart';

class ChatModel {
  List<MessageModel> messages;
  String partnerUserId;
  String chatId;

  ChatModel(
      {required this.messages,
      required this.partnerUserId,
      required this.chatId});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      messages: json["messages"] == null
          ? []
          : List<MessageModel>.from(
              json["messages"].map((x) => MessageModel.fromJson(x))),
      partnerUserId: json['partnerUserId'] ?? "",
      chatId: json['chatId'] ?? '');

  Map<String, dynamic> toJson() => {
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    "partnerUserId": partnerUserId,
    "chatId": chatId,
  };
}
