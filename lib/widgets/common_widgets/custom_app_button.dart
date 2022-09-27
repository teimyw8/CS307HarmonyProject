import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmony_app/helpers/colors.dart';

class CustomAppButton extends StatefulWidget {
  final Widget widget;
  final VoidCallback onTap;
  final bool isDisabled;
  final Color buttonColor;
  final Color? borderColor;
  final Color? splashColor;

  const CustomAppButton(
      {Key? key,
        required this.widget,
        required this.onTap,
        required this.buttonColor,
        this.isDisabled = false,
        this.borderColor,
        this.splashColor})
      : super(key: key);

  @override
  _CustomAppButtonState createState() => _CustomAppButtonState();
}

class _CustomAppButtonState extends State<CustomAppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all((widget.borderColor != null)
            ? BorderSide(color: widget.borderColor!)
            : BorderSide(color: Colors.transparent)),
        padding: MaterialStateProperty.all(EdgeInsets.all(10.h)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        )),
        overlayColor: (widget.isDisabled)
            ? MaterialStateProperty.all(
          AppColors.grey20.withOpacity(0),
        )
            : (widget.splashColor != null)
            ? MaterialStateProperty.all(
            widget.splashColor!.withOpacity(0.1))
            : MaterialStateProperty.all(
          AppColors.grey20.withOpacity(0.1),
        ),
        splashFactory: (widget.isDisabled)
            ? NoSplash.splashFactory
            : InkSplash.splashFactory,
        elevation: (widget.isDisabled)
            ? MaterialStateProperty.all(1)
            : MaterialStateProperty.all(1),
        backgroundColor: (widget.isDisabled)
            ? MaterialStateProperty.all(widget.buttonColor.withOpacity(0.6))
            : MaterialStateProperty.all(widget.buttonColor),
      ),
      child: widget.widget,
      onPressed: (widget.isDisabled) ? () => {} : widget.onTap,
    );
  }
}
