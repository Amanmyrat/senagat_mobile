import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/alem_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

class AlemPaymentScreen extends StatelessWidget {
  static const route = r'/payment/alemTV';

  const AlemPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlemPaymentController>(
      init: AlemPaymentController(
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        return PaymentFormScaffold(
          controller: controller,
          title: controller.serviceName.tr,
          formChildren: [
            alemPaymentField(controller)
          ],
          onPayPressed: controller.onTap,
        );
      },
    );
  }
}

