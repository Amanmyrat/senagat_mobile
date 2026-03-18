import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/dashboard/utils/nested_nav_ids.dart';
import 'package:senagat_mobile/src/features/pay/controller/custom_payment_controller.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/services/bank_service/bank_services.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../add_card/model/card_model.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../home/controller/home_controller.dart';

class ServicePaymentScreen extends StatelessWidget {
  const ServicePaymentScreen({
    super.key,
    required this.orderId,
    required this.paymentUrl,
    required this.selectedCard,
    required this.phoneNumber,
  });

  final String orderId;
  final String paymentUrl;
  final String phoneNumber;
  final CardModel selectedCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: GetBuilder<CustomPaymentController>(
          init: CustomPaymentController(
            orderId: orderId,
            paymentUrl: paymentUrl,
            selectedCard: selectedCard,
            phoneNumber: phoneNumber,
          ),
          builder: (controller) {
            if (controller.status == Status.loading) {
              return _content(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAssets.senagatIcon),
                    SizedBox(height: 22.h),
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text('check_bank'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black, fontFamily: AppFonts.primaryFont,),),
                  ],
                ),
              );
            }

            if(controller.status == Status.success){
              return _content(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAssets.senagatIcon),
                    SizedBox(height: 22.h),
                    SvgPicture.asset(
                      AppAssets.checkIcon,
                      color: AppColors.green,
                      width: 24.w,
                    ),
                    SizedBox(height: AppDimensions.paddingMedium.h),
                    Text(
                      'payment_successful'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          onPressed: () {
                            final homeController = Get.find<HomeController>();
                            final dashboardController = Get.find<DashboardController>();
                            homeController.getUserProfileInfo();
                            homeController.loadHistory();
                            dashboardController.updateCurrentIndex(NestedNavigationIds.home);

                            Get.offAllNamed(DashboardScreen.route);
                          },

                          isError: false,
                          isLoading: false,
                          child: Text(
                            r'home_page'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.status == Status.error) {
              return _content(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppAssets.senagatIcon),
                    SizedBox(height: 22.h),
                    Text(
                      controller.errorMessage ?? 'error_occurred'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.redDark,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          onPressed: () {
                            final homeController = Get.find<HomeController>();
                            final dashboardController = Get.find<DashboardController>();
                            homeController.getUserProfileInfo();
                            homeController.loadHistory();
                            dashboardController.updateCurrentIndex(NestedNavigationIds.home);

                            Get.offAllNamed(DashboardScreen.route);
                            },

                          isError: false,
                          isLoading: false,
                          child: Text(
                            'back'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _content({required Widget child}) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding40.h),
      margin: EdgeInsets.all(AppDimensions.marginExtraLarge.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusExtraLarge.r,
        ),
      ),
      child: child,
    );
  }
}

