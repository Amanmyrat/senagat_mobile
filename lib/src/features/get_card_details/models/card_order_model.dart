class CardOrderModel {
  final int? id;
  final int? userId;
  final int? profileId;
  final int? typeId;
  final int? bankBranch;
  final String? workPosition;
  final int? workPhone;
  final bool? internetService;
  final bool? delivery;
  final String? email;
  final String? createdAt;

  CardOrderModel({
    this.id,
    this.userId,
    this.profileId,
    this.typeId,
    this.bankBranch,
    this.workPosition,
    this.workPhone,
    this.internetService,
    this.delivery,
    this.email,
    this.createdAt,
  });

  factory CardOrderModel.fromJson(Map<String, dynamic> json) {
    return CardOrderModel(
      id: json['id'],
      userId: json['user_id'],
      profileId: json['profile_id'],
      typeId: json['card_type_id'],
      bankBranch: json['bank_branch_id'],
      workPosition: json['work_position'],
      workPhone: json['work_phone'],
      internetService: json['internet_service'],
      delivery: json['delivery'],
      email: json['email'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "card_type_id": typeId,
      "bank_branch_id": bankBranch,
      "work_position": workPosition,
      "work_phone": workPhone,
      "internet_service": internetService,
      "delivery": delivery,
      "email": email,
    };
  }
}
