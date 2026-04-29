import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/pygg_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

class PyggPaymentScreen extends StatelessWidget {
  static const route = r'/payment/pygg';

  const PyggPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PyggPaymentController>(
      init: PyggPaymentController(
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        final isVideo = controller.serviceName == 'pygg_video';
        final isDecision = controller.serviceName == 'pygg_decision';

        return PaymentFormScaffold(
          controller: controller,
          title: controller.serviceName.tr,
          formChildren: [
            paymentAccountWidget(controller),
            paymentPhoneField(controller),
            if (isVideo) pyggVideoFields(controller),
            if (isDecision) pyggDecisionFields(controller),
            paymentSumField(controller),
          ],
          onPayPressed: controller.onTap,
        );
      },
    );
  }
}

