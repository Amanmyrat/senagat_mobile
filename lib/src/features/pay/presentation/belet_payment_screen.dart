import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/controller/belet_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';

class BeletPaymentScreen extends StatelessWidget {
  static const route = r'/payment/belet';

  const BeletPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeletPaymentController>(
      init: BeletPaymentController(
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        return PaymentFormScaffold(
          controller: controller,
          title: controller.serviceName.tr,
          formChildren: [
            paymentPhoneField(controller),
            if (controller.status != Status.loading) ...[
              _beletTopUpGrid(controller),
              SizedBox(height: 22.h),
              if (controller.isOtherSelected) paymentSumField(controller),
            ],
          ],
          onPayPressed: controller.onTap,
        );
      },
    );
  }

  Widget _beletTopUpGrid(BeletPaymentController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          r'top_up_the_balance'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.blackText,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          itemCount: controller.beletBalances.length + 1, // +1 for Other
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.5,
          ),
          itemBuilder: (context, index) {
            final isOther = index == controller.beletBalances.length;
            final isSelected = isOther
                ? controller.isOtherSelected
                : controller.selectedBeletIndex == index;

            return InkWell(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium.r,
              ),
              onTap: () {
                if (isOther) {
                  controller.isOtherSelected = true;
                  controller.selectedBeletIndex = null;
                  controller.sumController.clear();
                } else {
                  final item = controller.beletBalances[index];
                  controller.selectedBeletIndex = index;
                  controller.isOtherSelected = false;
                  controller.sumController.text = item.value.toString();
                }

                controller.isTextNotEmpty();
                controller.update();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.green
                      : AppColors.inputFillBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusMedium.r,
                  ),
                  border: Border.all(
                    color: isSelected ? AppColors.green : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    isOther
                        ? r'other'.tr
                        : controller.beletBalances[index].title ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.blackText,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

