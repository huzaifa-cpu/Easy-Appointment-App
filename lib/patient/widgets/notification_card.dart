import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/models/fcm/notification_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';

class NotificationCard extends StatelessWidget {
  NotificationModel notificationModel;

  NotificationCard({this.notificationModel});

  final CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${notificationModel.title}',
                          style: TextStyle(
                              fontFamily: "CenturyGothic",
                              color: _colors.green,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          '${notificationModel.subTitle}',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "CenturyGothic",
                              color: _colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '${DateTime.parse(notificationModel.createdDate).day}/${DateTime.parse(notificationModel.createdDate).month}/${DateTime.parse(notificationModel.createdDate).year}',
                    style: TextStyle(
                        fontSize: 10.0,
                        fontFamily: "CenturyGothic",
                        color: _colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            child: Divider(
              color: _colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
