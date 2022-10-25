import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  'in progress',
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
