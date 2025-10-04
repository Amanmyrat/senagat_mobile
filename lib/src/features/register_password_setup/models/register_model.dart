class RegisterModel {
  final String otpToken;
  final String password;

  RegisterModel({
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
