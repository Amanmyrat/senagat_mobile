class RequestModel {
  final String phone;
  final String purpose;

  RequestModel({
    required this.phone,
    required this.purpose
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "purpose": purpose,
    };
  }
}
