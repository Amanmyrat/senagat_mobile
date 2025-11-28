class InquiriesOrderModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? typeId;
  final int? bankBranch;
  final String? homeAddress;

  InquiriesOrderModel({
    this.id,
    this.userId,
    this.profileId,
    this.typeId,
    this.bankBranch,
    this.homeAddress,
  });

  factory InquiriesOrderModel.fromJson(Map<String, dynamic> json) {
    return InquiriesOrderModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      typeId: json['certificate_type_id'],
      bankBranch: json['bank_branch_id'],
      homeAddress: json['home_address'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "certificate_type_id": typeId,
      "bank_branch_id": bankBranch,
      "home_address": homeAddress,
    };
  }
}
