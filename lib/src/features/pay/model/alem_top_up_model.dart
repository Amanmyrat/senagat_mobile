class AlemTopUpModel {
  final String? bankName;
  final int? period;
  final String? tarif;
  final String? type;
  final String? account;
  final String? formUrl;
  final String? orderId;

  AlemTopUpModel({
    this.bankName,
    this.period,
    this.tarif,
    this.type,
    this.account,
    this.formUrl,
    this.orderId,

  });

  factory AlemTopUpModel.fromMap(Map<String, dynamic> json) {
    return AlemTopUpModel(
      formUrl: json['formUrl'] ?? '',
      orderId: json['orderId'] ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "bank_name": bankName,
      "period": period,
      "tarif": tarif,
      "type": type,
      "account": account,
    };
  }
}

