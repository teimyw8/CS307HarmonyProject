import 'package:harmony_app/models/user_model.dart';

class MessageModel {
  String message;
  DateTime timeStamp;
  String messageId;
  bool isRead;
  String fromUserId;

  MessageModel({required this.message, required this.timeStamp, required this.messageId, required this.isRead, required this.fromUserId});


  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    message: json["message"] ?? "",
      timeStamp: (json["timeStamp"] == null) ? DateTime.now() : DateTime.parse(json["timeStamp"]),
    messageId: json['messageId'] ?? "",
    isRead: json['isRead'] ?? false,
    fromUserId: json['fromUserId'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "dateSent": timeStamp,
    "messageId": messageId,
    "isRead": isRead,
    "fromUserId": fromUserId,
  };

}