import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/widgets/add_friends_widgets/friends_list_app_bar.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/friends_list_provider.dart';
import '../widgets/add_friends_widgets/friends_list_view_widget.dart';

//this screen displays the friends list from the current user.
//it uses a stream builder to query the information from firestore
//it displays the informations in Cards

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
    return Scaffold(
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
    );
  }
}
