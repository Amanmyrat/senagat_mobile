import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/tmcell_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

class TmcellPaymentScreen extends StatelessWidget {
  static const route = r'/payment/tmcell';

  const TmcellPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TmcellPaymentController>(
      init: TmcellPaymentController(
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        return PaymentFormScaffold(
          controller: controller,
          title: controller.serviceName.tr,
          formChildren: [
            paymentAccountWidget(controller),
            paymentPhoneField(controller),
            paymentSumField(controller),
          ],
          onPayPressed: controller.onTap,
        );
      },
    );
  }
}

