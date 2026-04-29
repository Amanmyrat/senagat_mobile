class PaymentHistoryModel {
  final int id;
  final String type;
  final String status;
  final int amount;
  final PaymentTarget paymentTarget;
  final String createdAt;

  PaymentHistoryModel({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.paymentTarget,
    required this.createdAt,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['id'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      amount: json['amount'] as int,
      paymentTarget:
      PaymentTarget.fromJson(json['payment_target']),
      createdAt: json['created_at'] as String,
    );
  }


Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'amount': amount,
      'payment_target': paymentTarget.toJson(),
      'created_at': createdAt,
    };
  }
}

class PaymentTarget {
  final String type;
  final String value;

  PaymentTarget({
    required this.type,
    required this.value,
  });

  factory PaymentTarget.fromJson(Map<String, dynamic> json) {
    return PaymentTarget(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}
