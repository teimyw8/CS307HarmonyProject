import 'package:harmony_app/models/user_model.dart';

class MessageModel {
  String message;
  DateTime dateSent;
  String messageId;
  bool isRead;
  String fromUserId;

  MessageModel({required this.message, required this.dateSent, required this.messageId, required this.isRead, required this.fromUserId});


  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    message: json["message"] ?? "",
    dateSent: (json["dateSent"] == null) ? DateTime.now() : DateTime.parse(json["dateSent"]),
    messageId: json['messageId'] ?? "",
    isRead: json['isRead'] ?? false,
    fromUserId: json['fromUserId'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "dateSent": dateSent,
    "messageId": messageId,
    "isRead": isRead,
    "fromUserId": fromUserId,
  };

}