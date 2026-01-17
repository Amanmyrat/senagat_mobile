import 'confirm_payment.dart';
import 'resend_code.dart';
import 'start_hack.dart';
import 'submit_card.dart';

abstract class Service {
  Future<StartHackResponse> step1StartHack(StartHackRequest req);
  Future<SubmitCardResponse> step2SubmitCard(SubmitCardRequest req);
  Future<ResendCodeResponse> step3ResendCode(ResendCodeRequest req);
  Future<ConfirmPaymentResponse> step4ConfirmPayment(ConfirmPaymentRequest req);
}
