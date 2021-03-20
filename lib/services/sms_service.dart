import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';

class SmsService {
  CustomStrings utils = CustomStrings();
  Future sendSMS(String phone, String message) async {
    Response response = await get(
        "https://sendpk.com/api/sms.php?username=${utils.usernameForSms}&password=${utils.passwordForSms}&sender=${utils.senderForSms}&mobile=$phone&message=$message",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("SMS sent");
    } else {
      throw "Exception";
    }
  }
}
