import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../../dashboard/presentation/dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const route = r'/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PaymentController>(
          init: PaymentController(_key),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomAppBar(),
                              if(controller.serviceName.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22),
                                  child: Align(alignment: Alignment.bottomRight,child:
                                  Text('Шаг 5 из 5'.tr, style: TextStyle(fontSize: 14.sp), )),
                                ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingExtraLarge.w,
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      if(controller.serviceName.isNotEmpty)
                                        Column(
                                          children: [
                                            Text(
                                              controller.serviceName,
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                color: AppColors.blackText,
                                              ),
                                            ),
                                            SizedBox(height: AppDimensions.padding40.h,),
                                          ],
                                        ),
                                      Text(
                                        r'select_a_card'.tr,
                                        style: TextStyle(
                                          fontSize: controller.serviceName.isNotEmpty ? 17.sp : 24.sp,
                                          color: AppColors.blackText,
                                        ),
                                      ),
                                      SizedBox(height: 16.h,),
                                      Container(
                                        padding: EdgeInsets.all( AppDimensions.paddingExtraLarge, ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          image: DecorationImage(
                                            image: AssetImage(AppAssets.cardImage),
                                            fit: BoxFit.cover, ), ),
                                        child: Column( children: [
                                          Align( alignment: Alignment.topLeft,
                                            child: Text( 'Senagat Bank', style:
                                            TextStyle( color: AppColors.white, fontSize: 14, ),
                                            ),
                                          ),
                                          SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                          Row( children: [
                                            Text( 'xxxx', style: TextStyle( fontSize: 24.sp, color: AppColors.white, ),
                                            ),
                                            SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                            Text( '0689', style: TextStyle( fontSize: 24.sp, color: AppColors.white, ),
                                            ),
                                            SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                          ],),
                                        ],),
                                      ),
                                      SizedBox(height: AppDimensions.padding40.h,),
                                      if(controller.serviceName.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(r'phone_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                ),
                                              ],
                                            ),
                                            if(controller.serviceIcon.isEmpty)
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 22.h,),

                                                  Text(r'name'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                              ),

                                            SizedBox(height: AppDimensions.padding40.h,),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(r'sum'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                    hintText: r'enter_sum'.tr,
                                                    fillColor: AppColors.white,
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        strokeAlign: BorderSide.strokeAlignOutside,
                                                        color: AppColors.green,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        strokeAlign: BorderSide.strokeAlignOutside,
                                                        color: AppColors.dividerColor,
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
                                            ),
                                            SizedBox(width: AppDimensions.paddingMedium.h,),
                                          ],
                                        ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                            child: Opacity(
                              opacity: controller.serviceName.isNotEmpty? controller.continueEnabled ? 1.0 : 0.5 : 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButtonWithState(
                                  isLoading: controller.status == Status.loading,
                                  isError: controller.status == Status.error,
                                  onPressed:() {
                                    if(controller.serviceName.isNotEmpty){
                                      controller.continueEnabled == false ? null: controller.onPayTap();
                                    }else{
                                      controller.startBankVerification();
                                    }
                                   },
                                  child: Text(r'send_code'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(controller.check == true)
                        CheckWidget(isLoading: controller.status == Status.loading,
                          isTitle: false, route: DashboardScreen.route,
                          buttonTitle: r'home_page'.tr,
                        ),
                    ],
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
