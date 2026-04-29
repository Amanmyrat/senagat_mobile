import 'status.dart';

class ResendCodeRequest {
  String application;
  String identity;
  String acsRequestId;
  String acsSessionUrl;

  ResendCodeRequest({
    required this.application,
    required this.identity,
    required this.acsRequestId,
    required this.acsSessionUrl,
  });
}

class ResendCodeResponse {
  late HackResponseStatus status;
  late int resendAttemptsLeft;

  ResendCodeResponse({
    required this.status,
    required this.resendAttemptsLeft,
  });

  @override
  String toString() {
    return 'ResendCodeResponse {status: $status, attemptsLeft: $resendAttemptsLeft}';
  }
}
