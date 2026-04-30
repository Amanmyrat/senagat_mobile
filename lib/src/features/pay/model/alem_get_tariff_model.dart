class AlemGetTariffModel {
  final String account;
  final String type;
  final String tarif;
  final String end;
  final List<PaymentOption> paymentOptions;

  AlemGetTariffModel({
    required this.account,
    required this.type,
    required this.tarif,
    required this.end,
    required this.paymentOptions,
  });

  factory AlemGetTariffModel.fromMap(Map<String, dynamic> json) {
    return AlemGetTariffModel(
      account: json['account'] ?? '',
      type: json['type'] ?? '',
      tarif: json['tarif'] ?? '',
      end: json['end'] ?? '',
      paymentOptions: (json['payment_options'] as List? ?? [])
          .map((e) => PaymentOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account': account,
      'type': type,
    };
  }
}


class PaymentOption {
  final int months;
  final int amount;

  PaymentOption({
    required this.months,
    required this.amount,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      months: json['months'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'amount': amount,
    };
  }
}