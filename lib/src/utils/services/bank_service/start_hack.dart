import 'status.dart';

class StartHackRequest {
  late String application;
  late String identity;
  late String paymentUrl;

  StartHackRequest({
    required this.application,
    required this.identity,
    required this.paymentUrl,
  });
}

class StartHackResponse {
  late HackResponseStatus status;
  String? mdOrder;
  int? remainingTime;
  int? expirationTs;
  bool isCVCRequired;
  String? amountInfo;

  StartHackResponse({
    required this.status,
    this.mdOrder,
    this.remainingTime,
    this.expirationTs,
    this.isCVCRequired = false,
    this.amountInfo,
  });
}
