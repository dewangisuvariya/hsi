import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';

class CustomAppBarSubImageAsset extends StatelessWidget {
  final String title;
  final String imagePath;

  const CustomAppBarSubImageAsset({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Container(
      height: isLargeScreen ? 140.h : 104.h,
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
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  //   color: Colors.amber,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Image.asset(
                      backArrow,
                      height: isLargeScreen ? 48.h : 34.h,
                      width: 80.w,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  //  color: Colors.green,
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
                      SizedBox(width: 5.w),
                      Flexible(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: appBarTextStyle.copyWith(
                            fontSize: isLargeScreen ? 27.sp : 20.sp,
                          ),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }
}
