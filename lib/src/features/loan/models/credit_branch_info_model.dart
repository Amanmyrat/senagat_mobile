class CreditBranchInfoModel {

  final String? country;
  final String? bankName;


  CreditBranchInfoModel({
    this.country,
    this.bankName,
  });

  factory CreditBranchInfoModel.fromJson(Map<String, dynamic> json) {
    return CreditBranchInfoModel(
      country: json['country'],
      bankName: json['bank_name'],

    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'bank_name': bankName,
    };
  }


}
