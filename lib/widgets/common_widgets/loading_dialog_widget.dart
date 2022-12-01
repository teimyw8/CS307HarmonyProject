import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/widgets/common_widgets/custom_app_loader.dart';

class LoaderDialog {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          key: key,
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          child: Container(
            color: Colors.transparent,
            height: 100.h,
            width: 100.h,
            child: const Center(
                child: CustomAppLoader()),
          ),
          // },
          // )
        ));
  }
}