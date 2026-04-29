class BeletTopUpModel {
  final String? bankName;
  final int? amount;
  final String? phone;
  final String? formUrl;
  final String? orderId;

  BeletTopUpModel({
    this.bankName,
    this.amount,
    this.phone,
    this.formUrl,
    this.orderId,

  });

  factory BeletTopUpModel.fromMap(Map<String, dynamic> json) {
    return BeletTopUpModel(
      formUrl: json['form_url'] ?? '',
      orderId: json['order_id'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bank_name": bankName,
      "amount_in_manats": amount,
      "phone": phone,
    };
  }
}
