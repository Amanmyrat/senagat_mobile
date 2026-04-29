class PreLoginModel {
  final String phone;
  final String password;

  PreLoginModel({
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
