class CreditWorkInfoModel {
  final String? role;

  final String? patentNumber;
  final String? registrationNumber;
  final String? workAddress;

  final String? workplace;
  final String? position;
  final String? managerWorkAddress;
  final String? phoneNumber;
  final String? salary;

  CreditWorkInfoModel({
    this.role,
    this.patentNumber,
    this.registrationNumber,
    this.workAddress,
    this.workplace,
    this.position,
    this.managerWorkAddress,
    this.phoneNumber,
    this.salary,
  });

  factory CreditWorkInfoModel.fromJson(Map<String, dynamic> json) {
    return CreditWorkInfoModel(
      role: json['role'],
      patentNumber: json['patent_number'],
      registrationNumber: json['registration_number'],
      workAddress: json['work_address'],
      workplace: json['workplace'],
      position: json['position'],
      managerWorkAddress: json['manager_work_address'],
      phoneNumber: json['phone_number'],
      salary: json['salary'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'patent_number': patentNumber,
      'registration_number': registrationNumber,
      'work_address': workAddress,
    };
  }

  Map<String, dynamic> toMap2() {
    return <String, dynamic>{
      'role': role,
      'workplace': workplace,
      'position': position,
      'manager_work_address': managerWorkAddress,
      'phone_number': phoneNumber,
      'salary': salary,
    };
  }
}
