import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  final double borderRadius;
  final bool isFullWidth;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,

    this.borderRadius = 100,
    this.isFullWidth = false,
    this.icon,
    this.padding,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: selectedDividerColor,

          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        onPressed: onPressed,
        child:
            icon != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon!,
                    SizedBox(width: 10.w),
                    Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                )
                : Text(
                  text,
                  style:
                      textStyle ??
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
      ),
    );
  }
}
