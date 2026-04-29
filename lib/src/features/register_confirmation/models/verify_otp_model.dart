class VerifyOtpModel {
  final String phone;
  final String code;
  final String purpose;

  VerifyOtpModel({
    required this.phone,
    required this.code,
    required this.purpose,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "code": code,
      "purpose": purpose,
    };
  }
}
