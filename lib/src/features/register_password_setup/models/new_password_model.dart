class NewPasswordModel {
  final String phone;
  final String otpToken;
  final String password;

  NewPasswordModel({
    required this.phone,
    required this.otpToken,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "token": otpToken,
      "password": password,
    };
  }
}
