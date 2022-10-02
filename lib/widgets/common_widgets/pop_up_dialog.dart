import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';
import 'custom_app_button.dart';

class PopUpDialog {
  static void showAcknowledgePopUpDialog(
      {required String title,
        required String message,
        required VoidCallback onOkClick,
        bool isBarrierDismissible = true}) {
    showDialog(
        barrierDismissible: isBarrierDismissible,
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.only(
              left: 0.h,
              right: 0.h,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              width: 275.w,
              child: SingleChildScrollView(
                child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.headline(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            message,
                            style: AppTextStyles.footNote()
                                .copyWith(color: AppColors.grey80),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: CustomAppButton(
                            buttonColor: AppColors.green,
                            onTap: () {
                              onOkClick();
                            },
                            widget: Text(
                              "Ok",
                              style: AppTextStyles.button(),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  static void showConfirmationPopUpDialog(
      {required String title,
        required String message,
        required String confirmLabel,
        required VoidCallback onConfirmClick}) {
    showDialog(
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.only(
              left: 0.h,
              right: 0.h,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: 275.w,
              child: SingleChildScrollView(
                child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 20.h, horizontal: 22.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.headline(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            message,
                            style: AppTextStyles.footNote()
                                .copyWith(color: AppColors.grey80),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 110.w,
                              height: 44.h,
                              child: CustomAppButton(
                                buttonColor: AppColors.white,
                                borderColor: AppColors.green,
                                onTap: () {
                                  Get.close(1);
                                },
                                widget: Text(
                                  "Cancel",
                                  style: AppTextStyles.button()
                                      .copyWith(color: AppColors.green),
                                ),
                              ),
                            ),
                            Container(
                              width: 110.w,
                              height: 44.h,
                              child: CustomAppButton(
                                buttonColor: AppColors.redError,
                                onTap: () {
                                  onConfirmClick();
                                  Get.close(1);
                                },
                                widget: Text(
                                  confirmLabel,
                                  style: AppTextStyles.button(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  static void showWarningPopUpDialog(
      {required String title,
        required String message,
        required String confirmLabel,
        required VoidCallback onCloseClick,
        required VoidCallback onConfirmClick}) {
    showDialog(
        barrierDismissible: true,
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.only(
              left: 0.h,
              right: 0.h,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: 275.w,
              child: SingleChildScrollView(
                child: Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 20.h, horizontal: 22.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.headline(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            message,
                            style: AppTextStyles.footNote()
                                .copyWith(color: AppColors.grey80),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 110.w,
                              height: 44.h,
                              child: CustomAppButton(
                                buttonColor: AppColors.white,
                                borderColor: AppColors.green,
                                onTap: () {
                                  onCloseClick();
                                },
                                widget: Text(
                                  "Submit",
                                  style: AppTextStyles.button()
                                      .copyWith(color: AppColors.green),
                                ),
                              ),
                            ),
                            Container(
                              width: 110.w,
                              height: 44.h,
                              child: CustomAppButton(
                                buttonColor: AppColors.green,
                                onTap: () {
                                  Get.close(1);
                                  onConfirmClick();
                                },
                                widget: Text(
                                  confirmLabel,
                                  style: AppTextStyles.button(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }
}