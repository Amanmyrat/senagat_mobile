import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/phone_pay/controller/pay_controller.dart';
import 'package:senagat_mobile/src/features/phone_pay_verification/presentation/pay_verification_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class PayScreen extends StatefulWidget {
  static const route = r'/phone/pay';

  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PayController>(
          init: PayController(_key),
          builder: (controller) {
            return Column(
              children: [
                CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                      ),
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.serviceName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: AppDimensions.padding40.h,),
                            Text(
                              r'Выберите карту'.tr,
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: 16.h,),
                            Container(
                              padding: EdgeInsets.all(
                                AppDimensions.paddingExtraLarge,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.cardImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Senagat Bank',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                  Row(
                                    children: [
                                      Text(
                                        'xxxx',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                      Text(
                                        '0689',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: AppDimensions.padding40.h,),

                            Text(r'Номер телефона'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                            SizedBox(height: AppDimensions.paddingMedium.h,),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.paddingExtraLarge.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFillBackground,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                  ),
                                  child: Text(
                                    '+993',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                                SizedBox(width: AppDimensions.paddingSmall.w),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: controller.phoneController,
                                    onChanged: (v)=> controller.isTextNotEmpty(),
                                    focusNode: controller.phoneFocus,
                                    maxLength: 8,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.primaryFont,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: r'enter_number'.tr,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.green,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.white,
                                          width: 1,
                                        ),
                                      ),
                                      counter: const SizedBox(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingExtraLarge.h,
                                        horizontal: AppDimensions.paddingLarge.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if(controller.serviceIcon.isEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 22.h,),

                                  Text(r'Имя'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                  SizedBox(height: AppDimensions.paddingMedium.h,),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: controller.nameController,
                                    onChanged: (value) => controller.isTextNotEmpty(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.primaryFont,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: r'enter_name'.tr,
                                      border: OutlineInputBorder(),
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
                                          width: 1,
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
                              ),

                            SizedBox(height: AppDimensions.padding40.h,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r'Сумма'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: controller.sumController,
                                  onChanged: (value) => controller.isTextNotEmpty(),
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontFamily: AppFonts.primaryFont,
                                    color: AppColors.blackText
                                  ),
                                  decoration: InputDecoration(
                                    hintText: r'Введите сумму'.tr,
                                    fillColor: AppColors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        strokeAlign: BorderSide.strokeAlignOutside,
                                        color: AppColors.green,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        strokeAlign: BorderSide.strokeAlignOutside,
                                        color: AppColors.dividerColor,
                                        width: 1,
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
                            ),
                            SizedBox(width: AppDimensions.paddingMedium.h,),

                          ],
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                  child: Opacity(
                    opacity: controller.continueEnabled ? 1.0 : 0.5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonWithState(
                        isLoading: controller.status == Status.loading,
                        isError: controller.status == Status.error,
                        onPressed:() {

                         controller.continueEnabled == false ?null:controller.onPayTap();
                          },
                        child: Text(r'send_code'.tr),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
