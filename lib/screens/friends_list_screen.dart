import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/providers/chat_provider.dart';
import 'package:harmony_app/screens/add_friends_screen.dart';
import 'package:harmony_app/screens/chat_screen.dart';
import 'package:harmony_app/screens/friend_requests_screen.dart';
import 'package:harmony_app/screens/profile_friends_screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/widgets/add_friends_widgets/friends_list_app_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/friends_list_provider.dart';
import '../widgets/add_friends_widgets/friends_list_view_widget.dart';

//this screen displays the friends list from the current user.
//it uses a stream builder to query the information from firestore
//it displays the informations in Cards
UserModel? currUser;

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final FriendsListProvider _friendsListProvider =
      Provider.of<FriendsListProvider>(Get.context!, listen: false);
  FriendsListAppBar? friendsListAppBar;

  @override
  void initState() {
    super.initState();
    friendsListAppBar = FriendsListAppBar(callback: this.callback);
  }

  void callback() {
    setState(() {}); //refresh this page to show any changes
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FriendsListProvider myFriendsListProvider, Widget? child) {
        return LoadingOverlay(
          isLoading: myFriendsListProvider.isLoading,

          child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: AppColors.green,
            //   title: Text(
            //     ''
            //     'Harmony',
            //     style: AppTextStyles.appBar(),
            //   ),
            //   actions: [
            //     IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => FriendRequestsScreen()));
            //         },
            //         icon: Icon(Icons.person_add)),
            //     IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => AddFriendsScreen()));
            //         },
            //         icon: Icon(Icons.search)),
            //     IconButton(
            //         onPressed: () {
            //           setState(() {}); //refresh this page to show any changes
            //         },
            //         icon: Icon(Icons.refresh))
            //   ],
            // ),
            // body: Column(children: <Widget>[
            //   Consumer<AuthProvider>(builder: (BuildContext context,
            //       AuthProvider myAuthProvider, Widget? child) {
            //     myAuthProvider.updateCurrentUser();
            //     currUser = (myAuthProvider.currentUserModel!);
            //     friendsList = (myAuthProvider.currentUserModel?.friends)!;
            //     return const Text("");
            //   }),
            appBar: friendsListAppBar,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 500.h,
                      width: double.infinity,
                      child: const FriendsListViewWidget()),
                ),
              ],
            ),
            //]
          ),
        );
      },
    );
    //);
  }
}

void refresh() {
  Consumer<AuthProvider>(
    builder:
        (BuildContext context, AuthProvider myAuthProvider, Widget? child) {
      myAuthProvider.updateCurrentUser();
      currUser = (myAuthProvider.currentUserModel!);
      friendsList = (myAuthProvider.currentUserModel?.friends)!;
      return const SizedBox.shrink();
    },
  );
}
