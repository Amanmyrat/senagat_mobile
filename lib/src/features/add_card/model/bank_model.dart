class BankModel {
  final String name;
  final String bankName;

  const BankModel({
    required this.name,
    required this.bankName,
  });
}

enum BankType {
  SenagatBank,
  AltynAsyrBank,
  RysgalBank
}