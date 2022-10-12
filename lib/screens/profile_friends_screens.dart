import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';

import '../helpers/colors.dart';
import '../helpers/text_styles.dart';


class friends_profile_screen extends StatelessWidget {
  final String name;
  const friends_profile_screen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(
          'Harmony',
          style: AppTextStyles.appBar(),
        ),
      ),

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
                  name,
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
