class ExchangeRateModel {
  final int? id;
  final String? currency;
  final String? purchase;
  final String? sale;
  final String? flag;

  ExchangeRateModel({this.id, this.currency, this.purchase, this.sale, this.flag});

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      id: json['id'],
      currency: json['currency'],
      purchase: json['purchase'],
      sale: json['sale'],
      flag: json['flag'],
    );
  }

}
