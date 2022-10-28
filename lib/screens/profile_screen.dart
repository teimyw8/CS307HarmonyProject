import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';
import '../providers/edit_profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;

  ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final EditProfileProvider _editProfileProvider =
      Provider.of<EditProfileProvider>(Get.context!, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        needBackArrow: true,
        needSettings: true,
      ),
      backgroundColor: AppColors.green,
      body: Column(
        children: <Widget>[
          Container(
            color: AppColors.green,
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 70.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                Text(
                  _editProfileProvider.getPrimaryName(widget.userModel),
                  style: AppTextStyles.profileNames(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
