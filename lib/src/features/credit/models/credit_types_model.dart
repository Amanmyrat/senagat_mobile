class CreditTypeModel {
  final int? id;
  final String? name;
  final int? term;
  final String? amount;
  final String? interest;

  CreditTypeModel({
    this.id,
    this.name,
    this.term,
    this.amount,
    this.interest,
  });

  factory CreditTypeModel.fromJson(Map<String, dynamic> json) {
    return CreditTypeModel(
      id: json['id'],
      name: json['name'],
      term: json['term'],
      amount: json['amount'],
      interest: json['interest'],
    );
  }
}

