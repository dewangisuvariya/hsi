import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';

// display static data
class UrslitScreen extends StatefulWidget {
  const UrslitScreen({super.key});

  @override
  State<UrslitScreen> createState() => _UrslitScreenState();
}

class _UrslitScreenState extends State<UrslitScreen> {
  // static data list
  final List<Map<String, String>> statsList = [
    {
      "day": "mið. 04. sep. 24 ",
      "time": "18:30",
      "value": "Valur - ÍBV",
      "result": "31-31",
    },
    {
      "day": "fim. 05. sep. 24",
      "time": "19:30",
      "value": "FH - Fram",
      "result": "27-23",
    },
    {
      "day": "fim. 05. sep. 24",
      "time": "19:30",
      "value": "Stjarnan - HK",
      "result": "29-27",
    },
    {
      "day": "fim. 05. sep. 24",
      "time": "20:15",
      "value": "Haukar - Afturelding",
      "result": "27-26",
    },
    {
      "day": "fös. 06. sep. 24",
      "time": "19:00",
      "value": "Fjölnir - ÍR",
      "result": "26-36",
    },
    {
      "day": "lau. 07. sep. 24",
      "time": "16:15",
      "value": "Grótta - KA",
      "result": "29-25",
    },
    {
      "day": "fim. 12. sep. 24",
      "time": "19:00",
      "value": "KA - Haukar",
      "result": "26-34",
    },
    {
      "day": "fim. 12. sep. 24",
      "time": "19:30",
      "value": "HK - FH",
      "result": "36-32",
    },
    {
      "day": "fim. 12. sep. 24",
      "time": "19:30",
      "value": "ÍR - Grótta",
      "result": "29-33",
    },
    {
      "day": "fös. 13. sep. 24",
      "time": "19:30",
      "value": "Valur - Afturelding",
      "result": "31-34",
    },
    {
      "day": "fös. 13. sep. 24",
      "time": "19:45",
      "value": "ÍBV - Stjarnan",
      "result": "33-31",
    },
    {
      "day": "lau. 14. sep. 24",
      "time": "14:00",
      "value": "Fram - Fjölnir",
      "result": "43-28",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "18:00",
      "value": "Haukar - ÍR",
      "result": "37-30",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "18:00",
      "value": "Haukar - ÍR",
      "result": "37-30",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "18:30",
      "value": "FH - ÍBV",
      "result": "33-30",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "19:30",
      "value": "Stjarnan - Valur",
      "result": "28-25",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "20:15",
      "value": "Grótta - Fram",
      "result": "31-35",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "18:30",
      "value": "FH - ÍBV",
      "result": "–",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "19:30",
      "value": "Stjarnan - Valur",
      "result": "–",
    },
    {
      "day": "fim. 19. sep. 24",
      "time": "20:15",
      "value": "Grótta - Fram",
      "result": "–",
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
