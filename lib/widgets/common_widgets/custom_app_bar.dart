import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/screens/edit_profile_screen.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';

import '../../models/user_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height = 88.h;
  final bool needBackArrow;
  final bool needSettings;
  final bool needAvatar;
  final bool needHome;
  final String backArrowLabel;
  final bool isAuthAppBar;
  VoidCallback? onHomeClicked;

  CustomAppBar(
      {Key? key,
      this.title = "",
      this.isAuthAppBar = false,
      this.needBackArrow = true,
      this.needSettings = false,
      this.needAvatar = false,
      this.needHome = false,
      this.onHomeClicked = null,
      this.backArrowLabel = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAuthAppBar) {
      return SizedBox.fromSize(
        size: preferredSize,
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: preferredSize.height,
                  color: AppColors.white,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.w, right: 15.w, bottom: 0.h, top: 40.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 40.w,
                            child: (needBackArrow)
                                ? GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: AppColors.green,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(width: 40.w)),
                        if (title.isNotEmpty)
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: AppTextStyles.appBar()),
                            ),
                          ),
                        SizedBox(
                          width: 40.w,
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
    } else {
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
                  alignment: Alignment.bottomCenter,
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
                        Row(
                          children: [
                            if (needAvatar)
                              Container(
                                  width: 40.w,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.white,
                                  )),
                            if (needHome)
                              GestureDetector(
                                onTap: () {
                                  if (onHomeClicked != null) {
                                    onHomeClicked!();
                                  }
                                },
                                child: Container(
                                    width: 40.w,
                                    child: Icon(
                                      Icons.home,
                                      color: AppColors.white,
                                    )),
                              ),
                            if (needSettings)
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => EditProfileScreen());
                                },
                                child: Container(
                                    width: 40.w,
                                    child: Icon(
                                      Icons.settings,
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

  @override
  Size get preferredSize => Size.fromHeight(height);
}
