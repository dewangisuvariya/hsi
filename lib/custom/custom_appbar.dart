import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imagePath;
  const CustomAppBar({Key? key, required this.title, required this.imagePath})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Container(
      height: isLargeScreen ? 140.h : 104.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius:
            isLargeScreen
                ? BorderRadius.only(
                  bottomRight: Radius.circular(26),
                  bottomLeft: Radius.circular(26),
                )
                : BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),

                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: isLargeScreen ? 95.w : 52.w,
                        height: isLargeScreen ? 68.h : 36.h,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return errorImageContainer();
                          },
                        ),
                      ),
                      SizedBox(width: isLargeScreen ? 30.w : 5.w),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: appBarTextStyle.copyWith(
                          fontSize: isLargeScreen ? 27.sp : 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
