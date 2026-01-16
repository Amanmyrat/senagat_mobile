import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/controller/custom_payment_controller.dart';
import 'package:senagat_mobile/src/utils/services/bank_service/bank_services.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';

import '../../add_card/model/card_model.dart';

class ServicePaymentScreen extends StatefulWidget {

  static const route = '/service/payment';

  const ServicePaymentScreen({
    super.key,
    required this.orderId,
    required this.paymentUrl,
    required this.selectedCard,
  });

  final String orderId;
  final String paymentUrl;
  final CardModel selectedCard;

  @override
  State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(r'payment_processing'.tr),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
      ),
      body: GetBuilder<CustomPaymentController>(
        init: CustomPaymentController(
          orderId: widget.orderId,
          paymentUrl: widget.paymentUrl,
          selectedCard: widget.selectedCard
        ),
        builder: (controller) {
          if (controller.status == Status.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing payment...'),
                ],
              ),
            );
          }

          if (controller.status == Status.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage ?? r'error_occurred'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text(r'go_back'.tr),
                  ),
                ],
              ),
            );
          }

          // This should not be reached as the controller handles navigation
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
