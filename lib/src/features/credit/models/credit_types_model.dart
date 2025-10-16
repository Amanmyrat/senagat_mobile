class CreditTypeModel {
  final int? id;
  final String? name;
  final int? term;
  final int? minAmount;
  final int? maxAmount;
  final int? interest;

  CreditTypeModel({
    this.id,
    this.name,
    this.term,
    this.minAmount,
    this.maxAmount,
    this.interest,
  });

  factory CreditTypeModel.fromJson(Map<String, dynamic> json) {
    return CreditTypeModel(
      id: json['id'],
      name: json['name'],
      term: json['term'],
      minAmount: json['min_amount'],
      maxAmount: json['max_amount'],
      interest: json['interest'],
    );
  }
}

