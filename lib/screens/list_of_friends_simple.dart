import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/friends_list_provider.dart';
import '../widgets/add_friends_widgets/simplified_friends_list_widget.dart';

class ListOfFriends extends StatefulWidget {
  UserModel userModel;
  ListOfFriends({Key? key, required this.userModel}) : super(key: key);

  @override
  _ListOfFriendsState createState() => _ListOfFriendsState();
}

class _ListOfFriendsState extends State<ListOfFriends> {
  final FriendsListProvider _friendsListProvider =
  Provider.of<FriendsListProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.userModel.username + " friends",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                height: 500.h,
                width: double.infinity,
                child: simpFriendsListWidget(userModel: widget.userModel),
          ),
          ),
        ],
      ),
    );
  }
}
