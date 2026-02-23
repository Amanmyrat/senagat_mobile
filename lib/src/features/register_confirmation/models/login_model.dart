class LoginModel {
  final String phone;
  final String? otpNumber;
  final String? password;

  LoginModel({
    required this.phone,
     this.otpNumber,
     this.password
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "otp": otpNumber,
      "password": password,
    };
  }
}
