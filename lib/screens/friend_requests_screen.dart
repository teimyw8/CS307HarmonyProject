import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/add_friends_provider.dart';
import 'package:harmony_app/providers/auth_provider.dart';
import 'package:harmony_app/providers/friend_requests_provider.dart';
import 'package:harmony_app/services/firestore_service.dart';
import 'package:harmony_app/widgets/add_friends_widgets/user_tile_widget.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  FirestoreService get _firestoreService => GetIt.instance<FirestoreService>();
  AddFriendsProvider _addFriendsProvider =
      Provider.of<AddFriendsProvider>(Get.context!, listen: false);

  @override
  void initState() {
    _addFriendsProvider.initializeVariables();
    super.initState();
  }

  @override
  void dispose() {
    _addFriendsProvider.disposeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Add Friends",
          needBackArrow: true,
        ),
        body: Consumer2<FriendRequestsProvider, AuthProvider>(
          builder: (BuildContext context,
              FriendRequestsProvider myFriendRequestsProvider,
              AuthProvider myAuthProvider,
              Widget? child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(children: [
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 40.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "Friend Requests",
                      style: AppTextStyles.headline().copyWith(fontSize: 32.sp),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myFriendRequestsProvider.friendRequestsReceived.length,
                      itemBuilder: (context, index) {
                        return SearchUserTileWidget(
                          userModel: myFriendRequestsProvider.friendRequestsReceived[index],
                          onSendFriendRequest: () {},
                          isFriendRequestSent: false,
                        );
                        // return Text(users[index].toString());
                      }),
                )
              ]),
            );
          },
        ),
      ),
    );
  }
}
