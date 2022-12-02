import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/widgets/chat_widgets/chat_post_response_widget.dart';
import 'package:harmony_app/widgets/chat_widgets/message_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';
import 'package:provider/provider.dart';
import '../widgets/common_widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chatModel;
  final UserModel partnerUserModel;
  final UserModel myUserModel;
  final bool doesChatExistInFirestore;
  final String chatId;

  const ChatScreen(
      {Key? key,
      required this.chatModel,
      required this.partnerUserModel,
      required this.myUserModel,
      required this.doesChatExistInFirestore,
      required this.chatId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatService get firestoreService => GetIt.instance<ChatService>();
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
  ChatProvider chatProvider =
      Provider.of<ChatProvider>(Get.context!, listen: false);
  ScrollController _scrollController = new ScrollController();

  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      chatProvider.initializeVariables(
          doesChatExist: widget.doesChatExistInFirestore);
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration(seconds: 0), () {
      chatProvider.disposeVariables();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needAvatar: false,
          needSettings: false,
          needHome: false,
          onHomeClicked: () {},
        ),
        body: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider myChatProvider,
              Widget? child) {
            if (!myChatProvider.areVariablesInitialized) return Container();
            return Stack(
              children: <Widget>[
                // chat messages here
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.grey70.withOpacity(0.5),
                    child: Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Send a message...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          border: InputBorder.none,
                        ),
                      )),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          height: 50.h,
                          width: 50.h,
                          padding: EdgeInsets.all(4.h),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                        ),
                      )
                    ]),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc("${widget.chatModel.chatId}")
          .collection('messages')
          .orderBy('dateSent')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        //reading all messages
        if (!snapshot.hasData) return CustomAppLoader();
        if (snapshot.hasError) return Text(snapshot.error.toString());
        readAllMessages(snapshot.data.docs);
        return ListView(
          reverse: true,
          padding: EdgeInsets.only(bottom: 150.h),
          children: snapshot.data.docs.reversed
              .map<Widget>((DocumentSnapshot document) {
            MessageModel messageModel =
                MessageModel.fromJson(document.data() as Map<String, dynamic>);
            UserModel userModel =
                (authProvider.currentUserModel!.uid == messageModel.fromUserId)
                    ? widget.myUserModel
                    : widget.partnerUserModel;
            if (messageModel.messageType == "message") {
              return MessageWidget(
                messageModel: messageModel,
                sentByMe: widget.myUserModel.uid == messageModel.fromUserId,
                userModel: userModel,
              );
            } else if (messageModel.messageType == "postResponse") {
              return ChatPostResponseWidget(
                messageModel: messageModel,
                sentByMe: widget.myUserModel.uid == messageModel.fromUserId,
                userModel: userModel, postModel: messageModel.postModel!,
              );
            }
            return Container();

          }).toList(),
        );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      chatProvider.sendMessageToChat(
          chatModel: widget.chatModel,
          message: messageController.text,
          tokenId: widget.partnerUserModel.tokenId);
      setState(() {
        messageController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  readAllMessages(dynamic documents) async {
    int i = 0;
    for (dynamic document in documents) {
      MessageModel messageModel =
          MessageModel.fromJson(document.data() as Map<String, dynamic>);
      if (messageModel.fromUserId != authProvider.currentUserModel!.uid) {
        var messageDocRef = FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatModel.chatId)
            .collection('messages')
            .doc(document.id);
        await messageDocRef.update({
          'isRead': true,
        });
      }
      if (i == documents.length - 1) {
        if (messageModel.fromUserId != authProvider.currentUserModel!.uid) {
          var chatDocRef = FirebaseFirestore.instance
              .collection('chats')
              .doc(widget.chatId);
          await chatDocRef.update({
            'isLastMessageRead': true,
          });
        }
      }
      i++;
    }
  }
}
