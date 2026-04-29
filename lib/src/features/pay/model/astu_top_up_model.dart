class AstuTopUpModel {
  final String? bankName;
  final int? amount;
  final String? phone;
  final String? type;
  final String? formUrl;
  final String? orderId;

  AstuTopUpModel({
    this.bankName,
    this.amount,
    this.phone,
    this.type,
    this.formUrl,
    this.orderId,

  });

  factory AstuTopUpModel.fromMap(Map<String, dynamic> json) {
    return AstuTopUpModel(
      formUrl: json['formUrl'] ?? '',
      orderId: json['orderId'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bank_name": bankName,
      "amount": amount,
      "phone": phone,
      "type": type,
    };
  }
}

