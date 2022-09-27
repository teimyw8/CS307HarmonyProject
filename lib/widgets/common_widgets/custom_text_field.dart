import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/colors.dart';
import 'package:harmony_app/helpers/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final int? maxLines;
  final bool? isPassword;
  final TextStyle? style;
  final TextStyle? hintStyle;
  bool? isTextObscure;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final String? label;
  final TextStyle? labelStyle;
  final bool outlinedBorder;
  final double? contentPadding;

  CustomTextField(
      {Key? key,
        this.controller,
        this.validator,
        this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.inputAction,
        this.inputType,
        this.maxLines = 1,
        this.isTextObscure = false,
        this.isPassword = false,
        this.readOnly = false,
        this.onChanged,
        this.onTap,
        this.style,
        this.cursorColor,
        this.borderColor,
        this.focusedBorderColor,
        this.label,
        this.labelStyle,
        this.outlinedBorder = false,
        this.contentPadding,
        this.hintStyle})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.contentPadding ?? 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.prefixIcon ?? Container(),
          Expanded(
            child: TextFormField(
              minLines: widget.maxLines,
              cursorColor: (widget.cursorColor != null)
                  ? widget.cursorColor
                  : AppColors.grey50,
              keyboardType: widget.inputType,
              textInputAction: widget.inputAction,
              controller: widget.controller,
              validator: widget.validator,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly!,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              style: widget.style,
              obscureText: widget.isTextObscure ?? false,
              decoration: InputDecoration(
                contentPadding: (widget.contentPadding != null)
                    ? EdgeInsets.all(widget.contentPadding!)
                    : InputDecorationTheme().contentPadding,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: (widget.label != null) ? widget.label : "",
                labelStyle: (widget.labelStyle != null)
                    ? widget.labelStyle
                    : TextStyle(),
                hintText: widget.hintText,
                fillColor: Colors.transparent,
                errorStyle: widget.style?.copyWith(
                    color: AppColors.redError, fontSize: 15.sp) ??
                    TextStyle(),
                isDense: true,
                suffixIcon: widget.isPassword!
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Icon(
                        widget.isTextObscure!
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.grey50,
                        size: 35.h,
                      ),
                      // color: AppColors.white,
                      onTap: () {
                        setState(() {
                          widget.isTextObscure = !widget.isTextObscure!;
                        });
                      },
                    ),
                  ],
                )
                    : widget.suffixIcon,
                hintStyle: widget.hintStyle ?? AppTextStyles.hintTextField(),
                enabledBorder: (widget.outlinedBorder)
                    ? OutlineInputBorder(
                  borderSide: BorderSide(
                      color: (widget.borderColor != null)
                          ? widget.borderColor!
                          : AppColors.grey50.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10.r),
                )
                    : UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: (widget.borderColor != null)
                            ? widget.borderColor!
                            : AppColors.grey50.withOpacity(0.5))),
                focusedBorder: (widget.outlinedBorder)
                    ? OutlineInputBorder(
                  borderSide: BorderSide(
                      color: (widget.borderColor != null)
                          ? widget.borderColor!
                          : AppColors.grey50.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10.r),
                )
                    : UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: (widget.focusedBorderColor != null)
                            ? widget.focusedBorderColor!
                            : AppColors.grey50.withOpacity(0.5))),
                errorBorder: (widget.outlinedBorder)
                    ? OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.redError.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10.r),
                )
                    : UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.redError.withOpacity(0.5))),
                focusedErrorBorder: (widget.outlinedBorder)
                    ? OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.redError),
                  borderRadius: BorderRadius.circular(10.r),
                )
                    : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.redError)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
