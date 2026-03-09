class TelecomTopUpModel {
  final String? bankName;
  final int? amount;
  final String? phone;
  final String? formUrl;
  final String? orderId;

  TelecomTopUpModel({
    this.bankName,
    this.amount,
    this.phone,
    this.formUrl,
    this.orderId,

  });

  factory TelecomTopUpModel.fromMap(Map<String, dynamic> json) {
    return TelecomTopUpModel(
      formUrl: json['formUrl'] ?? '',
      orderId: json['orderId'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bank_name": bankName,
      "amount": amount,
      "phone": phone,
    };
  }
}
