import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/models/fcm/notification_model.dart';
import 'package:flutter_ea_mobile_app/patient/widgets/notification_card.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  CustomThemeColors _colors = CustomThemeColors();
  NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colors.greyTheme,
        appBar: CustomAppBar(
          title: "Notifications",
          notificationButton: false,
          notificationButtonPressed: () {},
          backButtonPressed: () {},
          logoutButton: false,
        ),
        body: FutureBuilder(
            future: notificationService.getNotificationsByUserId(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<NotificationModel> notifications = snapshot.data;
                if (notifications.length != 0) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                return NotificationCard(
                                  notificationModel: notifications[index],
                                );
                              }),
                        )
                      ],
                    ),
                  );
                }
                return Center(
                    child: Text(
                  "No Notifications yet",
                  style: TextStyle(
                      color: _colors.grey, fontFamily: "CenturyGothic"),
                ));
              }
              return CustomLoading();
            }));
  }
}
