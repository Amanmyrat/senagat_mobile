class CharityModel {
  final String? bankName;
  final String? name;
  final String? surName;
  final int? amount;
  final String? formUrl;
  final String? orderId;

  CharityModel({
    this.bankName,
    this.name,
    this.surName,
    this.amount,
    this.formUrl,
    this.orderId,

  });

  factory CharityModel.fromMap(Map<String, dynamic> json) {
    return CharityModel(
      formUrl: json['form_url'] ?? '',
      orderId: json['order_id'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bank_name": bankName,
      "name": bankName,
      "surname": bankName,
      "amount": amount,
    };
  }
}
