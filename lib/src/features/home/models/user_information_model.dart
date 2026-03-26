import 'package:senagat_mobile/src/features/identity_verification/models/profile_model.dart';

class UserInformationModel {
  final int? id;
  final String? phone;
  final ProfileModel? profileModel;
  final List<CertificateModel>? certificates;
  final List<LoanModel>? loan;
  final List<CardsModel>? cards;

  UserInformationModel({
    this.id,
    this.phone,
    this.profileModel,
    this.certificates,
    this.loan,
    this.cards,
  });

  factory UserInformationModel.fromJson(Map<String, dynamic> json) {
    return UserInformationModel(
      id: json['id'],
      phone: json['phone'],
      profileModel: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'])
          : null,
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((item) => CertificateModel.fromJson(item))
          .toList(),
      loan: (json['loans'] as List<dynamic>?)
          ?.map((item) => LoanModel.fromJson(item))
          .toList(),
      cards: (json['cards'] as List<dynamic>?)
          ?.map((item) => CardsModel.fromJson(item))
          .toList(),
    );
  }
}

class LoanModel {
  final String? creditName;
  final int? amount;
  final double? monthlyPayment;
  final String? status;
  final String? bankBranch;
  final String? createdAt;


  LoanModel({this.creditName, this.amount, this.monthlyPayment, this.status, this.bankBranch, this.createdAt});

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      creditName: json['credit_name'],
      amount: json['amount'],
      monthlyPayment: (json['monthly_payment']as num?)?.toDouble(),
      status: json['status'],
      bankBranch: json['bank_branch'],
      createdAt: json['created_at'],

    );
  }
}

class CertificateModel {
  final String? certificateName;
  final int? bankBranchId;
  final double? certificatePrice;
  final String? status;
  final String? bankBranch;
  final String? createdAt;


  CertificateModel({this.certificateName, this.bankBranchId, this.status, this.certificatePrice, this.bankBranch, this.createdAt});

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      certificateName: json['certificate_name'],
      bankBranchId: json['bank_branch_id'],
      certificatePrice: (json['certificate_price']as num?)?.toDouble(),
      status: json['status'],
      bankBranch: json['bank_branch'],
      createdAt: json['created_at'],

    );
  }
}

class CardsModel {
  final String? cardTitle;
  final double? cardPrice;
  final bool? delivery;
  final String? status;
  final String? bankBranch;
  final String? createdAt;

  CardsModel({this.cardTitle, this.cardPrice, this.delivery, this.status, this.bankBranch, this.createdAt});

  factory CardsModel.fromJson(Map<String, dynamic> json) {
    return CardsModel(
      cardTitle: json['card_title'],
      status: json['status'],
      cardPrice: (json['card_price']as num?)?.toDouble(),
      delivery: json['delivery'],
      bankBranch: json['bank_branch'],
      createdAt: json['created_at'],

    );
  }
}
