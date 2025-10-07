import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as dio;

part 'profile_model.g.dart';

@HiveType(typeId: 1)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String? firstName;

  @HiveField(1)
  final String? lastName;

  @HiveField(2)
  final String? middleName;

  @HiveField(3)
  final String? birthDate;

  @HiveField(4)
  final String? passportNumber;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final String? issuedDate;

  @HiveField(7)
  final String? issuedBy;

  @HiveField(8)
  final String? getPassportScan;

  @HiveField(9)
  final String? passportScanPath;

  final dio.MultipartFile? passportScan;

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
    this.getPassportScan,
    this.passportScanPath,
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
      getPassportScan: json['passport_scan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "middle_name": middleName,
      "birth_date": birthDate,
      "passport_number": passportNumber,
      "gender": gender,
      "issued_date": issuedDate,
      "issued_by": issuedBy,
      "passport_scan": getPassportScan,
    };
  }

  Future<Map<String, dynamic>> toMap() async {
    return {
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
