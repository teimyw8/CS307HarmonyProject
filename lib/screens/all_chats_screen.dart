import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/models/chat_model.dart';
import 'package:harmony_app/models/message_model.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/services/chat_service.dart';
import 'package:harmony_app/widgets/chat_widgets/chat_tile_widget.dart';
import 'package:harmony_app/widgets/chat_widgets/message_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';
import 'package:provider/provider.dart';
import '../widgets/common_widgets/custom_app_bar.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  ChatService get firestoreService => GetIt.instance<ChatService>();
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    // getChatandAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Harmony 111  11",
          needBackArrow: true,
          needAvatar: false,
          needSettings: false,
          needHome: false,
          onHomeClicked: () {},
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('An error occurred');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomAppLoader();
            }
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: documents
                    .map((e) =>
                    ChatTileWidget(
                          chatModel: ChatModel.fromJson(
                              e.data() as Map<String, dynamic>),
                        )
                )
                    .toList());
          },
        ));
  }
}
