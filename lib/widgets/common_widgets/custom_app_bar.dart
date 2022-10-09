import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/editprofile.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height = 88.h;
  final bool needBackArrow;
  final bool needSettings;
  final bool needAvatar;
  final bool needHome;
  final String backArrowLabel;

  CustomAppBar(
      {Key? key,
      this.title = "",
      this.needBackArrow = true,
      this.needSettings = false,
      this.needAvatar = false,
      this.needHome = false,
      this.backArrowLabel = ""})
      : super(key: key);

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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: AppTextStyles.appBar(),
                            ),
                          ),
                        ),
                      if (needSettings)
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const EditProfile();
                                  },
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.settings,
                            ),
                          ),
                        ),
                      (needAvatar)
                          ? Container(
                              width: 40.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            )
                          : SizedBox(
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
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
