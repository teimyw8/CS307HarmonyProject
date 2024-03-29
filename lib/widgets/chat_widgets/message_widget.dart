import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatefulWidget {
  final MessageModel messageModel;
  final bool sentByMe;
  final UserModel userModel;

  const MessageWidget(
      {Key? key,
        required this.messageModel,
        required this.sentByMe,
        required this.userModel
      })
      : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4.h,
          bottom: 4.h,
          left: widget.sentByMe ? 0 : 24.w,
          right: widget.sentByMe ? 24.w : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: (widget.sentByMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: widget.sentByMe
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: widget.sentByMe
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: widget.sentByMe
                    ? AppColors.green
                    : AppColors.grey60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.userModel.firstName} ${widget.userModel.lastName}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(widget.messageModel.message,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, color: Colors.black))
              ],
            ),
          ),
          Text("${DateFormat("dd MMM HH:mm").format(widget.messageModel.dateSent)}"),
          Row(
            mainAxisAlignment: (widget.sentByMe) ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Icon(Icons.library_add_check_outlined, size: 20.h, color: (widget.messageModel.isRead) ? AppColors.green : AppColors.grey60,),
              SizedBox(width: 5.w,),
              Text((widget.messageModel.isRead) ? "Read" : "Not read")
            ],
          ),
        ],
      ),
    );
  }
}