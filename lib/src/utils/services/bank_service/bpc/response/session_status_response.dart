class SessionStatus {
  int? remainingSecs;
  String? redirect;
  SessionStatusCode? sessionStatus;
  String? orderNumber;
  String? amount;
  String? description;
  int? bonusAmount;
  bool? sslOnly;
  bool? cvcNotRequired;
  bool? epinAllowed;
  bool? feeAllowed;

  SessionStatus({
    this.remainingSecs,
    this.redirect,
    this.sessionStatus,
    this.orderNumber,
    this.amount,
    this.description,
    this.bonusAmount,
    this.sslOnly,
    this.cvcNotRequired,
    this.epinAllowed,
    this.feeAllowed,
  });

  factory SessionStatus.fromJson(Map<String, dynamic> json) {
    return SessionStatus(
      remainingSecs: json['remainingSecs'],
      redirect: json['redirect'],
      sessionStatus: SessionStatusCode.zero, //SessionStatusCode.values[json['sessionStatus']],
      orderNumber: json['orderNumber'],
      amount: json['amount'],
      description: json['description'],
      bonusAmount: json['bonusAmount'],
      sslOnly: json['sslOnly'],
      cvcNotRequired: json['cvcNotRequired'],
      epinAllowed: json['epinAllowed'],
      feeAllowed: json['feeAllowed'],
    );
  }

  bool isValid() {
    return !(remainingSecs == 0 || orderNumber == null || amount == null /* || description == null */);
  }
}

enum SessionStatusCode {
  zero,
}
