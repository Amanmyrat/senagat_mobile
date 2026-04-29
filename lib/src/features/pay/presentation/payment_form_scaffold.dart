import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_form_widgets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/check_widget.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:senagat_mobile/src/widgets/elevated_button_with_state.dart';

class PaymentFormScaffold extends StatelessWidget {
  const PaymentFormScaffold({
    super.key,
    required this.controller,
    required this.title,
    required this.formChildren,
    required this.onPayPressed,
  });

  final PaymentController controller;
  final String title;
  final List<Widget> formChildren;
  final VoidCallback onPayPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  controller.status == Status.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.green,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CustomAppBar(),
                                        if (controller.serviceName.isEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: AppDimensions
                                                  .paddingExtraLarge,
                                              top: 22.h,
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                'step_5_of_5'.tr,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppDimensions.paddingExtraLarge.w,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                AppDimensions.padding40.h,
                                          ),
                                          ...formChildren,
                                          SizedBox(
                                            height:
                                                AppDimensions.paddingExtraLarge
                                                    .h,
                                          ),
                                          Text(
                                            r'select_a_card'.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          paymentCardPicker(controller),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                AppDimensions.paddingExtraLarge.w,
                              ),
                              child: Opacity(
                                opacity: controller.continueEnabled ? 1.0 : 0.5,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButtonWithState(
                                    isLoading:
                                        controller.status == Status.loading,
                                    isError: controller.status == Status.error,
                                    onPressed: controller.continueEnabled
                                        ? onPayPressed
                                        : null,
                                    child: Text(
                                      r'pay'.tr,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.white,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  if (controller.check == true)
                    CheckWidget(
                      isLoading: controller.status == Status.loading,
                      isTitle: false,
                      route: DashboardScreen.route,
                      buttonTitle: r'home_page'.tr,
                      successTitle: 'payment_was_successful',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

