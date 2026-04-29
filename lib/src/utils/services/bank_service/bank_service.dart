import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:senagat_mobile/src/features/add_card/model/bank_model.dart';

import '../log/log_service.dart';
import 'bank_service_abstract.dart';
import 'bpc/response/acs_submit_form_response.dart';
import 'bpc/response/process_form_response.dart';
import 'bpc/response/session_status_response.dart';
import 'confirm_payment.dart';
import 'parse_strings.dart';
import 'resend_code.dart';
import 'start_hack.dart';
import 'status.dart';
import 'submit_card.dart';

class BankService implements Service {
  final String baseMpiUrl;
  final BankType bankType;
  BankService({required this.baseMpiUrl, required this.bankType});

  @override
  Future<StartHackResponse> step1StartHack(StartHackRequest req) async {
    LogService.log('BEGIN: step1StartHack');

    final Map<String, dynamic> info = {
      'app': req.application,
      'id': req.identity,
    };

    LogService.logMap(info);
    LogService.log('Processing');

    // default response
    StartHackResponse resp = StartHackResponse(status: HackResponseStatus.otherError);

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
      // Parse payment URL
      Uri paymentUrl = Uri.parse(req.paymentUrl);

      print("Payment url is");
      print(req.paymentUrl.toString());
      final mdOrder = paymentUrl.queryParameters['mdOrder'];
      resp.mdOrder = mdOrder;

      final form = {'MDORDER': mdOrder};

      print("MORDER IS url is");
      print(mdOrder.toString());
      final sessionUri = Uri.parse('$baseMpiUrl/getSessionStatus.do');
      final http.Response res = await http.post(sessionUri, headers: headers, body: form);

      print("sessionUri IS url is");
      print(sessionUri.toString());

      final String data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode != 200) throw Exception('invalid http status code: ${res.statusCode}');

      SessionStatus bpcResponse = SessionStatus.fromJson(json.decode(data));

      if (!bpcResponse.isValid()) {
        resp.status = HackResponseStatus.alreadyProcessed;
        throw Exception('session expired or already processed');
      }

      // Response is valid
      resp.status = HackResponseStatus.ok;
      resp.mdOrder = mdOrder;
      resp.remainingTime = bpcResponse.remainingSecs;
      resp.expirationTs = bpcResponse.remainingSecs ?? 0 + DateTime.now().millisecondsSinceEpoch;

      resp.isCVCRequired = bpcResponse.cvcNotRequired ?? false;
      resp.amountInfo = bpcResponse.amount;

      LogService.log('END: step1StartHack');

      return resp;
    } catch (e) {
      LogService.log('--Exception: step1StartHack---');
      LogService.log(e);
      LogService.log('------------------------------');
      return resp;
    }
  }

  @override
  Future<SubmitCardResponse> step2SubmitCard(SubmitCardRequest req) async {
    LogService.log('BEGIN: step2SubmitCard');

    final Map<String, dynamic> info = {
      'app': req.application,
      'id': req.identity,
    };

    LogService.logMap(info);
    LogService.log('Processing');

    // default response
    final SubmitCardResponse resp = SubmitCardResponse(status: HackResponseStatus.otherError);

    try {
      // submit card
      PaymentProcessForm? bpcResponsePart1 = await step2part1SubmitCard(req);
      if (bpcResponsePart1 == null) throw Exception('error: step2SubmitCard part 1');

      // handle card validation
      if (!bpcResponsePart1.isValid()) {
        String eMsg = 'invalid bpc response';

        if (bpcResponsePart1.errorCode == 1) {
          eMsg = bpcResponsePart1.error;
          if (bpcResponsePart1.isCVCError()) {
            eMsg = 'specify cvc';
            resp.status = HackResponseStatus.specifyCVC;
          } else if (bpcResponsePart1.isCardError()) {
            eMsg = 'card error';
            resp.status = HackResponseStatus.invalidCard;
          }
        }

        throw Exception(eMsg);
      }

      // update response
      resp.terminateUrl = bpcResponsePart1.termUrl;

      LogService.log('DATA bpcResponsePart1 => $bpcResponsePart1');

      // submit acs
      ACSSubmitForm? bpcResponsePart2 = await step2part2SubmitACS(
        req.mdOrder,
        bpcResponsePart1.paReq,
        bpcResponsePart1.acsUrl,
        bpcResponsePart1.termUrl,
      );
      if (bpcResponsePart2 == null) throw Exception('error: step2SubmitCard part 2');

      // send password
      int? attemptsLeft = await step2part3ACSSendPassword(
        bpcResponsePart2.acsRequestId,
        bpcResponsePart2.acsSessionUrl,
      );
      if (attemptsLeft == null) throw Exception('error: step2SubmitCard part 3');

      // response is ok
      resp.status = HackResponseStatus.ok;
      resp.acsRequestId = bpcResponsePart2.acsRequestId;
      resp.acsSessionUrl = bpcResponsePart2.acsSessionUrl;
      // resp.threeDSecureNumber = bpcResponsePart2.threeDSecureNumber;
      resp.resendAttemptsLeft = attemptsLeft;

      LogService.log('END`: step2SubmitCard');

      return resp;
    } catch (e) {
      LogService.log('--Exception: step2SubmitCard--');
      LogService.log(e);
      LogService.log('------------------------------');
      return resp;
    }
  }

  // TODO: test
  @override
  Future<ResendCodeResponse> step3ResendCode(ResendCodeRequest req) async {
    LogService.log('BEGIN: step3ResendCode');

    final Map<String, dynamic> info = {
      'app': req.application,
      'id': req.identity,
      // 'acsUrl': req.acsSessionUrl,
    };

    LogService.logMap(info);
    LogService.log('Processing');

    //default response
    ResendCodeResponse resp = ResendCodeResponse(
      status: HackResponseStatus.otherError,
      resendAttemptsLeft: 3, //default
    );

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> form = {
      'authForm': 'authForm',
      'request_id': req.acsRequestId,
      'pwdInputVisible': '',
      'resendPasswordLink': 'resendPasswordLink',
    };

    try {
      final Uri uri = Uri.parse(req.acsSessionUrl);
      final http.Response res = await http.post(uri, headers: headers, body: form);

      final String data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode != 200) throw Exception('invalid http status code: ${res.statusCode}');
      //Attempt 1 of 3
      final left = Parser.extractAttempt(data);
      if (left.isEmpty) {
        const eMsg = "'ThreeDSecurePasswordAttemptsBegin' was not found in response";
        LogService.log(eMsg);
        // throw Exception(eMsg);
      }

      LogService.log('LEFT: $left');

      final strArr = left.split(' ');

      final curAttempt = int.tryParse(strArr[1]);
      final totalAttempt = int.tryParse(strArr[3]);

      int? attemptsLeft = totalAttempt! - curAttempt!;

      // update response
      resp.status = HackResponseStatus.ok;
      resp.resendAttemptsLeft = attemptsLeft;

      LogService.log('END: step3ResendCode');

      return resp;
    } catch (e) {
      LogService.log('--Exception: step3ResendCode--');
      LogService.log(e);
      LogService.log('------------------------------');
      return resp;
    }
  }


  String checkResponse(http.Response res) {
    if (res.request == null) throw Exception('request of response is null');

    if (res.request?.url != null) {
      return res.request!.url.toString();
    } else {
      throw Exception('request url is null');
    }
  }

  Future<PaymentProcessForm?> step2part1SubmitCard(SubmitCardRequest req) async {
    LogService.log('BEGIN: step2part1SubmitCard');

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> form = {
      'MDORDER': req.mdOrder,
      '\$PAN': req.cardNumber,
      '\$EXPIRY': req.expiry,
      'TEXT': req.nameOnCard,
      '\$CVC': req.cvcCode,
    };

    LogService.logMap(form);
    LogService.log('Processing');

    try {
      final processFormUrl = Uri.parse('$baseMpiUrl/processform.do');
      final res = await http.post(processFormUrl, headers: headers, body: form);

      final data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode != 200) throw Exception('invalid http status code: ${res.statusCode}');

      PaymentProcessForm ppFormResponse = PaymentProcessForm.fromJson(json.decode(data));

      LogService.log('END: step2part1SubmitCard');

      return ppFormResponse;
    } catch (e) {
      LogService.log('--Exception: step2part1SubmitCard--');
      LogService.log(e);
      LogService.log('-----------------------------------');
      return null;
    }
  }

  Future<ACSSubmitForm?> step2part2SubmitACS(String mdOrder, String paReq, String acsUrl, String termUrl) async {
    LogService.log('BEGIN: step2part2SubmitACS');

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> form = {
      'MD': mdOrder,
      'PaReq': paReq,
      'TermUrl': termUrl,
    };

    LogService.logMap(form);
    LogService.log('Processing');

    try {
      // sample request url
      // https://acs.gov.tm/acs/pages/enrollment/authentication.jsf?request_id=17488681927f9sveJU8N8N88iWyC

      final Uri postUri = Uri.parse(acsUrl);
      final res = await http.post(postUri, headers: headers, body: form);

      Uri? uri;

      String data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode == 200) {
        final String respUrl = checkResponse(res);
        uri = Uri.parse(respUrl);
      } else if (res.statusCode == 302) {
        final link = Parser.extractLinkFromHtmlString(data);
        LogService.log('Parsed LINK: $link');

        if (link.isEmpty) throw Exception('Can not find moved link!');

        uri = Uri.parse(link);
        final res = await http.get(uri);
        if (res.statusCode != 200) throw Exception('invalid http status code: ${res.statusCode}');

        // update data
        data = utf8.decode(res.bodyBytes);
        LogService.log('UPDATED DATA => $data');
      } else {
        throw Exception('invalid http status code: ${res.statusCode}');
      }

      final String requestId = uri.queryParameters['request_id'] ?? '';
      if (requestId.isEmpty) throw Exception('"request_id" was not found in url');

      // final String threeDSecureNumber = Parser.extractPhoneNumber(data);
      // if (threeDSecureNumber.isEmpty) throw Exception('"ThreeDSecureNumber" was not found in response');

      LogService.log('END: step2part2SubmitACS');

      return ACSSubmitForm(
        acsSessionUrl: uri.toString(),
        acsRequestId: requestId,
        // threeDSecureNumber: threeDSecureNumber,
      );
    } catch (e) {
      LogService.log('--Exception: step2part2SubmitACS---');
      LogService.log(e);
      LogService.log('-----------------------------------');
      return null;
    }
  }

  Future<int?> step2part3ACSSendPassword(
      String acsRequestId,
      String acsUrl,
      ) async {
    LogService.log('Part 3. ACS Send Password');
    LogService.log('Detected Bank Type: $bankType');

    final uri = bankType == BankType.SenagatBank
        ? Uri.parse('https://epg.senagatbank.com.tm/acs/api/3ds/form/otp')
        : Uri.parse(acsUrl);

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final form = bankType == BankType.SenagatBank
        ? {
      'request_id': acsRequestId,
      'sendButton': 'Ugratmak',
    }: {
      'authForm': 'authForm',
      'request_id': acsRequestId,
      'sendPasswordButton': 'Send password',
    };

    LogService.log('Sending OTP request to: $uri');
    LogService.log(form);

    final res = await http.post(
      uri,
      headers: headers,
      body: form,
    );

    final data = utf8.decode(res.bodyBytes);
    LogService.log('Response received: DATA => $data');

    if (res.statusCode != 200) {
      LogService.log('Invalid HTTP status: ${res.statusCode}');
      return null;
    }

    // Senagat does not expose attempt counter
    if (bankType == BankType.SenagatBank) {
      return 1;
    }

    final left = Parser.extractAttempt(data);
    if (left.isEmpty) return null;

    final parts = left.split(' ');
    final cur = int.parse(parts[1]);
    final total = int.parse(parts[3]);
    return total - cur;
  }

  @override
  Future<ConfirmPaymentResponse> step4ConfirmPayment(ConfirmPaymentRequest req) async {
    LogService.log('BEGIN: step4ConfirmPayment');

    final Map<String, dynamic> info = {
      'app': req.application,
      'id': req.identity,
    };

    LogService.logMap(info);
    LogService.log('Processing');

    // default response
    ConfirmPaymentResponse resp = ConfirmPaymentResponse(status: HackResponseStatus.otherError);

    try {
      final Map<String, dynamic> submitPwdResp = await step4Part1SubmitPassword(req);

      if (submitPwdResp['is_op_canceled']) {
        resp.status = HackResponseStatus.operationCancelled;
        throw Exception('finalUrl is empty');
      } else if (submitPwdResp.containsKey('paRes')) {
        final String finalUrl = await step4Part2CompleteOperation(
          req.mdOrder,
          submitPwdResp['paRes'],
          req.terminateUrl,
        );

        if (finalUrl.isEmpty) throw Exception('finalUrl is empty');

        resp.finalUrl = finalUrl;
      } else {
        resp.status = HackResponseStatus.wrongOTP;
        resp.currentAttempt = submitPwdResp['curAttempt'];
        resp.totalAttempts = submitPwdResp['totalAttempt'];
        throw Exception('Wrong OTP');
      }

      resp.status = HackResponseStatus.ok;

      return resp;
    } catch (e) {
      LogService.log('--Exception: step4ConfirmPayment--');
      LogService.log(e);
      LogService.log('----------------------------------');
      return resp;
    }
  }

  Future<Map<String, dynamic>> step4Part1SubmitPassword(ConfirmPaymentRequest req) async {
    LogService.log('BEGIN: step4Part1SubmitPassword');

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final form = bankType == BankType.SenagatBank
        ? {
      'authForm': 'authForm',
      'request_id': req.acsRequestId,
      'passwordEdit': req.oneTimePassword,
      'submitButton': 'Tassyklamak',
    }: {
      'request_id': req.acsRequestId,
      'authForm': 'authForm',
      'pwdInputVisible': req.oneTimePassword,
      'submitPasswordButton': 'Submit',
    };

    // return response value
    Map<String, dynamic> resp = {
      'is_op_canceled': false,
    };

    try {
      final Uri uri = bankType == BankType.SenagatBank
          ? Uri.parse('https://epg.senagatbank.com.tm/acs/api/3ds/form/otp')
          : Uri.parse(req.acsSessionUrl);

      LogService.log('Submitting OTP to: $uri');
      LogService.log(form);

      final res = await http.post(uri, headers: headers, body: form);

      final data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode != 200) {
        resp['is_op_canceled'] = true;
        throw Exception('wrong password, operation cancelled');
      }

      // RegExp regex = RegExp(Parser.operationCancelledMessage);
      // bool exists = regex.hasMatch(data);
      bool isCanceled = Parser.isOperationCancelled(data);
      if (isCanceled) {
        resp['is_op_canceled'] = true;
        throw Exception('wrong password, operation cancelled');
      }

      // wrong password
      final String wrongAttempt = Parser.extractWrongAttempt(data);
      if (wrongAttempt.isNotEmpty) {
        final strArr = wrongAttempt.split(' ');

        final totalAttempt = int.tryParse(strArr[strArr.length - 1]);
        final curAttempt = int.tryParse(strArr[strArr.length - 3]);

        // update response
        resp['curAttempt'] = curAttempt;
        resp['totalAttempt'] = totalAttempt;

        return resp;
      }

      // paResponse
      final String paRes = Parser.extractPaRes(data);

      if (paRes.isEmpty) throw Exception('can not parse paResponse');

      resp['paRes'] = paRes;

      LogService.log('END: step4Part1SubmitPassword');

      return resp;
    } catch (err) {
      LogService.log('---step4Part1SubmitPassword---');
      LogService.log(err);
      LogService.log('------------------------------');
      return resp;
    }
  }

  Future<String> step4Part2CompleteOperation(String mdOrder, String paResponse, String termUrl) async {
    LogService.log('BEGIN: step4Part2CompleteOperation');

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> form = {
      'MD': mdOrder,
      'PaRes': paResponse,
    };

    try {
      final Uri uri = Uri.parse(termUrl);
      final res = await http.post(uri, headers: headers, body: form);

      LogService.log('Redirecting to temp url: $uri');
      LogService.log(form);

      final data = utf8.decode(res.bodyBytes);
      LogService.log('DATA RECEIVED => $data');

      if (res.statusCode == 200) {
        return checkResponse(res);
      } else if (res.statusCode == 302) {
        final link = Parser.extractLinkFromHtmlString(data);
        LogService.log('Parsed: $link');

        if (link.isEmpty) throw Exception('Can not find moved link!');

        return link;
      } else {
        throw Exception('invalid http status code: ${res.statusCode}');
      }
    } catch (e) {
      LogService.log('---step4Part2CompleteOperation---');
      LogService.log(e);
      LogService.log('---------------------------------');
      return '';
    }
  }
}
