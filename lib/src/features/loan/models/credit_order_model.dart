class CreditOrderModel {
  final int? creditId;
  final int? term;
  final int? amount;
  final double? monthlyPayment;

  final String? country;
  final int? bankId;

  final String? role;
  final String? patentNumber;
  final String? registrationNumber;
  final String? workAddress;
  final String? workplace;
  final String? position;
  final String? managerWorkAddress;
  final int? salary;

  CreditOrderModel({
    this.creditId,
    this.term,
    this.amount,
    this.monthlyPayment,
    this.country,
    this.bankId,
    this.role,
    this.patentNumber,
    this.registrationNumber,
    this.workAddress,
    this.workplace,
    this.position,
    this.managerWorkAddress,
    this.salary,
  });

  factory CreditOrderModel.fromJson(Map<String, dynamic> json) {
    return CreditOrderModel(
      creditId: json['credit_id'],
      term: json['term'],
      amount: json['amount'],
      monthlyPayment: json['monthly_payment'],
      country: json['country'],
      bankId: json['bank_branch_id'],
      role: json['role'],
      patentNumber: json['patent_number'],
      registrationNumber: json['registration_number'],
      workAddress: json['work_address'],
      workplace: json['workplace'],
      position: json['position'],
      managerWorkAddress: json['manager_work_address'],
      salary: json['salary'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'credit_id': creditId,
      'term': term,
      'amount': amount,
      'monthly_payment': monthlyPayment,
      'country': country,
      'bank_branch_id': bankId,
      'role': role,
      'patent_number': patentNumber,
      'registration_number': registrationNumber,
      'work_address': workAddress,
    };
  }

  Map<String, dynamic> toMap2() {
    return <String, dynamic>{
      'credit_id': creditId,
      'term': term,
      'amount': amount,
      'monthly_payment': monthlyPayment,
      'country': country,
      'bank_branch_id': bankId,
      'role': role,
      'workplace': workplace,
      'position': position,
      'manager_work_address': managerWorkAddress,
      'salary': salary,
    };
  }
}
