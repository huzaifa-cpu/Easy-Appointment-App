import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  CustomStrings strings = CustomStrings();

  Future<Location> createLocation(var data) async {
    Response response = await post('${strings.apiEndpoint}/location',
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("location body: ${response.body}");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map data = jsonDecode(response.body);
      int locationId = data["id"];
      prefs.setInt("locationId", locationId);
      print("locationId: $locationId");
      Location location = Location.fromJson(data);
      return location;
    } else {
      throw "can't get";
    }
  }

//Update location
  Future<Location> updateLocation(var data, int id) async {
    Response response = await put('${strings.apiEndpoint}/location/$id',
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("location body: ${response.body}");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map data = jsonDecode(response.body);
      Location location = Location.fromJson(data);
      int locationId = data["id"];
      prefs.setInt("locationId", locationId);
      print("locationId: $locationId");
      return location;
    } else {
      throw "can't get";
    }
  }

  Future<Location> getLocationById(int locationId) async {
    Response response = await get('${strings.apiEndpoint}/location/$locationId',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      Location location = Location.fromJson(body);
      print("getLocationById: $location");
      return location;
    } else {
      throw "can't get";
    }
  }

//GET listOfLocationsByPhone
  Future<List<Location>> getListOfLocationsByPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.get("phone");
    print('phone: $phone');
    Response response = await get('${strings.apiEndpoint}/locations/$phone',
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Location> location =
          body.map((dynamic item) => Location.fromJson(item)).toList();
      print("LIST of locations: $location");
      return location;
    } else {
      throw "can't get";
    }
  }
}
