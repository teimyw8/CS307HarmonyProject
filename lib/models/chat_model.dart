import 'package:harmony_app/models/message_model.dart';

class ChatModel {
  List<MessageModel> messages;
  String partnerUserId;

  ChatModel({required this.messages, required this.partnerUserId});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      messages: json["messages"] == null
          ? []
          : List<MessageModel>.from(
          json["messages"].map((x) => MessageModel.fromJson(x))),
      partnerUserId: json['partnerUserId'] ?? ""
  );
}