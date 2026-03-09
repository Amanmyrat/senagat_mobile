import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/foundation_payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_scaffold.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

class FoundationPaymentScreen extends StatelessWidget {
  static const route = r'/payment/foundation';

  const FoundationPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoundationPaymentController>(
      init: FoundationPaymentController(
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        return PaymentFormScaffold(
          controller: controller,
          title: controller.serviceName.tr,
          formChildren: [
            paymentPhoneField(controller),
            _nameField(
              labelKey: r'name',
              controller: controller.nameController,
              onChanged: controller.isTextNotEmpty,
            ),
            SizedBox(height: 22.h),
            _nameField(
              labelKey: r'last_name',
              controller: controller.lastnameController,
              onChanged: controller.isTextNotEmpty,
            ),
            SizedBox(height: 22.h),
            paymentSumField(controller),
          ],
          onPayPressed: controller.onTap,
        );
      },
    );
  }

  Widget _nameField({
    required String labelKey,
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelKey.tr,
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),
        TextFormField(
          keyboardType: TextInputType.name,
          controller: controller,
          onChanged: (_) => onChanged(),
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: AppFonts.primaryFont,
          ),
          decoration: InputDecoration(
            hintText: labelKey.tr,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
              borderSide: BorderSide(
                color: AppColors.green,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
              borderSide: BorderSide(
                color: AppColors.white,
                width: 1.w,
              ),
            ),
            counter: const SizedBox(),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingExtraLarge.h,
              horizontal: AppDimensions.paddingLarge.w,
            ),
          ),
        ),
      ],
    );
  }
}

