class CheckBalanceModel {
  final String? phone;
  final String? type;
  final String? balance;
  final bool? success;
  final String? message;

  CheckBalanceModel({
    this.phone,
    this.type,
    this.balance,
    this.success,
    this.message
  });

  factory CheckBalanceModel.fromMap(Map<String, dynamic> json) {
    return CheckBalanceModel(
      balance: json['data']?['balance'],
      success: json['success'] ?? '',
      message: json['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "phone": phone,
      "type": type,
    };
  }
}

class ApiError {
  String? code;
  String? message;

  ApiError({this.code, this.message});

  factory ApiError.fromMap(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'],
      message: json['message'],
    );
  }
}