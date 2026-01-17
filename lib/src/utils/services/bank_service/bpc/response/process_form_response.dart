class PaymentProcessForm {
  String info;
  String acsUrl;
  String paReq;
  String termUrl;
  int errorCode;
  String error;
  String redirect;

  PaymentProcessForm({
    required this.info,
    this.acsUrl = '',
    this.paReq = '',
    this.termUrl = '',
    this.errorCode = 0,
    this.error = '',
    this.redirect = '',
  });

  factory PaymentProcessForm.fromJson(Map<String, dynamic> json) {
    return PaymentProcessForm(
      info: json['info'] ?? '',
      acsUrl: json['acsUrl'] ?? '',
      paReq: json['paReq'] ?? '',
      termUrl: json['termUrl'] ?? '',
      errorCode: json['errorCode'] ?? 0,
      error: json['error'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }

  bool isValid() {
    return !(errorCode != 0 || acsUrl.isEmpty || paReq.isEmpty || termUrl.isEmpty);
  }

  bool isCardError() {
    return errorCode == 1 && (error.contains('Payment system') || error.contains('Неизвестная платёжная система'));
  }

  bool isCVCError() {
    return errorCode == 1 && (error.contains('CVC') || error.contains('код'));
  }
}
