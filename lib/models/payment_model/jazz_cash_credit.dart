class JazzCashCredit {
  JazzCashCredit({
    this.ppIsRegisteredCustomer,
    this.ppShouldTokenizeCardNumber,
    this.ppCustomerId,
    this.ppCustomerEmail,
    this.ppCustomerMobile,
    this.ppTxnType,
    this.ppTxnRefNo,
    this.ppMerchantId,
    this.ppPassword,
    this.ppAmount,
    this.ppTxnCurrency,
    this.ppTxnDateTime,
    this.ppC3DSecureId,
    this.ppTxnExpiryDateTime,
    this.ppBillReference,
    this.ppDescription,
    this.ppCustomerCardNumber,
    this.ppCustomerCardExpiry,
    this.ppCustomerCardCvv,
    this.ppSecureHash,
  });

  String ppIsRegisteredCustomer;
  String ppShouldTokenizeCardNumber;
  String ppCustomerId;
  String ppCustomerEmail;
  String ppCustomerMobile;
  String ppTxnType;
  String ppTxnRefNo;
  String ppMerchantId;
  String ppPassword;
  String ppAmount;
  String ppTxnCurrency;
  String ppTxnDateTime;
  String ppC3DSecureId;
  String ppTxnExpiryDateTime;
  String ppBillReference;
  String ppDescription;
  String ppCustomerCardNumber;
  String ppCustomerCardExpiry;
  String ppCustomerCardCvv;
  String ppSecureHash;

  factory JazzCashCredit.fromJson(Map<String, dynamic> json) => JazzCashCredit(
        ppIsRegisteredCustomer: json["pp_IsRegisteredCustomer"],
        ppShouldTokenizeCardNumber: json["pp_ShouldTokenizeCardNumber"],
        ppCustomerId: json["pp_CustomerID"],
        ppCustomerEmail: json["pp_CustomerEmail"],
        ppCustomerMobile: json["pp_CustomerMobile"],
        ppTxnType: json["pp_TxnType"],
        ppTxnRefNo: json["pp_TxnRefNo"],
        ppMerchantId: json["pp_MerchantID"],
        ppPassword: json["pp_Password"],
        ppAmount: json["pp_Amount"],
        ppTxnCurrency: json["pp_TxnCurrency"],
        ppTxnDateTime: json["pp_TxnDateTime"],
        ppC3DSecureId: json["pp_C3DSecureID"],
        ppTxnExpiryDateTime: json["pp_TxnExpiryDateTime"],
        ppBillReference: json["pp_BillReference"],
        ppDescription: json["pp_Description"],
        ppCustomerCardNumber: json["pp_CustomerCardNumber"],
        ppCustomerCardExpiry: json["pp_CustomerCardExpiry"],
        ppCustomerCardCvv: json["pp_CustomerCardCvv"],
        ppSecureHash: json["pp_SecureHash"],
      );

  Map<String, dynamic> toJson() => {
        "pp_IsRegisteredCustomer": ppIsRegisteredCustomer,
        "pp_ShouldTokenizeCardNumber": ppShouldTokenizeCardNumber,
        "pp_CustomerID": ppCustomerId,
        "pp_CustomerEmail": ppCustomerEmail,
        "pp_CustomerMobile": ppCustomerMobile,
        "pp_TxnType": ppTxnType,
        "pp_TxnRefNo": ppTxnRefNo,
        "pp_MerchantID": ppMerchantId,
        "pp_Password": ppPassword,
        "pp_Amount": ppAmount,
        "pp_TxnCurrency": ppTxnCurrency,
        "pp_TxnDateTime": ppTxnDateTime,
        "pp_C3DSecureID": ppC3DSecureId,
        "pp_TxnExpiryDateTime": ppTxnExpiryDateTime,
        "pp_BillReference": ppBillReference,
        "pp_Description": ppDescription,
        "pp_CustomerCardNumber": ppCustomerCardNumber,
        "pp_CustomerCardExpiry": ppCustomerCardExpiry,
        "pp_CustomerCardCvv": ppCustomerCardCvv,
        "pp_SecureHash": ppSecureHash,
      };
}
