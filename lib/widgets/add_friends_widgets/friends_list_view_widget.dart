import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/friend_screen_provider.dart';
import 'package:harmony_app/screens/profile_screen.dart';
import 'package:harmony_app/widgets/add_friends_widgets/friend_list_tile_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../helpers/colors.dart';
import '../../helpers/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/friends_list_provider.dart';

List<dynamic>? friendsList;

class FriendsListViewWidget extends StatefulWidget {
  const FriendsListViewWidget({Key? key}) : super(key: key);

  @override
  _FriendsListViewWidgetState createState() => _FriendsListViewWidgetState();
}
//get your own user id mcon
//returns json contains friends
//for each uid call the display
//

class _FriendsListViewWidgetState extends State<FriendsListViewWidget> {
  final FriendsListProvider _friendsListProvider =
      Provider.of<FriendsListProvider>(Get.context!, listen: false);
  ChatProvider chatProvider =
      Provider.of<ChatProvider>(Get.context!, listen: false);
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder:
        (BuildContext context, AuthProvider myAuthProvider, Widget? child) {

      myAuthProvider.updateCurrentUser();
      friendsList = myAuthProvider.currentUserModel?.friends;
      debugPrint("friendslist = " + friendsList.toString());

      if (friendsList!.contains(myAuthProvider.currentUserModel?.uid.toString())) {
        friendsList?.remove(myAuthProvider.currentUserModel?.uid.toString());
      }
      if (friendsList!.isEmpty) {
        debugPrint('here');
        return Text(
          'No friends',
          style: AppTextStyles.headline(),
        );
      }

      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("uid", whereIn: friendsList)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error, reload');
          }

          List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];
          return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: documents.map((e) {
                UserModel friendModel =
                    UserModel.fromJson(e.data() as Map<String, dynamic>);
                return FriendListTileWidget(friendModel);
              }).toList());
        },
      );
    });
  }
}
