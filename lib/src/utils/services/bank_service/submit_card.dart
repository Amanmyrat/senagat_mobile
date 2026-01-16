import 'status.dart';

class SubmitCardRequest {
  String application;
  String identity;
  String mdOrder;
  String cardNumber;
  String expiry;
  String nameOnCard;
  String cvcCode;

  SubmitCardRequest({
    required this.application,
    required this.identity,
    required this.mdOrder,
    required this.cardNumber,
    required this.expiry,
    required this.nameOnCard,
    this.cvcCode = '',
  });
}

class SubmitCardResponse {
  HackResponseStatus status;
  String acsRequestId;
  String acsSessionUrl;
  // String threeDSecureNumber;
  int resendAttemptsLeft;
  String terminateUrl;

  SubmitCardResponse({
    required this.status,
    this.acsRequestId = '',
    this.acsSessionUrl = '',
    // this.threeDSecureNumber = '',
    this.resendAttemptsLeft = 0,
    this.terminateUrl = '',
  });

  @override
  String toString() {
    return 'SubmitCardResponse {status: $status, reqId: $acsRequestId, acsUrl: $acsSessionUrl, attLeft: $resendAttemptsLeft, termUrl: $terminateUrl}';
    // return 'SubmitCardResponse {status: $status, reqId: $acsRequestId, acsUrl: $acsSessionUrl, 3ds-num: $threeDSecureNumber, attLeft: $resendAttemptsLeft, termUrl: $terminateUrl}';
  }
}
