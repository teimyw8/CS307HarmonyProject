import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/screens/list_of_friends_simple.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../providers/edit_profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;
  bool isPrivate;

  ProfileScreen({Key? key, required this.userModel, required this.isPrivate}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    if (widget.isPrivate) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needSettings: true,
          needFriendsList: true,
        ),
        backgroundColor: AppColors.green,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 70),
                  child: Text(
                    "@${widget.userModel.username}",
                    style: AppTextStyles.profileNames(),
                  ),
                ),
              ],
            ),
            Text(
              "Private Page",
              style: AppTextStyles.tileText().apply(fontSizeDelta: 30, fontWeightDelta: 2),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Harmony",
          needBackArrow: true,
          needSettings: true,
          needFriendsList: true,
        ),
        backgroundColor: AppColors.green,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: AppColors.green,
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 65,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editProfileProvider.getPrimaryName(widget.userModel),
                        style: AppTextStyles.profileNames(),
                      ),
                      (widget.userModel.displayName? Text("@${widget.userModel.username}",
                        style: AppTextStyles.subNote()
                            .apply(color: AppColors.white),
                      )
                          : SizedBox()),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: AppTextStyles.button(),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListOfFriends(userModel: widget.userModel,)));
                        },
                        child: const Text('Friends'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 17, vertical: 0),
              child: Text(
                widget.userModel.bio,
                style: AppTextStyles.tileText().apply(color: AppColors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
