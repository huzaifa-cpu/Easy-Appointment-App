class JazzCashMobile {
  JazzCashMobile({
    this.ppLanguage,
    this.ppMerchantId,
    this.ppSubMerchantId,
    this.ppPassword,
    this.ppTxnRefNo,
    this.ppMobileNumber,
    this.ppCnic,
    this.ppAmount,
    this.ppDiscountedAmount,
    this.ppTxnCurrency,
    this.ppTxnDateTime,
    this.ppBillReference,
    this.ppDescription,
    this.ppTxnExpiryDateTime,
    this.ppSecureHash,
    this.ppmpf1,
    this.ppmpf2,
    this.ppmpf3,
    this.ppmpf4,
    this.ppmpf5,
  });

  String ppLanguage;
  String ppMerchantId;
  String ppSubMerchantId;
  String ppPassword;
  String ppTxnRefNo;
  String ppMobileNumber;
  String ppCnic;
  String ppAmount;
  String ppDiscountedAmount;
  String ppTxnCurrency;
  String ppTxnDateTime;
  String ppBillReference;
  String ppDescription;
  String ppTxnExpiryDateTime;
  String ppSecureHash;
  String ppmpf1;
  String ppmpf2;
  String ppmpf3;
  String ppmpf4;
  String ppmpf5;

  factory JazzCashMobile.fromJson(Map<String, dynamic> json) => JazzCashMobile(
        ppLanguage: json["pp_Language"],
        ppMerchantId: json["pp_MerchantID"],
        ppSubMerchantId: json["pp_SubMerchantID"],
        ppPassword: json["pp_Password"],
        ppTxnRefNo: json["pp_TxnRefNo"],
        ppMobileNumber: json["pp_MobileNumber"],
        ppCnic: json["pp_CNIC"],
        ppAmount: json["pp_Amount"],
        ppDiscountedAmount: json["pp_DiscountedAmount"],
        ppTxnCurrency: json["pp_TxnCurrency"],
        ppTxnDateTime: json["pp_TxnDateTime"],
        ppBillReference: json["pp_BillReference"],
        ppDescription: json["pp_Description"],
        ppTxnExpiryDateTime: json["pp_TxnExpiryDateTime"],
        ppSecureHash: json["pp_SecureHash"],
        ppmpf1: json["ppmpf_1"],
        ppmpf2: json["ppmpf_2"],
        ppmpf3: json["ppmpf_3"],
        ppmpf4: json["ppmpf_4"],
        ppmpf5: json["ppmpf_5"],
      );

  Map<String, dynamic> toJson() => {
        "pp_Language": ppLanguage,
        "pp_MerchantID": ppMerchantId,
        "pp_SubMerchantID": ppSubMerchantId,
        "pp_Password": ppPassword,
        "pp_TxnRefNo": ppTxnRefNo,
        "pp_MobileNumber": ppMobileNumber,
        "pp_CNIC": ppCnic,
        "pp_Amount": ppAmount,
        "pp_DiscountedAmount": ppDiscountedAmount,
        "pp_TxnCurrency": ppTxnCurrency,
        "pp_TxnDateTime": ppTxnDateTime,
        "pp_BillReference": ppBillReference,
        "pp_Description": ppDescription,
        "pp_TxnExpiryDateTime": ppTxnExpiryDateTime,
        "pp_SecureHash": ppSecureHash,
        "ppmpf_1": ppmpf1,
        "ppmpf_2": ppmpf2,
        "ppmpf_3": ppmpf3,
        "ppmpf_4": ppmpf4,
        "ppmpf_5": ppmpf5,
      };
}
