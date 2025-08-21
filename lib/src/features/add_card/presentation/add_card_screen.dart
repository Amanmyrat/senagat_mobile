import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/check_widget.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class AddCardScreen extends StatefulWidget {
  static const route = r'/add/card';

  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AddCardController>(
          init: AddCardController(),
          builder: (controller) {
            return Stack(
              children: [
                Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                              child: Text(
                                r'choose_a_design'.tr,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: AppColors.blackText,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h,),
                            SizedBox(
                              height: 240.h,
                              child: PageView.builder(
                                controller: controller.pageController,
                                itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                return Container(
                                  height: 220.h,
                                  padding: EdgeInsets.all(
                                    AppDimensions.paddingExtraLarge,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                   horizontal: AppDimensions.marginMedium,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                                    image: DecorationImage(
                                        image: AssetImage(controller.cardDesigns[index]),
                                        fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Senagat Bank',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 72.h,),

                                      Text(
                                        controller.maskedCardNumber,
                                        style: TextStyle(
                                          wordSpacing: 10.sp,
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 41.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.nameController.text.isNotEmpty ? controller.nameController.text : r'name_on_the_card'.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          Text(
                                            controller.termController.text.isNotEmpty ? controller.termController.text : r'term'.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: AppDimensions.paddingMedium.h,),

                            Center(
                              child: SmoothPageIndicator(
                                count: 4,
                                controller: controller.pageController,
                                effect: WormEffect(
                                  dotHeight: 10.h,
                                  dotWidth: 10.w,
                                  spacing: 4,
                                  activeDotColor: AppColors.green,
                                  dotColor: AppColors.green.withOpacity(0.5)
                                ),
                              ),
                            ),
                            SizedBox(height: 26.h,),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r'card_details'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 24.sp),),
                                  SizedBox(height: 32.h,),
                                  Text(r'card_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                  SizedBox(height: AppDimensions.paddingMedium.h,),
                                  TextField(
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    onChanged: controller.onTextChanged,
                                    controller: controller.cardNumberController,
                                    inputFormatters: [controller.cardNumberFormatter],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.primaryFont,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: r'card_number'.tr,
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
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 40.h,
                                        maxWidth: 40.w,
                                      ),
                                      suffixIcon:  controller.cardNumberController.text.isNotEmpty ?
                                      GestureDetector(
                                        onTap: (){
                                          controller.onClearTextField(controller.cardNumberController);
                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.only(right: AppDimensions.paddingExtraLarge.w),
                                          child: SvgPicture.asset(AppAssets.deleteIcon, width: 18.w, color: AppColors.black,),
                                        ),
                                      ) : null,
                                      counter: const SizedBox(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingExtraLarge.h,
                                        horizontal: AppDimensions.paddingLarge.w,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 22.h,),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 190.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(r'name_on_the_card'.tr,
                                                style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp),
                                              ),
                                              SizedBox(height: AppDimensions.paddingMedium.h,),
                                              TextField(
                                                keyboardType: TextInputType.text,
                                                controller: controller.nameController,
                                                onChanged: (value) => controller.update(),
                                                textInputAction: TextInputAction.next,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: AppFonts.primaryFont,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: r'name_on_the_card'.tr,
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
                                                  suffixIconConstraints: BoxConstraints(
                                                    maxHeight: 40.h,
                                                    maxWidth: 40.w,
                                                  ),
                                                  suffixIcon:  controller.nameController.text.isNotEmpty ?
                                                  GestureDetector(
                                                    onTap: (){
                                                      controller.onClearTextField(controller.nameController);
                                                    },
                                                    child: Padding(
                                                      padding:  EdgeInsets.only(right: AppDimensions.paddingExtraLarge.w),
                                                      child: SvgPicture.asset(AppAssets.deleteIcon, width: 18.w, color: AppColors.black,),
                                                    ),
                                                  ) : null,
                                                  counter: const SizedBox(),
                                                  contentPadding: EdgeInsets.symmetric(
                                                    vertical: AppDimensions.paddingExtraLarge.h,
                                                    horizontal: AppDimensions.paddingLarge.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: AppDimensions.paddingMedium.h,),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(r'term'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                              SizedBox(height: AppDimensions.paddingMedium.h,),
                                              TextField(
                                                controller: controller.termController,
                                                onChanged: controller.onTextChanged,
                                                keyboardType: TextInputType.phone,
                                                maxLength: 5,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [controller.termFormatter],
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: AppFonts.primaryFont,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: r'term'.tr,
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
                                        ),
                                        SizedBox(width: AppDimensions.paddingMedium.h,),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 25.h,),
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                controller: controller.cvcController,
                                                onChanged: controller.onTextChanged,
                                                maxLength: 3,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: AppFonts.primaryFont,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: r'CVC'.tr,
                                                  hintStyle: TextStyle(color: AppColors.blackText,),
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
                                                  suffixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                                                  suffixIcon: Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: SvgPicture.asset(AppAssets.infoIcon, width: 18.w,),
                                                  ),
                                                  counter: const SizedBox(),
                                                  contentPadding: EdgeInsets.only(
                                                    top: AppDimensions.paddingExtraLarge.h,
                                                    bottom: AppDimensions.paddingExtraLarge.h,
                                                    left: AppDimensions.paddingMedium.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                  ),
                  Opacity(
                    opacity: controller.continueEnabled ? 1.0 : 0.5,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          isLoading: false,
                          isError: false,
                          onPressed: (){
                              controller.startBankVerification();
                          },
                          child: Text(r'confirm'.tr),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                  if(controller.check)
                    CheckWidget(isLoading: controller.status == Status.loading, isTitle: true, route: DashboardScreen.route,),
              ]
            );
          }
        ),
      ),
    );
  }
}
