import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/set_start_end_slot.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button_small.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class ScheduleCard extends StatefulWidget {
  Schedule schedule;

  ScheduleCard({this.schedule});

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  CustomThemeColors _colors = CustomThemeColors();

  CustomSizes _sizes = CustomSizes();

  CustomToast _toast = CustomToast();

  Map timeMap = {
    60: "1:00 AM",
    120: "2:00 AM",
    180: "3:00 AM",
    240: "4:00 AM",
    300: "5:00 AM",
    360: "6:00 AM",
    420: "7:00 AM",
    480: "8:00 AM",
    540: "9:00 AM",
    600: "10:00 AM",
    660: "11:00 AM",
    720: "12:00 PM",
    780: "1:00 PM",
    840: "2:00 PM",
    900: "3:00 PM",
    960: "4:00 PM",
    1020: "5:00 PM",
    1080: "6:00 PM",
    1140: "7:00 PM",
    1200: "8:00 PM",
    1260: "9:00 PM",
    1320: "10:00 PM",
    1380: "11:00 PM",
    1440: "12:00 AM",
  };

  Map dayMap = {
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN"
  };

  Map minutesMap = {
    10: "10 m",
    20: "20 m",
    30: "30 m",
    40: "40 m",
    50: "50 m",
    60: "60 m",
  };

  @override
  Container build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.0, bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "${dayMap[widget.schedule.day]}",
              style: TextStyle(
                color: _colors.grey,
                fontSize: _sizes.xsTextSize,
                fontFamily: "CenturyGothic",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomButtonSmall(
                color: _colors.green,
                name: "${timeMap[widget.schedule.startTime]}",
                pressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return SetStartEndSlot(
                          startTime: true,
                          endTime: false,
                          schedule: widget.schedule,
                          name: "Select Start Time",
                        );
                      });
                }),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 2,
            child: CustomButtonSmall(
                color: _colors.green,
                name: "${timeMap[widget.schedule.endTime]}",
                pressed: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return SetStartEndSlot(
                          startTime: false,
                          endTime: true,
                          schedule: widget.schedule,
                          name: "Select End Time",
                        );
                      });
                }),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 2,
            child: CustomButtonSmall(
              color: _colors.green,
              name: "${minutesMap[widget.schedule.defaultTimeSlotLimit]}",
              pressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return SetStartEndSlot(
                        startTime: false,
                        endTime: false,
                        schedule: widget.schedule,
                        name: "Select Time Slot",
                      );
                    });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Consumer<SchedulesProvider>(
              builder: (context, schedulesProvider, child) => Checkbox(
                value: widget.schedule.off,
                checkColor: Colors.white,
                activeColor: _colors.green,
                onChanged: (value) {
                  if (widget.schedule.off == false) {
                    schedulesProvider.updateHoliday(value, widget.schedule.day);
                    _toast.showToast("Holiday");
                  } else {
                    schedulesProvider.updateHoliday(value, widget.schedule.day);
                    _toast.showToast("Working Day");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
