import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  CustomStrings strings = CustomStrings();

  //UPDATE SCHEDULES
  Future<List<Schedule>> updateSchedule(var schedules, int locationId) async {
    Response response = await put(
        '${strings.apiEndpoint}/schedules/$locationId',
        body: schedules,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("schedules body: ${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      List<Schedule> schedulesFromApi =
          data.map((dynamic item) => Schedule.fromJson(item)).toList();
      return schedulesFromApi;
    } else {
      throw "network error";
    }
  }

  //Create SCHEDULES
  Future<List<Schedule>> createSchedule(var schedules) async {
    Response response = await post('${strings.apiEndpoint}/schedules',
        body: schedules,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("schedules body: ${response.body}");
      List<dynamic> data = jsonDecode(response.body);
      List<Schedule> schedulesFromApi =
          data.map((dynamic item) => Schedule.fromJson(item)).toList();
      return schedulesFromApi;
    } else {
      throw "network error";
    }
  }

  //GET SCHEDULES
  Future<List<Schedule>> getSchedules(int locationId) async {
    Response response = await get(
        '${strings.apiEndpoint}/schedules/$locationId',
        headers: {"content-type": "application/json"});
    print("getSchedulesResponseStatusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<Schedule> schedules = [];
      if (response.body != null) {
        List<dynamic> body = jsonDecode(response.body);
        schedules =
            body.map((dynamic item) => Schedule.fromJson(item)).toList();
        print("getSchedulesFromApi: $schedules");
      } else {
        throw "Can't update schedules";
      }
      return schedules;
    } else {
      throw "Can't get schedules from api";
    }
  }

  Future<List<Schedule>> getListOfSchedulesByPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.get("phone");
    print('phone: $phone');
    Response response = await get(
        '${strings.apiEndpoint}/schedules/doctor/user/$phone',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Schedule> schedules =
          body.map((dynamic item) => Schedule.fromJson(item)).toList();
      print("LIST of schedules: $schedules");
      return schedules;
    } else {
      throw "can't get";
    }
  }
}
