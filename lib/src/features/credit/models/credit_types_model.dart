class CreditTypeModel {
  final int? id;
  final String? title;
  final int? term;
  final int? minAmount;
  final int? maxAmount;
  final int? interest;
  final bool? canOfferOnline;

  CreditTypeModel({
    this.id,
    this.title,
    this.term,
    this.minAmount,
    this.maxAmount,
    this.interest,
    this.canOfferOnline,
  });

  factory CreditTypeModel.fromJson(Map<String, dynamic> json) {
    return CreditTypeModel(
      id: json['id'],
      title: json['title'],
      term: json['term'],
      minAmount: json['min_amount'],
      maxAmount: json['max_amount'],
      interest: json['interest'],
      canOfferOnline: json['can_offer_online'],
    );
  }
}

