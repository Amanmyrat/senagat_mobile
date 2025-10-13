class CreditDetailsModel {
  final int? creditId;
  final int? term;
  final int? amount;
  final double? monthlyPayment;

  CreditDetailsModel({
    this.creditId,
    this.term,
    this.amount,
    this.monthlyPayment,

  });

  factory CreditDetailsModel.fromJson(Map<String, dynamic> json) {
    return CreditDetailsModel(
      creditId: json['credit_id'],
      term: json['term'],
      amount: json['amount'],
      monthlyPayment: json['monthly_payment'],

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "credit_id": creditId,
      "term": term,
      "amount": amount,
      "monthly_payment": monthlyPayment,
    };
  }
}
