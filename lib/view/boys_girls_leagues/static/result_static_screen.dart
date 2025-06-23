import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// display static data
class ResultStaticScreen extends StatefulWidget {
  const ResultStaticScreen({super.key});

  @override
  State<ResultStaticScreen> createState() => _ResultStaticScreenState();
}

class _ResultStaticScreenState extends State<ResultStaticScreen> {
  // static data list
  final List<Map<String, String>> statsList = [
    {
      "day": "lau. 21. sep. 24 ",
      "time": "10:00",
      "value": "KA - ÍBV",
      "result": "-",
    },
    {
      "day": "sun. 22. sep. 24",
      "time": "13:15",
      "value": "HK - KA",
      "result": "-",
    },
    {
      "day": "sun. 22. sep. 24",
      "time": "13:15",
      "value": "HK - KA",
      "result": "-",
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
                padding: const EdgeInsets.only(left: 16, right: 16),
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
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.only(left: 7, right: 4),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Dagur",
                            style: partnerClubCoachTitleTextStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 4, right: 4),
                          alignment: Alignment.center,
                          child: Text(
                            "Tími",
                            style: partnerClubCoachTitleTextStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.only(left: 4, right: 4),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Leikur",
                            style: partnerClubCoachTitleTextStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 4, right: 4),
                          alignment: Alignment.center,
                          child: Text(
                            "Úrslit",
                            style: partnerClubCoachTitleTextStyle,
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
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 7, right: 4),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item["day"]!,
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
                          item["time"]!,
                          style: menWoemTubScreenSubtitleTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.only(left: 4, right: 4),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item["value"]!,
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
                          item["result"]!,
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
