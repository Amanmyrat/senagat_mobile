class CreditBranchInfoModel {

  final String? country;
  final int? bankId;


  CreditBranchInfoModel({
    this.country,
    this.bankId,
  });

  factory CreditBranchInfoModel.fromJson(Map<String, dynamic> json) {
    return CreditBranchInfoModel(
      country: json['country'],
      bankId: json['bank_branch_id'],

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'bank_branch_id': bankId,
    };
  }


}
