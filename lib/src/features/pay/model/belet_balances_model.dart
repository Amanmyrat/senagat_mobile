class BeletBalanceModel {
  final int? value;
  final String? title;

  BeletBalanceModel({this.title, this.value});

  factory BeletBalanceModel.fromJson(Map<String, dynamic> json) {
    return BeletBalanceModel(
      title: json['title'],
      value: json['value'],
    );
  }

}
