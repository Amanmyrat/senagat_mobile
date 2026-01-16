import 'status.dart';

class ConfirmPaymentRequest {
  late String application;
  late String identity;
  late String mdOrder;
  late String acsRequestId;
  late String acsSessionUrl;
  late String oneTimePassword;
  late String terminateUrl;

  ConfirmPaymentRequest({
    required this.application,
    required this.identity,
    required this.mdOrder,
    required this.acsRequestId,
    required this.acsSessionUrl,
    required this.oneTimePassword,
    required this.terminateUrl,
  });
}

class ConfirmPaymentResponse {
  late HackResponseStatus status;
  int? currentAttempt;
  int? totalAttempts;
  String? finalUrl;

  ConfirmPaymentResponse({
    required this.status,
    this.currentAttempt,
    this.totalAttempts,
    this.finalUrl,
  });

  @override
  String toString() {
    return 'ConfirmPaymentResponse {status: $status, cur: $currentAttempt, tot: $totalAttempts, finalUrl: $finalUrl}';
  }
}
