import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_ea_mobile_app/models/payment_model/jazz_cash_credit.dart';
import 'package:flutter_ea_mobile_app/models/payment_model/jazz_cash_mobile.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class JazzCashService {
  //UTILS
  final CustomStrings constants = CustomStrings();
  // EXPIRY DATE TIME
  String createExpiryDateByAddingAnHour(String date) {
    String hour = date.substring(8, 10);
    String addedHour = (int.parse(hour) + 1).toString();
    String finalExpiryDate =
        "${date.substring(0, 8)}$addedHour${date.substring(10, 14)}";
    return finalExpiryDate;
  }

  String createExpiryDateByAddingADate(String date) {
    String dated = date.substring(6, 8);
    String addedDate = (int.parse(dated) + 1).toString();
    String finalExpiryDate =
        "${date.substring(0, 6)}$addedDate${date.substring(8, 14)}";
    return finalExpiryDate;
  }

  //MOBILE
  Future<String> postPaymentViaMobile(
      String phone, String cnic, String amount) async {
    //CURRENT DATE TIME
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    String dateTime = formatter.format(now);
    //EXPIRY DATE TIME (1 hr added)
    String expiry = createExpiryDateByAddingAnHour(dateTime);
    print(dateTime);
    print(expiry);
    // GENERATING SECURE HASH CODE
    var bytes = utf8.encode(
        "$amount&billRef&$cnic&Description&EN&${constants.jazzCashMerchantID}&$phone&${constants.jazzCashPassword}&PKR&$dateTime&$expiry&T$dateTime&8ys0dtd3x0"); // data being hashed
    String hash = sha256.convert(bytes).toString();
    print("hash Code: $hash");
    // REQUEST BODY
    JazzCashMobile jazzCashApi = JazzCashMobile(
      ppLanguage: "EN",
      ppMerchantId: constants.jazzCashMerchantID,
      ppSubMerchantId: "",
      ppPassword: constants.jazzCashPassword,
      ppTxnRefNo: "T$dateTime",
      ppMobileNumber: phone,
      ppCnic: cnic,
      ppAmount: amount,
      ppDiscountedAmount: "",
      ppTxnCurrency: "PKR",
      ppTxnDateTime: dateTime,
      ppBillReference: "billRef",
      ppDescription: "Description",
      ppTxnExpiryDateTime: expiry,
      ppSecureHash: hash,
      ppmpf1: "",
      ppmpf2: "",
      ppmpf3: "",
      ppmpf4: "",
      ppmpf5: "",
    );
    var jsonBody = jsonEncode(jazzCashApi);
    Response response = await post(constants.jazzCashMobilePaymentUrl,
        body: jsonBody, headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      String responseCode = responseBody["pp_ResponseCode"];
      print(responseBody);
      print(responseCode);
      return responseCode;
    } else {
      throw "Can't post via mobile";
    }
  }

  //CREDIT
  Future<String> postPaymentViaCredit(
      {String cardNo, String cvvNo, String expiry, String amount}) async {
    //CURRENT DATE TIME
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    String dateTime = formatter.format(now);
    //EXPIRY DATE TIME (1 hr added)
    String expiryDate = createExpiryDateByAddingADate(dateTime);
    print("jeee $dateTime");
    print("jeee $expiryDate");
    // GENERATING SECURE HASH CODE
    var bytes = utf8.encode(
        "8ys0dtd3x0&$amount&billRef&$cvvNo&$expiry&5123456789012346&test@test.com&test&03222852628&Description of transaction&Yes&${constants.jazzCashMerchantID}&${constants.jazzCashPassword}&No&PKR&$dateTime&$expiryDate&T$dateTime&MPAY"); // data being hashed
    String hash = sha256.convert(bytes).toString();
    print("hash Code: $hash");
    // REQUEST BODY
    JazzCashCredit jazzCashApi = JazzCashCredit(
      ppIsRegisteredCustomer: "Yes",
      ppShouldTokenizeCardNumber: "No",
      ppCustomerId: "test",
      ppCustomerEmail: "test@test.com",
      ppCustomerMobile: "03222852628",
      ppTxnType: "MPAY",
      ppTxnRefNo: "T$dateTime",
      ppC3DSecureId: "",
      ppMerchantId: constants.jazzCashMerchantID,
      ppPassword: constants.jazzCashPassword,
      ppAmount: amount,
      ppTxnCurrency: "PKR",
      ppTxnDateTime: dateTime,
      ppTxnExpiryDateTime: expiryDate,
      ppBillReference: "billRef",
      ppDescription: "Description of transaction",
      ppCustomerCardNumber: cardNo,
      ppCustomerCardExpiry: expiry,
      ppCustomerCardCvv: cvvNo,
      ppSecureHash: hash,
    );
    var jsonBody = jsonEncode(jazzCashApi);
    Response response = await post(constants.jazzCashCreditPaymentUrl,
        body: jsonBody, headers: {"content-type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      String responseCode = responseBody["pp_ResponseCode"];
      print(responseBody);
      print(responseCode);
      return responseCode;
    } else {
      throw "Can't post via credit";
    }
  }

  // //Voucher
  // Future<String> postPaymentViaVoucher(String phone, String amount) async {
  //   //CURRENT DATE TIME
  //   DateTime now = DateTime.now();
  //   DateFormat formatter = DateFormat('yyyyMMddHHmmss');
  //   String dateTime = formatter.format(now);
  //   //EXPIRY DATE TIME (1 hr added)
  //   String expiry = createExpiryDateByAddingADate(dateTime);
  //   print(dateTime);
  //   print(expiry);
  //   // GENERATING SECURE HASH CODE
  //   var bytes = utf8.encode(
  //       "$phone&$amount&billref&Description&EN&${constants.jazzCashMerchantID}&${constants.jazzCashPassword}&https://sandbox.jazzcash.com.pk/Sandbox/Home/GettingStarted&PKR&$dateTime&$expiry&T$dateTime&OTC&1.1"); // data being hashed
  //   String hash = sha256.convert(bytes).toString();
  //   print("hash Code: $hash");
  //   // REQUEST BODY
  //   JazzCashVoucher jazzCashApi = JazzCashVoucher(
  //     ppVersion: "1.1",
  //     ppTxnType: "OTC",
  //     ppLanguage: "EN",
  //     ppMerchantId: constants.jazzCashMerchantID,
  //     ppSubMerchantId: "",
  //     ppPassword: constants.jazzCashPassword,
  //     ppBankId: "",
  //     ppProductId: "",
  //     ppTxnRefNo: "T$dateTime",
  //     ppAmount: amount,
  //     ppTxnCurrency: "PKR",
  //     ppTxnDateTime: dateTime,
  //     ppBillReference: "billref",
  //     ppDescription: "Description",
  //     ppTxnExpiryDateTime: expiry,
  //     ppReturnUrl:
  //         "https://sandbox.jazzcash.com.pk/Sandbox/Home/GettingStarted",
  //     ppSecureHash: "",
  //     ppmpf1: phone,
  //     ppmpf2: "",
  //     ppmpf3: "",
  //     ppmpf4: "",
  //     ppmpf5: "",
  //   );
  //   var jsonBody = jsonEncode(jazzCashApi);
  //   Response response = await post(constants.jazzCashVoucherPaymentUrl,
  //       body: jsonBody, headers: {"Content-Type": "application/json"});
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     Map responseBody = jsonDecode(response.body);
  //     String responseCode = responseBody["pp_ResponseCode"];
  //     print(responseBody);
  //     print(responseCode);
  //     return responseCode;
  //   } else {
  //     throw "Can't post via voucher";
  //   }
  // }
}
