import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/fcm/FcmPushNotificationRequest.dart';
import 'package:flutter_ea_mobile_app/models/fcm/notification_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  CustomStrings _strings = CustomStrings();
  SessionService sessionService = SessionService();
  Utils utils = Utils();

  Future<void> createNotificationForDB(
      NotificationModel notificationModel) async {
    var data = jsonEncode(notificationModel);
    Response response = await post('${_strings.apiEndpoint}/user-notification',
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(
        "responseStatusCodeOfCreateNotificationForDB: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("responseBodyOfCreateNotificationForDB: ${response.body}");
    } else {
      throw "can't get";
    }
  }

  Future<void> createNotificationForFcm(
      FcmPushNotificationRequest fcmPushNotificationRequest) async {
    var data = jsonEncode(fcmPushNotificationRequest);
    Response response = await post('${_strings.apiEndpoint}/notification/token',
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(
        "responseStatusCodeOfCreateNotificationForFcm: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("responseBodyCreateNotificationForFcm: ${response.body}");
    } else {
      throw "can't get";
    }
  }

  //GET NOTIFICATIONS
  Future<List<NotificationModel>> getNotificationsByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.get("userId");
    Response response = await get(
        '${_strings.apiEndpoint}/user-notifications/$userId',
        headers: {"content-type": "application/json"});
    print(
        "responseStatusCodeOfGetNotificationsByUserId: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print("responseBodyOfGetNotificationsByUserId: ${body}");
      print(body);
      List<NotificationModel> notifications =
          body.map((dynamic item) => NotificationModel.fromJson(item)).toList();
      print("notifications: $notifications");
      return notifications;
    } else {
      throw "Can't get getNotificationsByUserId";
    }
  }

  Future<void> sendNotificationsToAllDevices(
      {User user, String title, String message}) async {
    print("userId: ${user.id}");
    List<dynamic> tokens = await sessionService.getTokens(user.id);

    if (tokens.length != 0) {
      tokens.forEach((token) {
        if (token != null) {
          NotificationModel notificationModel = NotificationModel(
              createdDate: utils.getCurrentDate(),
              title: title,
              subTitle: message,
              route: "",
              deviceToken: token,
              user: user);

          createNotificationForDB(notificationModel);

          FcmPushNotificationRequest fcmPushNotificationRequest =
              FcmPushNotificationRequest(
                  title: title, message: message, token: token);

          createNotificationForFcm(fcmPushNotificationRequest);
        }
      });
    }
  }
}
