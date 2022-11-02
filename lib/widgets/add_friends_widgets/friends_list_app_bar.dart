import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_bar.dart';
import 'package:get/get.dart';

import '../../helpers/colors.dart';
import '../../helpers/text_styles.dart';
import '../../screens/add_friends_screen.dart';
import '../../screens/friend_requests_screen.dart';

class FriendsListAppBar extends CustomAppBar {
  Function callback;
  static const TITLE = "Harmony";

  FriendsListAppBar({super.key, required this.callback, super.title = TITLE});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: preferredSize.height,
                color: AppColors.green,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, bottom: 0.h, top: 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (needBackArrow)
                          ? GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40.w,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          : Text(title,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: AppTextStyles.largeTitle().copyWith(
                                  fontSize: 30.sp, color: AppColors.white)),
                      if (needBackArrow)
                        Text(title,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: AppTextStyles.largeTitle().copyWith(
                                fontSize: 30.sp, color: AppColors.white)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const FriendRequestsScreen());
                            },
                            child: Container(
                                width: 40.w,
                                child: Icon(
                                  Icons.person_add,
                                  color: AppColors.white,
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const AddFriendsScreen());
                            },
                            child: Container(
                                width: 40.w,
                                child: Icon(
                                  Icons.search,
                                  color: AppColors.white,
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              callback();
                            },
                            child: Container(
                                width: 40.w,
                                child: Icon(
                                  Icons.refresh,
                                  color: AppColors.white,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
