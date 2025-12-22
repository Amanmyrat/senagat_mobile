import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../add_card/model/card_model.dart';
import '../../add_card/presentation/add_card_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../controller/check_phone_balance_controller.dart';

class CheckPhoneBalanceScreen extends StatefulWidget {
  static const route = r'/check_balance';

  const CheckPhoneBalanceScreen({super.key});

  @override
  State<CheckPhoneBalanceScreen> createState() => _CheckPhoneBalanceScreenState();
}

class _CheckPhoneBalanceScreenState extends State<CheckPhoneBalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CheckPhoneBalanceController>(
          init: CheckPhoneBalanceController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomAppBar(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingExtraLarge.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.serviceName.isNotEmpty)
                                      Column(
                                        children: [
                                          Text(
                                            controller.serviceName.tr,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppDimensions.padding40.h,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        r'phone_number'.tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppDimensions
                                            .paddingMedium
                                            .h,
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                              AppDimensions
                                                  .paddingExtraLarge
                                                  .w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .inputFillBackground,
                                              borderRadius:
                                              BorderRadius.circular(
                                                AppDimensions
                                                    .borderRadiusMedium,
                                              ),
                                            ),
                                            child: Text(
                                              '+993',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppDimensions
                                                .paddingSmall
                                                .w,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                              TextInputType.phone,
                                              controller: controller
                                                  .phoneController,
                                              onChanged: (v) =>
                                                  controller
                                                      .isTextNotEmpty(),
                                              focusNode:
                                              controller.phoneFocus,
                                              maxLength: 8,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: AppFonts
                                                    .primaryFont,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                r'enter_number'.tr,
                                                border:
                                                OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    AppDimensions
                                                        .borderRadiusMedium,
                                                  ),
                                                  borderSide:
                                                  BorderSide(
                                                    color: AppColors
                                                        .green,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    AppDimensions
                                                        .borderRadiusMedium,
                                                  ),
                                                  borderSide:
                                                  BorderSide(
                                                    color: AppColors
                                                        .white,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                counter:
                                                const SizedBox(),
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical:
                                                  AppDimensions
                                                      .paddingExtraLarge
                                                      .h,
                                                  horizontal:
                                                  AppDimensions
                                                      .paddingLarge
                                                      .w,
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    Icons.contacts,
                                                    color:
                                                    AppColors.green,
                                                    size: 20.w,
                                                  ),
                                                  onPressed: () async {
                                                    controller
                                                        .contactPicker();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                          opacity: controller.serviceName.isNotEmpty
                              ? controller.continueEnabled
                              ? 1.0
                              : 0.5
                              : 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading:
                              controller.status == Status.loading,
                              isError: controller.status == Status.error,
                              onPressed: () {
                                controller.continueEnabled == false ? null : controller.onTap();
                              },
                              child: Text(
                                r'next'.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

