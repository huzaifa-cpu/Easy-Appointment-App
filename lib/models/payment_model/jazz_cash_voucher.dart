class JazzCashVoucher {
  JazzCashVoucher({
    this.ppVersion,
    this.ppTxnType,
    this.ppLanguage,
    this.ppMerchantId,
    this.ppSubMerchantId,
    this.ppPassword,
    this.ppBankId,
    this.ppProductId,
    this.ppTxnRefNo,
    this.ppAmount,
    this.ppTxnCurrency,
    this.ppTxnDateTime,
    this.ppBillReference,
    this.ppDescription,
    this.ppTxnExpiryDateTime,
    this.ppReturnUrl,
    this.ppSecureHash,
    this.ppmpf1,
    this.ppmpf2,
    this.ppmpf3,
    this.ppmpf4,
    this.ppmpf5,
  });

  String ppVersion;
  String ppTxnType;
  String ppLanguage;
  String ppMerchantId;
  String ppSubMerchantId;
  String ppPassword;
  String ppBankId;
  String ppProductId;
  String ppTxnRefNo;
  String ppAmount;
  String ppTxnCurrency;
  String ppTxnDateTime;
  String ppBillReference;
  String ppDescription;
  String ppTxnExpiryDateTime;
  String ppReturnUrl;
  String ppSecureHash;
  String ppmpf1;
  String ppmpf2;
  String ppmpf3;
  String ppmpf4;
  String ppmpf5;

  factory JazzCashVoucher.fromJson(Map<String, dynamic> json) =>
      JazzCashVoucher(
        ppVersion: json["pp_Version"],
        ppTxnType: json["pp_TxnType"],
        ppLanguage: json["pp_Language"],
        ppMerchantId: json["pp_MerchantID"],
        ppSubMerchantId: json["pp_SubMerchantID"],
        ppPassword: json["pp_Password"],
        ppBankId: json["pp_BankID"],
        ppProductId: json["pp_ProductID"],
        ppTxnRefNo: json["pp_TxnRefNo"],
        ppAmount: json["pp_Amount"],
        ppTxnCurrency: json["pp_TxnCurrency"],
        ppTxnDateTime: json["pp_TxnDateTime"],
        ppBillReference: json["pp_BillReference"],
        ppDescription: json["pp_Description"],
        ppTxnExpiryDateTime: json["pp_TxnExpiryDateTime"],
        ppReturnUrl: json["pp_ReturnURL"],
        ppSecureHash: json["pp_SecureHash"],
        ppmpf1: json["ppmpf_1"],
        ppmpf2: json["ppmpf_2"],
        ppmpf3: json["ppmpf_3"],
        ppmpf4: json["ppmpf_4"],
        ppmpf5: json["ppmpf_5"],
      );

  Map<String, dynamic> toJson() => {
        "pp_Version": ppVersion,
        "pp_TxnType": ppTxnType,
        "pp_Language": ppLanguage,
        "pp_MerchantID": ppMerchantId,
        "pp_SubMerchantID": ppSubMerchantId,
        "pp_Password": ppPassword,
        "pp_BankID": ppBankId,
        "pp_ProductID": ppProductId,
        "pp_TxnRefNo": ppTxnRefNo,
        "pp_Amount": ppAmount,
        "pp_TxnCurrency": ppTxnCurrency,
        "pp_TxnDateTime": ppTxnDateTime,
        "pp_BillReference": ppBillReference,
        "pp_Description": ppDescription,
        "pp_TxnExpiryDateTime": ppTxnExpiryDateTime,
        "pp_ReturnURL": ppReturnUrl,
        "pp_SecureHash": ppSecureHash,
        "ppmpf_1": ppmpf1,
        "ppmpf_2": ppmpf2,
        "ppmpf_3": ppmpf3,
        "ppmpf_4": ppmpf4,
        "ppmpf_5": ppmpf5,
      };
}
