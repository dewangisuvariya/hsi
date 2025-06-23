import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? iconPath;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;

  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool hasBorder;
  final Color borderColor;
  final double borderRadius;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.iconPath,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.hasBorder = true,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: subTitleColor),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,

        //  textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: subTitleColor,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
          ),
          prefixIcon:
              iconPath != null
                  ? Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Image.asset(iconPath!, width: 25.w, height: 17.58.h),
                  )
                  : null,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        cursorColor: Colors.black,
        cursorWidth: 1,
      ),
    );
  }
}
