import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/session_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';

class SessionService {
  CustomStrings strings = CustomStrings();

  Future<void> updateSession(Session session, int sessionId) async {
    var sessionJson = jsonEncode(session);
    Response response = await put('${strings.apiEndpoint}/session/$sessionId',
        body: sessionJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("responseStatusCodeOfUpdateSession: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("bodyOfUpdateSession: ${response.body}");
    } else {
      throw "can't update session";
    }
  }

  Future<void> deleteSession(int sessionId) async {
    Response response = await get('${strings.apiEndpoint}/logout/$sessionId',
        headers: {"content-type": "application/json"});
    print("responseStatusCodeOfDeleteSession: ${response.statusCode}");
    if (response.statusCode != 200) {
      throw "can't delete session";
    }
  }

  Future<List<dynamic>> getTokens(int userId) async {
    Response response = await get(
        '${strings.apiEndpoint}/device-tokens-by-user-id/$userId',
        headers: {"content-type": "application/json"});
    print("getTokens: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<dynamic> tokens = body;
      print("tokens: $tokens");
      return tokens;
    } else {
      throw "Can't get tokens";
    }
  }
}