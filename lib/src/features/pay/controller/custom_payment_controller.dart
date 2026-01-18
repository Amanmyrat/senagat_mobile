import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/add_card/model/bank_model.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_confirmation_screen.dart';
import 'package:senagat_mobile/src/utils/services/bank_service/bank_services.dart';
import 'package:senagat_mobile/src/utils/services/show_snack.dart';

import '../../dashboard/presentation/dashboard_screen.dart';

class CustomPaymentController extends GetxController with StateControlMixin {
  final String orderId;
  final String paymentUrl;
  final String phoneNumber;
  final CardModel selectedCard;

  String? errorMessage;
  String? baseMpiUrl;
  final cardBox = Hive.box<CardModel>('cardsBox');

  CustomPaymentController({
    required this.orderId,
    required this.paymentUrl,
    required this.selectedCard,
    required this.phoneNumber,
  });

  @override
  void onInit() {
    super.onInit();
    _startPayment();
  }

  Future<void> _startPayment() async {
    if (selectedCard.bank == r'senagat') {
      baseMpiUrl = 'https://epg.senagatbank.com.tm/epg/rest';
    } else if (selectedCard.bank == r'altyn_asyr') {
      baseMpiUrl = 'https://mpi.gov.tm/payment/rest';
    }

    BankType selectedBank = selectedCard.bank == r'senagat'
        ? BankType.SenagatBank
        : selectedCard.bank == r'altyn_asyr'
        ? BankType.AltynAsyrBank
        : BankType.RysgalBank;
    BankService bankService = BankService(
      baseMpiUrl: baseMpiUrl!,
      bankType: selectedBank,
    );

    final StartHackRequest startHackReq = StartHackRequest(
      application: 'step1',
      identity: 'identity',
      paymentUrl: paymentUrl,
    );

    status = Status.loading;
    update();

    try {
      final step1Resp = await bankService.step1StartHack(startHackReq);

      if (step1Resp.status != HackResponseStatus.ok) {
        /// only [alreadyProcessed] returns in error state
        if (step1Resp.status == HackResponseStatus.alreadyProcessed) {
          debugPrint('session expired or already processed');
          errorMessage = r'session_expired'.tr;
        }
        _setResult(step1Resp.status);
        return;
      }

      // Get the first card from Hive box
      if (cardBox.isEmpty) {
        errorMessage = r'no_card_found'.tr;
        status = Status.error;
        update();
        return;
      }

      // final card = cardBox.getAt(0)!;
      final card = selectedCard;

      print(card.cardNumber.trim());
      final SubmitCardRequest submitCardReq = SubmitCardRequest(
        application: 'step2',
        identity: 'identity',
        mdOrder: step1Resp.mdOrder ?? '',
        cardNumber: card.cardNumber.replaceAll(' ', ''),
        expiry:
            '20${card.expiryDate.substring(card.expiryDate.length - 2)}${card.expiryDate.substring(0, 2)}',
        // YYYYMM
        nameOnCard: card.name,
        cvcCode: card.cvc,
      );

      final step2Resp = await bankService.step2SubmitCard(submitCardReq);

      if (step2Resp.status != HackResponseStatus.ok) {
        _setResult(step2Resp.status);
        return;
      }

      ResendCodeRequest resendCodeReq = ResendCodeRequest(
        application: 'step3',
        identity: 'identity',
        acsRequestId: step2Resp.acsRequestId,
        acsSessionUrl: step2Resp.acsSessionUrl,
      );

      status = Status.completed;
      update();

      // Show OTP input dialog
      String? otp = await _showOtpDialog(resendCodeReq, bankService);

      if (otp == null || otp.isEmpty) {
        Get.back();
        return;
      }

      status = Status.loading;
      update();

      ConfirmPaymentRequest confirmPaymentReq = ConfirmPaymentRequest(
        application: 'step4',
        identity: 'identity',
        mdOrder: step1Resp.mdOrder!,
        acsRequestId: step2Resp.acsRequestId,
        acsSessionUrl: step2Resp.acsSessionUrl,
        oneTimePassword: otp,
        terminateUrl: step2Resp.terminateUrl,
      );

      final confirm = await bankService.step4ConfirmPayment(confirmPaymentReq);

      if (confirm.status == HackResponseStatus.ok) {
        status = Status.success;
        update();

      } else {
        // status = Status.success;
        // update();
        _setResult(confirm.status);
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      errorMessage = r'payment_error'.tr;
      status = Status.error;
      update();
    }
  }

  Future<String?> _showOtpDialog(
    ResendCodeRequest resendCodeRequest,
    BankService bankService,
  ) async {
    return await Get.dialog<String>(
      PaymentConfirmationScreen(
        resendCodeRequest: resendCodeRequest,
        bankService: bankService,
        phoneNumber: phoneNumber,
      ),
      barrierDismissible: false,
    );
  }

  void _setSuccess() {
    ShowSnack.showSnack('payment_successful'.tr, SnackType.success);

    Future.delayed(const Duration(milliseconds: 800), () {
      Get.offAllNamed(DashboardScreen.route);
    });

    // Future.delayed(const Duration(milliseconds: 800), () {
    //   Get.back(result: {
    //     'success': true,
    //     'orderId': orderId,
    //   });
    // });
  }

  void _setResult(HackResponseStatus status) {
    if (status == HackResponseStatus.ok) return;

    final message = _getErrorMessage(status);

    this.status = Status.error;
    errorMessage = message;
    update();

    // ShowSnack.showSnack(message, SnackType.error);
    //
    // Future.delayed(const Duration(milliseconds: 1200), () {
    //   Get.back(result: {'success': false, 'error': message});
    // });
  }

  String _getErrorMessage(HackResponseStatus status) {
    switch (status) {
      case HackResponseStatus.invalidCard:
        return 'invalid_card_details'.tr;

      case HackResponseStatus.specifyCVC:
        return 'please_enter_cvc'.tr;

      case HackResponseStatus.wrongOTP:
        return 'incorrect_otp_try_again'.tr;

      case HackResponseStatus.operationCancelled:
        return 'payment_cancelled'.tr;

      case HackResponseStatus.alreadyProcessed:
        return 'payment_already_processed'.tr;

      case HackResponseStatus.networkError:
        return 'network_error_try_again'.tr;

      default:
        return 'payment_failed'.tr;
    }
  }
}
