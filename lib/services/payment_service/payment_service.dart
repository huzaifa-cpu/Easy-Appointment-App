import 'dart:convert';

import 'package:flutter_ea_mobile_app/models/payment_model/payment_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';

class PaymentService {
  CustomStrings strings = CustomStrings();

  Future createPayment(Payment payment) async {
    var paymentJson = json.encode(payment);
    Response response = await post('${strings.apiEndpoint}/payment',
        body: paymentJson,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data;
    } else {
      throw "can't create payment";
    }
  }
}
