// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// display static data
class StaoanScreen extends StatefulWidget {
  const StaoanScreen({super.key});

  @override
  State<StaoanScreen> createState() => _StaoanScreenState();
}

class _StaoanScreenState extends State<StaoanScreen> {
  // static data list
  final List<Map<String, String>> statsList = [
    {
      "Sæti": "1",
      "Félag": "FH",
      "Leikir": "4",
      "S": "3",
      "J": "0",
      "T": "1",
      "Skoruð": "112",
      "Fengin": "118",
      "Netto": "4",
      "Stig": "6",
      "image": "assets/images/FH.png",
    },
    {
      "Sæti": "2",
      "Félag": "Haukar",
      "Leikir": "4",
      "S": "3",
      "J": "0",
      "T": "1",
      "Skoruð": "127",
      "Fengin": "112",
      "Netto": "15",
      "Stig": "6",
      "image": "assets/images/Haukar.png",
    },
    {
      "Sæti": "3",
      "Félag": "Fram",
      "Leikir": "3",
      "S": "2",
      "J": "0",
      "T": "1",
      "Skoruð": "93",
      "Fengin": "80",
      "Netto": "13",
      "Stig": "4",
      "image": "assets/images/Fram.png",
    },
    {
      "Sæti": "4",
      "Félag": "Afturelding",
      "Leikir": "3",
      "S": "2",
      "J": "0",
      "T": "1",
      "Skoruð": "93",
      "Fengin": "80",
      "Netto": "13",
      "Stig": "4",
      "image": "assets/images/Afturelding.png",
    },
    {
      "Sæti": "5",
      "Félag": "Stjarnan",
      "Leikir": "3",
      "S": "2",
      "J": "0",
      "T": "1",
      "Skoruð": "88",
      "Fengin": "85",
      "Netto": "3",
      "Stig": "4",
      "image": "assets/images/Stjarnan.png",
    },
    {
      "Sæti": "6",
      "Félag": "Grótta",
      "Leikir": "3",
      "S": "2",
      "J": "0",
      "T": "1",
      "Skoruð": "93",
      "Fengin": "89",
      "Netto": "4",
      "Stig": "4",
      "image": "assets/images/Grótta.png",
    },
    {
      "Sæti": "7",
      "Félag": "Valur",
      "Leikir": "4",
      "S": "1",
      "J": "1",
      "T": "2",
      "Skoruð": "125",
      "Fengin": "120",
      "Netto": "5",
      "Stig": "3",
      "image": "assets/images/Valur.png",
    },
    {
      "Sæti": "8",
      "Félag": "ÍBV",
      "Leikir": "3",
      "S": "1",
      "J": "1",
      "T": "1",
      "Skoruð": "94",
      "Fengin": "89",
      "Netto": "4",
      "Stig": "4",
      "image": "assets/images/ÍBV.png",
    },
    {
      "Sæti": "9",
      "Félag": "ÍR",
      "Leikir": "3",
      "S": "1",
      "J": "0",
      "T": "2",
      "Skoruð": "95",
      "Fengin": "96",
      "Netto": "-1",
      "Stig": "2",
      "image": "assets/images/ÍR.png",
    },
    {
      "Sæti": "10",
      "Félag": "Fjölnir",
      "Leikir": "3",
      "S": "1",
      "J": "0",
      "T": "2",
      "Skoruð": "82",
      "Fengin": "106",
      "Netto": "-24",
      "Stig": "2",
      "image": "assets/images/Fjölnir.png",
    },
    {
      "Sæti": "11",
      "Félag": "HK",
      "Leikir": "3",
      "S": "1",
      "J": "0",
      "T": "2",
      "Skoruð": "90",
      "Fengin": "89",
      "Netto": "1",
      "Stig": "2",
      "image": "assets/images/HK.png",
    },
    {
      "Sæti": "12",
      "Félag": "KA",
      "Leikir": "4",
      "S": "0",
      "J": "0",
      "T": "4",
      "Skoruð": "100",
      "Fengin": "134",
      "Netto": "-34",
      "Stig": "0",
      "image": "assets/images/KA.png",
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
            padding: const EdgeInsets.only(left: 12, right: 12),
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
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 7, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Sæti",
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
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Félag",
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
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Leikir",
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
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "S",
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
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "J",
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
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "T",
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
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Skoruð",
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
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Fengin",
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
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Netto",
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
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Stig",
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
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 7, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Sæti"]!,
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
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Container(
                            height: isWideScreen ? 26.h : 20.h,
                            width: isWideScreen ? 26.w : 20.w,
                            child: Image.asset(item["image"]!),
                          ),
                        ),
                        if (isWideScreen) SizedBox(height: 3.h),

                        Text(
                          item["Félag"]!,
                          style: TextStyle(
                            fontSize: isWideScreen ? 14.sp : 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Leikir"]!,
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
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["S"]!,
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
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["J"]!,
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
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["T"]!,
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
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Skoruð"]!,
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
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Fengin"]!,
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
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Netto"]!,
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
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      item["Stig"]!,
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
