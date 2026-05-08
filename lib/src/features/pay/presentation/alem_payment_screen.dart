import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/alem_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

class AlemPaymentScreen extends StatelessWidget {
  static const route = r'/payment/alemTV';

  AlemPaymentScreen({super.key});

  final AlemPaymentController controller = Get.put(
    AlemPaymentController(
      PaymentRepository(apiService: ApiServices.apiService),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PaymentFormScaffold(
      controller: controller,
      title: controller.serviceName.tr,
      formChildren: [

        GetBuilder<AlemPaymentController>(
          id: 'alem_status',
          init: controller,
          global: false,
          builder: (_) {
            if(controller.tariff != null){

            return alemStatusWidget(controller);
            }
            return const SizedBox();

          },
        ),

        alemPaymentField(controller),

        GetBuilder<AlemPaymentController>(
          id: 'tariff_picker',
          init: controller,
          global: false,
          builder: (_) {
            if (controller.tariff != null &&
                controller.tariff!.paymentOptions.isNotEmpty) {
              return alemTariffPicker(controller);
            }

            return const SizedBox();
          },
        ),
      ],
      onPayPressed: controller.onTap,
    );
  }
}
