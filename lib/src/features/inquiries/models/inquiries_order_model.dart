class InquiriesOrderModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? typeId;
  final int? bankBranch;
  final String? homeAddress;
  final bool? requiredPayment;
  final String? createdAt;
  final String? bankName;
  final String? paymentUrl;

  InquiriesOrderModel({
    this.id,
    this.userId,
    this.profileId,
    this.typeId,
    this.bankBranch,
    this.homeAddress,
    this.createdAt,
    this.requiredPayment,
    this.bankName,
    this.paymentUrl,
  });

  factory InquiriesOrderModel.fromJson(Map<String, dynamic> json) {
    return InquiriesOrderModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      typeId: json['certificate_type_id'],
      bankBranch: json['bank_branch_id'],
      homeAddress: json['home_address'],
      createdAt: json['created_at'],
      paymentUrl: json['payment_url'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      "certificate_type_id": typeId,
      "bank_branch_id": bankBranch,
      "home_address": homeAddress,
      "required_payment": requiredPayment,
    };

    if (requiredPayment == true) {
      map["bank_name"] = bankName;
    }

    return map;
  }

}
