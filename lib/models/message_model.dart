import 'package:harmony_app/helpers/helper_functions.dart';
import 'package:harmony_app/models/post_model.dart';
import 'package:harmony_app/models/user_model.dart';

class MessageModel {
  String message;
  DateTime dateSent;
  String messageId;
  bool isRead;
  String fromUserId;
  String messageType;
  PostModel? postModel;

  @override
  String toString() {
    return 'MessageModel{message: $message, dateSent: $dateSent, messageId: $messageId, isRead: $isRead, fromUserId: $fromUserId, messageType: $messageType, postModel: $postModel}';
  }

  MessageModel(
      {required this.message,
      required this.dateSent,
      required this.messageId,
      required this.isRead,
      required this.fromUserId,
      required this.messageType,
      required this.postModel});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json["message"] ?? "",
        dateSent: (json["dateSent"] == null)
            ? dateTimeToEST(DateTime.now())
            : json["dateSent"].toDate(),
        messageId: json['messageId'] ?? "",
        isRead: json['isRead'] ?? false,
        fromUserId: json['fromUserId'] ?? '',
        messageType: json['messageType'] ?? 'message',
        postModel: (json['postModel'] != null) ? PostModel.fromJson(json['postModel']) : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "dateSent": dateSent,
        "messageId": messageId,
        "isRead": isRead,
        "fromUserId": fromUserId,
        "messageType": messageType,
        "postModel": postModel?.toJson()
      };
}
