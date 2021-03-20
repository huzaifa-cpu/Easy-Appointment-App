import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class SetStartEndSlot extends StatelessWidget {
  bool startTime;
  bool endTime;
  Schedule schedule;
  String name;

  SetStartEndSlot({this.startTime, this.endTime, this.schedule, this.name});

  CustomThemeColors _colors = CustomThemeColors();
  CustomToast _toast = CustomToast();

  List<String> minutesList = [
    "10 m",
    "20 m",
    "30 m",
  ];

  List<String> timeList = [
    "1:00 AM",
    "2:00 AM",
    "3:00 AM",
    "4:00 AM",
    "5:00 AM",
    "6:00 AM",
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
    "10:00 PM",
    "11:00 PM",
    "12:00 AM",
  ];

  Map timeMap = {
    "1:00 AM": 60,
    "2:00 AM": 120,
    "3:00 AM": 180,
    "4:00 AM": 240,
    "5:00 AM": 300,
    "6:00 AM": 360,
    "7:00 AM": 420,
    "8:00 AM": 480,
    "9:00 AM": 540,
    "10:00 AM": 600,
    "11:00 AM": 660,
    "12:00 PM": 720,
    "1:00 PM": 780,
    "2:00 PM": 840,
    "3:00 PM": 900,
    "4:00 PM": 960,
    "5:00 PM": 1020,
    "6:00 PM": 1080,
    "7:00 PM": 1140,
    "8:00 PM": 1200,
    "9:00 PM": 1260,
    "10:00 PM": 1320,
    "11:00 PM": 1380,
    "12:00 AM": 1440,
  };

  Map dayMap = {
    "MON": 0,
    "TUE": 1,
    "WED": 2,
    "THU": 3,
    "FRI": 4,
    "SAT": 5,
    "SUN": 6
  };

  Map minutesMap = {
    "10 m": 10,
    "20 m": 20,
    "30 m": 30,
    "40 m": 40,
    "50 m": 50,
    "60 m": 60,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
          color: _colors.greyTheme,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 50,
              color: _colors.grey,
            ),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 17, color: _colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<SchedulesProvider>(
            builder: (context, schedulesProvider, child) => Expanded(
              child: startTime
                  ? ListView.builder(
                      itemCount: (timeList.length) - 1, // removing 12:00 AM
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(7.0, 15.0, 7.0, 15.0),
                          child: CustomButtonSmall(
                            name: timeList[index],
                            color: _colors.green,
                            pressed: () {
                              int startTime = timeMap[timeList[index]];
                              schedulesProvider.updateStartTime(
                                  startTime, schedule.day);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    )
                  : endTime
                      ? (ListView.builder(
                          itemCount: timeList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(7.0, 15.0, 7.0, 15.0),
                              child: CustomButtonSmall(
                                name: timeList[index],
                                color: _colors.green,
                                pressed: () {
                                  int endTime = timeMap[timeList[index]];
                                  bool isUpdate = schedulesProvider
                                      .updateEndTime(endTime, schedule.day);
                                  if (isUpdate == false) {
                                    _toast.showDangerToast(
                                        "end Time should be greater than start Time");
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ))
                      : (Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 0.0),
                              child: CustomButtonSmall(
                                name: minutesList[0],
                                color: _colors.green,
                                pressed: () {
                                  int slot = minutesMap[minutesList[0]];
                                  schedulesProvider.updateSlot(
                                      slot, schedule.day);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 0.0),
                              child: CustomButtonSmall(
                                name: minutesList[1],
                                color: _colors.green,
                                pressed: () {
                                  int slot = minutesMap[minutesList[1]];
                                  schedulesProvider.updateSlot(
                                      slot, schedule.day);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 0.0),
                              child: CustomButtonSmall(
                                name: minutesList[2],
                                color: _colors.green,
                                pressed: () {
                                  int slot = minutesMap[minutesList[2]];
                                  schedulesProvider.updateSlot(
                                      slot, schedule.day);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        )),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
