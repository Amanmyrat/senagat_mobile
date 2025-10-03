class LoginModel {
  final String phone;
  final String otpNumber;

  LoginModel({
    required this.phone,
    required this.otpNumber
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "otp": otpNumber,
    };
  }
}
