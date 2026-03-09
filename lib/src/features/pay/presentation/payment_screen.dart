import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/pay/presentation/astu_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/belet_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/foundation_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/pygg_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/telecom_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/tmcell_payment_screen.dart';

class PaymentScreen extends StatelessWidget {
  static const route = r'/payment';

  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String serviceTitle = '';
    bool isFoundation = false;

    if (args is Map<String, dynamic>) {
      serviceTitle = args['selectedServiceTitle'] as String? ?? '';
      isFoundation = args['isFoundation'] as bool? ?? false;
    }

    if (isFoundation) return const FoundationPaymentScreen();
    if (serviceTitle == 'Belet') return const BeletPaymentScreen();
    if (serviceTitle == 'TM CELL') return const TmcellPaymentScreen();
    if (serviceTitle == 'telecom_internet') return const TelecomPaymentScreen();
    if (serviceTitle == 'pygg_decision' || serviceTitle == 'pygg_video') {
      return const PyggPaymentScreen();
    }

    return const AstuPaymentScreen();
  }
}
