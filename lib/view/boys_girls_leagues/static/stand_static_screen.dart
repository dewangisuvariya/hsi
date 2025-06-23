// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// display static data
class StandStaticScreen extends StatefulWidget {
  const StandStaticScreen({super.key});

  @override
  State<StandStaticScreen> createState() => _StandStaticScreenState();
}

class _StandStaticScreenState extends State<StandStaticScreen> {
  // static data list
  final List<Map<String, String>> statsList = [
    {
      "Sæti": "1",
      "Félag": "ÍBV",
      "Leikir": "3",
      "S": "3",
      "J": "0",
      "T": "0",
      "Skoruð": "120",
      "Fengin": "106",
      "Netto": "14",
      "Stig": "6",
      "image": "assets/images/ÍBV.png",
    },
    {
      "Sæti": "2",
      "Félag": "Afturelding",
      "Leikir": "1",
      "S": "1",
      "J": "0",
      "T": "0",
      "Skoruð": "34",
      "Fengin": "32",
      "Netto": "2",
      "Stig": "2",
      "image": "assets/images/Afturelding.png",
    },
    {
      "Sæti": "3",
      "Félag": "FH",
      "Leikir": "2",
      "S": "1",
      "J": "0",
      "T": "1",
      "Skoruð": "64",
      "Fengin": "63",
      "Netto": "1",
      "Stig": "2",
      "image": "assets/images/FH.png",
    },
    {
      "Sæti": "4",
      "Félag": "Valur",
      "Leikir": "1",
      "S": "0",
      "J": "0",
      "T": "1",
      "Skoruð": "32",
      "Fengin": "34",
      "Netto": "-2",
      "Stig": "0",
      "image": "assets/images/Valur.png",
    },
    {
      "Sæti": "5",
      "Félag": "KA",
      "Leikir": "1",
      "S": "0",
      "J": "0",
      "T": "1",
      "Skoruð": "31",
      "Fengin": "34",
      "Netto": "-3",
      "Stig": "0",
      "image": "assets/images/KA.png",
    },
    {
      "Sæti": "6",
      "Félag": "Haukar",
      "Leikir": "1",
      "S": "0",
      "J": "0",
      "T": "1",
      "Skoruð": "41",
      "Fengin": "47",
      "Netto": "-6",
      "Stig": "0",
      "image": "assets/images/Haukar.png",
    },
    {
      "Sæti": "7",
      "Félag": "HK",
      "Leikir": "1",
      "S": "0",
      "J": "0",
      "T": "1",
      "Skoruð": "35",
      "Fengin": "41",
      "Netto": "-6",
      "Stig": "0",
      "image": "assets/images/HK.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: statsList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: appBarColor,
                    border: Border(
                      bottom: BorderSide(
                        color: backgroundColorContainer,
                        width: 4,
                      ),
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                            style: menWoemTubScreenTitleTextStyle,
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
                height: 56.h,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                                height: 20.h,
                                width: 20.w,
                                child: Image.asset(item["image"]!),
                              ),
                            ),

                            Text(
                              item["Félag"]!,
                              style: TextStyle(
                                fontSize: 10.sp,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
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
                          style: menWoemTubScreenSubtitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
