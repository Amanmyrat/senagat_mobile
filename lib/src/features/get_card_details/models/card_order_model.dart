class CardOrderModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? typeId;
  final String? phoneNumber;
  final String? bankBranch;
  final String? homePhoneNumber;

  CardOrderModel({
    this.id,
    this.userId,
    this.profileId,
    this.typeId,
    this.phoneNumber,
    this.bankBranch,
    this.homePhoneNumber,
  });

  factory CardOrderModel.fromJson(Map<String, dynamic> json) {
    return CardOrderModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      typeId: json['card_type_id'],
      phoneNumber: json['phone_number'],
      bankBranch: json['bank_branch'],
      homePhoneNumber: json['home_phone_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "card_type_id": typeId,
      "phone_number": phoneNumber,
      "bank_branch": bankBranch,
      "home_phone_number": homePhoneNumber,
    };
  }
}
