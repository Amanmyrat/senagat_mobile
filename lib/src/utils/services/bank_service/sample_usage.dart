import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:senagat_mobile/src/features/add_card/model/bank_model.dart';
import 'bank_service.dart';
import 'bank_services.dart';
import 'confirm_payment.dart';
import 'resend_code.dart';
import 'start_hack.dart';
import 'submit_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    const String paymentUrl =
        'https://mpi.gov.tm/payment/merchants/online/payment_ru.html?mdOrder=540629ea-b7fb-4670-8ca3-8ec8ed1d0475';

    const String baseMpiUrl = 'https://mpi.gov.tm/payment/rest';

    BankService bankService = BankService(baseMpiUrl: baseMpiUrl, bankType: BankType.AltynAsyrBank);

    final StartHackRequest startHackReq = StartHackRequest(
      application: 'step1',
      identity: 'identity',
      paymentUrl: paymentUrl,
    );

    final step1Resp = await bankService.step1StartHack(startHackReq);

    if (step1Resp.status != HackResponseStatus.ok) {
      /// only [alreadyProcessed] returns in error state
      if (step1Resp.status == HackResponseStatus.alreadyProcessed) {
        if (kDebugMode) {debugPrint('session expired or already processed');}
      }
      return;
    }

    final SubmitCardRequest submitCardReq = SubmitCardRequest(
      application: 'step2',
      identity: 'identity',
      mdOrder: step1Resp.mdOrder ?? '',
      cardNumber: '993********1269',
      expiry: '20****', // YYYYMM
      nameOnCard: 'TESTTEST TEST',
      cvcCode: '***',
    );

    final step2Resp = await bankService.step2SubmitCard(submitCardReq);

    ResendCodeRequest resendCodeReq = ResendCodeRequest(
      application: 'step3',
      identity: 'identity',
      acsRequestId: step2Resp.acsRequestId,
      acsSessionUrl: step2Resp.acsSessionUrl,
    );

    // final resentCodeRes = await bankService.step3ResendCode(resendCodeReq);

    String otp = "12345";

    // show input number dialog

    // if (context.mounted) {
    //   await showDialog(
    //     context: context,
    //     builder: (_) => const InputDialog(),
    //   ).then((value) {
    //     String input = value as String;
    //     otp = input;
    //   });
    // }


    ConfirmPaymentRequest confirmPaymentReq = ConfirmPaymentRequest(
      application: 'step3',
      identity: 'identity',
      mdOrder: step1Resp.mdOrder!,
      acsRequestId: step2Resp.acsRequestId,
      acsSessionUrl: step2Resp.acsSessionUrl,
      oneTimePassword: otp,
      terminateUrl: step2Resp.terminateUrl,
    );

    final confirm = await bankService.step4ConfirmPayment(confirmPaymentReq);

  }

  @override /*  */
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

