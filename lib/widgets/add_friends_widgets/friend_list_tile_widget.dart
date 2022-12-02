import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/providers/friends_list_provider.dart';
import 'package:harmony_app/screens/friends_list_screen.dart';
import 'package:harmony_app/screens/profile_screen.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';
import 'package:provider/provider.dart';

class FriendListTileWidget extends StatefulWidget {
  UserModel friendModel;


  FriendListTileWidget(this.friendModel);

  @override
  State<FriendListTileWidget> createState() => _FriendListTileWidgetState();
}

class _FriendListTileWidgetState extends State<FriendListTileWidget> {
  final FriendsListProvider _friendsListProvider =
      Provider.of<FriendsListProvider>(Get.context!, listen: false);
  ChatProvider chatProvider =
      Provider.of<ChatProvider>(Get.context!, listen: false);
  AuthProvider authProvider =
      Provider.of<AuthProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: (widget.friendModel.blockedUsers
              .contains(authProvider.currentUserModel!.uid)) ? Colors.grey : Colors.transparent,
          backgroundBlendMode: BlendMode.saturation,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // ProfilePicture(
            //   name: '',
            //   radius: 25,
            //   fontsize: 21,
            //   img: widget.friendModel.profilepic,
            // ),
            TextButton(
              onPressed: () async {
                if (widget.friendModel.blockedUsers
                    .contains(authProvider.currentUserModel!.uid)) return;
                await _friendsListProvider.setUserModel(widget.friendModel.uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            userModel: _friendsListProvider.temp!,
                            isPrivate: _friendsListProvider
                                .isPrivateUser(_friendsListProvider.temp!))));
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: AppColors.white,
              ),
              child: Text(
                widget.friendModel.firstName,
                style: TextStyle(color: AppColors.green),
              ),
            ),
            Spacer(),
            Container(
              child: Row(
                children: [
                  Consumer<AuthProvider>(
                    builder: (BuildContext context, AuthProvider myAuthProvider,
                        Widget? child) {
                      return CustomAppButton(
                        widget: Text(
                          (myAuthProvider.currentUserModel!.blockedUsers
                                  .contains(widget.friendModel.uid))
                              ? "Unblock"
                              : "Block",
                          style: AppTextStyles.button(),
                        ),
                        onTap: () {
                          if (myAuthProvider.currentUserModel!.blockedUsers
                              .contains(widget.friendModel.uid)) {
                            _friendsListProvider.unblockUser(
                                uid: widget.friendModel.uid);
                          } else {
                            _friendsListProvider.blockUser(
                                uid: widget.friendModel.uid);
                          }
                        },
                        buttonColor: AppColors.redError,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.message),
                    color: Colors.green,
                    onPressed: () {
                      if (widget.friendModel.blockedUsers
                          .contains(authProvider.currentUserModel!.uid)) return;
                      chatProvider.openChatScreenFromFriendListWidget(
                          uid1: authProvider.currentUserModel!.uid,
                          uid2: widget.friendModel.uid);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () {
                      if (widget.friendModel.blockedUsers
                          .contains(authProvider.currentUserModel!.uid)) return;
                      var collection =
                          FirebaseFirestore.instance.collection('users');
                      collection.doc(authProvider.currentUserModel!.uid).update({
                        'friends':
                            FieldValue.arrayRemove([widget.friendModel.uid]),
                      });
                      print("_friendsListProvider.currUser: ${authProvider.currentUserModel!.uid}");
                      collection.doc(widget.friendModel.uid).update({
                        'friends': FieldValue.arrayRemove(
                            [authProvider.currentUserModel!.uid]),
                      });
                      _friendsListProvider.authProvider.currentUserModel!.friends
                          .remove(widget.friendModel.uid);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
