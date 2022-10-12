import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:harmony_app/helpers/colors.dart';

class CustomAppLoader extends StatelessWidget {
  const CustomAppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: AppColors.green,
      size: 50.h,
      duration: Duration(seconds: 1),
    );
  }

  static void showCustomAppLoader() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return const CustomAppLoader();
      },
    );
  }
}
