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
    this.message,
  });

  factory CheckBalanceModel.fromMap(Map<String, dynamic> json) {
    final data = json['data'];
    final error = json['error'];

    return CheckBalanceModel(
      balance: data != null ? data['balance'] : null,
      success: json['success'] ?? false,
      message: error != null ? error['message'] : null,
    );
  }

  Map<String, dynamic> toMap() => {
    "phone": phone,
    if (type != null && type!.isNotEmpty) "type": type,
  };
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