import 'dart:io';
import 'dart:convert';

class ProfileModel {
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? birthDate;
  final String? passportNumber;
  final String? gender;
  final String? issuedDate;
  final String? issuedBy;
  final File? passportScan;

  ProfileModel({
    this.firstName,
    this.lastName,
    this.middleName,
    this.birthDate,
    this.passportNumber,
    this.gender,
    this.issuedDate,
    this.issuedBy,
    this.passportScan,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      birthDate: json['birth_date'],
      passportNumber: json['passport_number'],
      gender: json['gender'],
      issuedDate: json['issued_date'],
      issuedBy: json['issued_by'],
      passportScan: json['scan_passport'],
    );
  }

  Future<Map<String, dynamic>> toMap() async {

    return <String, dynamic>{
      "first_name": firstName,
      "last_name": lastName,
      "middle_name": middleName,
      "birth_date": birthDate,
      "passport_number": passportNumber,
      "gender": gender,
      "issued_date": issuedDate,
      "issued_by": issuedBy,
      "scan_passport": passportScan,
    };
  }
}
