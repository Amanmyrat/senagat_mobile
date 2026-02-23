class RegisterModelForEnabledOTP {
  final String otpToken;
  final String password;

  RegisterModelForEnabledOTP({
    required this.otpToken,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "otp_session_token": otpToken,
      "password": password,
    };
  }
}
class RegisterModel {
  final String phone;
  final String password;

  RegisterModel({
    required this.phone,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "password": password,
    };
  }
}
