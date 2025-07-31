import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';

// Display details of the slide menu data
class SlideMenu extends StatefulWidget {
  const SlideMenu({super.key});

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFFFFF),
      shadowColor: const Color(0xFF000000).withOpacity(0.25),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Úrslit í beinni", style: coachesNameTextStyle),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 1.6, color: Color(0xFFEAEAEA)),

                  // Meistaraflokkar section
                  _buildSectionHeader('Meistaraflokkar'),
                  _buildResultItem(
                    '21 - 23',
                    '3 flokkar karla A: RÖRÍL Loto 1',
                    "(20’)",
                    grotta,
                    ibv,
                  ),
                  _buildResultItem(
                    '35 - 26',
                    '3 flokkar kvenna B: RÖRÍL Loto 1',
                    "(40’)",
                    haukar,
                    jr,
                  ),
                  _buildResultItem(
                    '29 - 25',
                    '4 flokkar karla A: RÖRÍL Loto 1',
                    "(50’)",
                    grotta,
                    ka,
                  ),
                  _buildResultItem(
                    '36 - 26',
                    '4 flokkar karla B: RÖRÍL Loto 1',
                    "(50’)",
                    haukar,
                    jr,
                  ),

                  const SizedBox(height: 16),

                  // Yngri flokkar section
                  _buildSectionHeader('Yngri flokkar'),
                  _buildResultItem(
                    '29 - 25',
                    '4 flokkar kvenna A: RÖRÍL Loto 1',
                    "(20’)",
                    grotta,
                    ka,
                  ),
                  _buildResultItem(
                    '33 - 22',
                    '3 flokkar karla B: RÖRÍL Loto 1',
                    "(40’)",
                    fram,
                    s,
                  ),
                  _buildResultItem(
                    '206 × 73.0',
                    '4 flokkar karla C: RÖRÍL Loto 1',
                    "(50’)",
                    haukar,
                    umf,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget for displaying the title
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
      child: Text(
        title,
        style: coachesNameTextStyle.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }

  // Custom widget that displays a styled Container.
  Widget _buildResultItem(
    String score,
    String description,
    String title,
    String imagePathOne,
    String imagePathTwo,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFF005496)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePathOne, width: 35.w, height: 30.h),
                  SizedBox(width: 16.w),
                  Column(
                    children: [
                      Text(
                        score,
                        style: coachesNameTextStyle.copyWith(fontSize: 14.sp),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF005496),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          title,
                          style: coachesNameTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Image.asset(imagePathTwo, width: 35.w, height: 30.h),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: coachesNameTextStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
