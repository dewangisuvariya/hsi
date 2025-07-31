import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// display static data
class NextGameStaticScreen extends StatefulWidget {
  const NextGameStaticScreen({super.key});

  @override
  State<NextGameStaticScreen> createState() => _NextGameStaticScreenState();
}

class _NextGameStaticScreenState extends State<NextGameStaticScreen> {
  // static data list
  final List<Map<String, String>> statsList = [
    {
      "day": "fös. 06. sep. 24 ",
      "time": "17:30",
      "value": "FH - ÍBV",
      "result": "30-32",
    },
    {
      "day": "sun. 08. sep. 24",
      "time": "13:00",
      "value": "ÍBV - HK",
      "result": "41-35",
    },
    {
      "day": "lau. 14. sep. 24",
      "time": "15:00",
      "value": "KA - FH",
      "result": "31-34",
    },
    {
      "day": "sun. 15. sep. 24",
      "time": "13:00",
      "value": "ÍBV - Haukar",
      "result": "47-41",
    },
    {
      "day": "þri. 17. sep. 24",
      "time": "18:00",
      "value": "Afturelding - Valur",
      "result": "34-32",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: statsList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: isWideScreen ? 70.h : 56.h,
              decoration: BoxDecoration(
                color: appBarColor,
                border: Border(
                  bottom: BorderSide(color: backgroundColorContainer, width: 4),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: isWideScreen ? 4 : 4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 7, right: 4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Dagur",
                        style:
                            isWideScreen
                                ? menWoemTubScreenTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                )
                                : menWoemTubScreenTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isWideScreen ? 5 : 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Tími",
                        style:
                            isWideScreen
                                ? menWoemTubScreenTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                )
                                : menWoemTubScreenTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isWideScreen ? 5 : 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Leikur",
                        style:
                            isWideScreen
                                ? menWoemTubScreenTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                )
                                : menWoemTubScreenTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isWideScreen ? 3 : 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Úrslit",
                        style:
                            isWideScreen
                                ? menWoemTubScreenTitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                )
                                : menWoemTubScreenTitleTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final item = statsList[index - 1];
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: isWideScreen ? 70.h : 56.h,
            color: index.isEven ? selectLeagueTileColor : Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: isWideScreen ? 4 : 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 7, right: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item["day"]!,
                      style:
                          isWideScreen
                              ? menWoemTubScreenSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              )
                              : menWoemTubScreenSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isWideScreen ? 5 : 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["time"]!,
                      style:
                          isWideScreen
                              ? menWoemTubScreenSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              )
                              : menWoemTubScreenSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isWideScreen ? 5 : 5,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item["value"]!,
                      style:
                          isWideScreen
                              ? menWoemTubScreenSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              )
                              : menWoemTubScreenSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isWideScreen ? 3 : 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["result"]!,
                      style:
                          isWideScreen
                              ? menWoemTubScreenSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              )
                              : menWoemTubScreenSubtitleTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
