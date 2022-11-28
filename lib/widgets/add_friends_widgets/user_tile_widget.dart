import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'package:harmony_app/models/user_model.dart';

class SearchUserTileWidget extends StatefulWidget {
  UserModel userModel;
  bool isFriendRequestSent;
  VoidCallback onSendFriendRequest;

  SearchUserTileWidget(
      {required this.userModel,
      required this.onSendFriendRequest,
      required this.isFriendRequestSent});

  @override
  State<SearchUserTileWidget> createState() => _SearchUserTileWidgetState();
}

class _SearchUserTileWidgetState extends State<SearchUserTileWidget> {
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
              (widget.userModel.profilepic == null || widget.userModel.profilepic == "")
              ? Container(
                height: 50.h,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
              : Container(
                height: 50.h,
                child: CachedNetworkImage(
                  imageUrl:
                  widget.userModel.profilepic,
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
                  if (widget.userModel.displayName)
                    Text(
                      "${widget.userModel.firstName} ${widget.userModel.lastName}",
                      style: AppTextStyles.tileText(),
                    ),
                  Text(
                    "@${widget.userModel.username}",
                    style: (widget.userModel.displayName)
                        ? AppTextStyles.tileText().copyWith(
                            color: AppColors.greyText, fontSize: 13.sp)
                        : AppTextStyles.tileText(),
                  ),
                ],
              )
            ],
          ),
          GestureDetector(
              onTap: () {
                if (!widget.isFriendRequestSent) {
                  widget.onSendFriendRequest();
                }
              },
              child: Icon(
                widget.isFriendRequestSent ? Icons.check : Icons.add,
                size: 30.h,
              ))
        ],
      ),
    );
  }
}
