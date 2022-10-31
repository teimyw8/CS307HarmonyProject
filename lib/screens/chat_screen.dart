import 'package:flutter/material.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatScreen extends StatefulWidget {
  // ChatModel chatModel;

  ChatScreen(
    // this.chatModel
  );

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      title: "Harmony",
      needBackArrow: true,
      needAvatar: false,
      needSettings: false,
      needHome: false,
    ),
      body: Chat(
        messages: [],
        onAttachmentPressed: () {},
        onMessageTap: (context, value) {},
        onPreviewDataFetched: (context, value) {},
        onSendPressed: (value) {},
        showUserAvatars: true,
        showUserNames: true,
        user: types.User(id: ""),
      ),
    );
  }
}
