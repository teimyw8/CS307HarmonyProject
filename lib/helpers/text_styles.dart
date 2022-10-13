import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/colors.dart';

class AppTextStyles {
  static TextStyle largeTitle() {
    return TextStyle(
        color: AppColors.green,
        fontWeight: FontWeight.w500,
        fontFamily: 'Pacifico',
        fontSize: 64.sp);
  }

  static TextStyle hintTextField() {
    return TextStyle(
        color: AppColors.grey50,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        fontSize: 18.sp);
  }

  static TextStyle subNote() {
    return TextStyle(
        color: AppColors.grey70,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        fontSize: 16.sp);
  }

  static TextStyle footNote() {
    return TextStyle(
        color: AppColors.grey70,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        fontSize: 18.sp);
  }

  static TextStyle appBar() {
    return TextStyle(
        color: AppColors.green,
        fontWeight: FontWeight.w500,
        fontFamily: 'Pacifico',
        fontSize: 26.sp);
  }

  static TextStyle textField() {
    return TextStyle(
        color: AppColors.grey70,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        fontSize: 18.sp);
  }

  static TextStyle button() {
    return TextStyle(color: AppColors.white, fontWeight: FontWeight.w800, fontFamily: 'Inter', fontSize: 15.sp);
  }

  static TextStyle headline() {
    return TextStyle(color: AppColors.black, fontWeight: FontWeight.w600, fontFamily: 'Inter', fontSize: 17.sp);
  }
}
