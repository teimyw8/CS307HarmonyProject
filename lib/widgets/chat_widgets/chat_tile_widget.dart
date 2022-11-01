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
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatTileWidget extends StatefulWidget {
  ChatModel chatModel;

  ChatTileWidget({
    required this.chatModel,
  });

  @override
  State<ChatTileWidget> createState() => _ChatTileWidgetState();
}

class _ChatTileWidgetState extends State<ChatTileWidget> {
  ChatProvider chatProvider = Provider.of<ChatProvider>(Get.context!, listen: false);
  AuthProvider authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);

  UserModel? partnerUserModel;

  Future<void> getPartnerModel() async {
    partnerUserModel = await chatProvider.getPartnerUserModelFromFirestore(uid: (widget.chatModel.uid1 == authProvider.currentUserModel!.uid) ? widget.chatModel.uid2 : widget.chatModel.uid1);
    setState(()=>{});
  }

  @override
  void initState() {
    getPartnerModel();
    setState(()=>{});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return (partnerUserModel == null) ? Container() : GestureDetector(
      onTap: () {
        Get.to(() => ChatScreen(chatModel: widget.chatModel, myUserModel: authProvider.currentUserModel!, partnerUserModel: partnerUserModel!,));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: AppColors.grey20),
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 10.h),
        width: double.infinity,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${partnerUserModel!.firstName} ${partnerUserModel!.lastName}: ${widget.chatModel.lastMessage}",
                    style: AppTextStyles.footNote().copyWith(color: AppColors.greyText),
                  ),
                ),
              ],
            ),
            Text(
              "${DateFormat("dd MMM HH:mm").format(widget.chatModel.lastEdited)}",
              style: AppTextStyles.footNote(),
            ),
          ],
        ),
      ),
    );
  }
}


//return ListView.builder(
//           reverse: true,
//           padding: EdgeInsets.only(bottom: 150.h),
//           itemBuilder: (BuildContext context, int index) {
//             MessageModel messageModel =
//             MessageModel.fromJson(snapshot.data.docs[index].data() as Map<String, dynamic>);
//             UserModel userModel =
//             (authProvider.currentUserModel!.uid == messageModel.fromUserId)
//                 ? widget.myUserModel
//                 : widget.partnerUserModel;
//             return MessageWidget(
//               messageModel: messageModel,
//               sentByMe: widget.myUserModel.uid == messageModel.fromUserId,
//               userModel: userModel,
//             );
//           },
//         );