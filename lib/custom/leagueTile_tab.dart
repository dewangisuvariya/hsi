import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';

class LeagueTileTab extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final bool isSelected;

  const LeagueTileTab({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.9.w,
      height: 70.h,
      // margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: isSelected ? selectLeagueTileColor : unselectLeagueTileColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? selectLeagueTileColor
                        : unselectLeagueTileColor,
              ),
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        width: 48.w,
                        height: 35.h,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return errorImageContainer();
                        },
                      )
                      : errorImageContainer(),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Color(0XFF292929),
                  fontSize: 16.79.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
                overflow: TextOverflow.visible,
                maxLines: 2,
                softWrap: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor:
                    isSelected
                        ? selectedCircleAvatarcolor
                        : unselectedCircleAvatarcolor,
                radius: 20.r,
                child: Center(
                  child: Image.asset(
                    isSelected ? selectedCircleAvater : unselectedCircleAvater,
                    fit: BoxFit.contain,
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

Widget buildDividerContainer({
  required Widget child,
  required bool isSelected,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: isSelected ? selectedDividerColor : unselectedDividerColor,
          width: isSelected ? 3 : 1,
        ),
      ),
    ),
    child: child,
  );
}
