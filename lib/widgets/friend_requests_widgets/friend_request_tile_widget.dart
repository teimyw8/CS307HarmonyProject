import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/user_model.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_button.dart';

class FriendRequestTileWidget extends StatefulWidget {
  UserModel userModel;
  VoidCallback onAccept;
  VoidCallback onDeny;

  FriendRequestTileWidget(
      {required this.userModel, required this.onAccept, required this.onDeny});

  @override
  State<FriendRequestTileWidget> createState() =>
      _FriendRequestTileWidgetState();
}

class _FriendRequestTileWidgetState extends State<FriendRequestTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r), color: AppColors.grey20),
      padding: EdgeInsets.all(10.h),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50.h,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.userModel.firstName} ${widget.userModel.lastName}",
                    style: AppTextStyles.tileText(),
                  ),
                  Text(
                    "@${widget.userModel.username}",
                    style: AppTextStyles.tileText()
                        .copyWith(color: AppColors.greyText, fontSize: 13.sp),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              CustomAppButton(
                buttonColor: AppColors.redError,
                onTap: () {
                  widget.onDeny();
                },
                widget: Text(
                  "Deny",
                  style: AppTextStyles.button(),
                ),
              ),
              SizedBox(width: 10.w,),
              CustomAppButton(
                buttonColor: AppColors.green,
                onTap: () {
                  widget.onAccept();
                },
                widget: Text(
                  "Accept",
                  style: AppTextStyles.button(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
