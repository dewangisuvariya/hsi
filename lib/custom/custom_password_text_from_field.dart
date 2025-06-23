import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

class CustomPasswordField extends StatefulWidget {
  final String hintText;
  final String? iconPath;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Color borderColor;
  final double borderRadius;
  final bool hasBorder;

  const CustomPasswordField({
    Key? key,
    required this.hintText,
    this.iconPath,
    this.controller,
    this.validator,
    this.textCapitalization,
    this.textInputAction,
    this.onChanged,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderRadius = 10,
    this.hasBorder = true,
  }) : super(key: key);

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: subTitleColor),

        borderRadius: BorderRadius.circular(widget.borderRadius.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          textInputAction: textInputAction,
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: subTitleColor,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
            prefixIcon:
                widget.iconPath != null
                    ? Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Image.asset(
                        widget.iconPath!,
                        width: 18.w,
                        height: 18.h,
                      ),
                    )
                    : null,
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20.w,
                  color: const Color(0xFF9E9E9E),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),

            isDense: true,
          ),
          cursorColor: Colors.black,
          cursorWidth: 1,
        ),
      ),
    );
  }
}
