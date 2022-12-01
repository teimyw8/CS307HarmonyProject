import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/screens/chat_screen.dart';
import 'package:harmony_app/widgets/common_widgets/pop_up_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatTileWidget extends StatefulWidget {
  ChatModel chatModel;
  String chatId;

  ChatTileWidget({required this.chatModel, required this.chatId});

  @override
  State<ChatTileWidget> createState() => _ChatTileWidgetState();
}

class _ChatTileWidgetState extends State<ChatTileWidget> {
  ChatProvider chatProvider =
      Provider.of<ChatProvider>(Get.context!, listen: false);
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  UserModel? partnerUserModel;

  Future<void> getPartnerModel() async {
    partnerUserModel = await chatProvider.getPartnerUserModelFromFirestore(
        uid: (widget.chatModel.uid1 == authProvider.currentUserModel!.uid)
            ? widget.chatModel.uid2
            : widget.chatModel.uid1);
    setState(() => {});
  }

  @override
  void initState() {
    getPartnerModel();
    setState(() => {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (partnerUserModel == null)
        ? Container()
        : GestureDetector(
            onTap: () async {
              if (partnerUserModel!.blockedUsers
                  .contains(authProvider.currentUserModel!.uid)) {
                PopUpDialog.showAcknowledgePopUpDialog(
                    title: "Can't open chat",
                    message: "This user blocked you",
                    onOkClick: () {
                      Get.close(1);
                    });
                return;
              }
              Get.to(() => ChatScreen(
                    doesChatExistInFirestore: true,
                    chatModel: widget.chatModel,
                    myUserModel: authProvider.currentUserModel!,
                    partnerUserModel: partnerUserModel!,
                    chatId: widget.chatId,
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.grey20),
              padding: EdgeInsets.all(10.h),
              margin: EdgeInsets.only(bottom: 10.h),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${partnerUserModel!.firstName} ${partnerUserModel!.lastName}",
                          style: AppTextStyles.footNote().copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "${DateFormat("dd MMM HH:mm").format(widget.chatModel.lastEdited)}",
                        style: AppTextStyles.footNote(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.chatModel.lastMessage}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.footNote()
                                .copyWith(color: AppColors.greyText),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('chats').doc(widget.chatModel.chatId).collection('messages').snapshots(),
                          builder: (context, snapshot) {
                            return FutureBuilder<dynamic>(
                                future: chatProvider.isLastMessageRead(
                                    chatId: widget.chatModel.chatId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    if (snapshot.data == false) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10.w),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.redError),
                                        height: 10.h,
                                        width: 10.h,
                                      );
                                    }
                                  }
                                  return Container();
                                });
                          }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
