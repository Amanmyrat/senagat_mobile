import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/card_detials/presentation/card_details_screen.dart';
import 'package:senagat_mobile/src/features/card_settings/controller/card_settings_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../widgets/elevated_button_with_state.dart';
import '../../delete_card/presentation/delete_card_screen.dart';

class CardSettingsScreen extends StatefulWidget {
  static const route = '/card_settings';

  const CardSettingsScreen({super.key});

  @override
  State<CardSettingsScreen> createState() => _CardSettingsScreenState();
}

class _CardSettingsScreenState extends State<CardSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CardSettingsController>(
          init: CardSettingsController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r'setting'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                          Container(
                            width: 90.w,
                            height: 58.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                              image: DecorationImage(image: AssetImage(controller.cardDesign,),fit: BoxFit.fill)
                            ),

                          ),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.nickName, style: TextStyle(color: AppColors.greyInactive, fontSize: 14.sp),),
                              Text(controller.maskedNumber, style: TextStyle(color: AppColors.greyInactive, fontSize: 14.sp),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 16.h,),

                      Container(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium.r,
                          ),
                          border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dividerColor,
                              blurRadius: 4.r,
                            ),
                          ],
                          color: AppColors.white,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:(){
                                Get.toNamed(CardDetailsScreen.route, arguments: {'index': controller.index});
                              },
                              child: Container(
                                color: AppColors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppAssets.navigationCreditCardIcon, width: 24.w, color: AppColors.green,),
                                        SizedBox(width: 10.w,),
                                        Text(r'card_details'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp, fontFamily: AppFonts.secondaryFont),),
                                      ],
                                    ),
                                    SvgPicture.asset(AppAssets.arrowRightIcon, width: 16.w,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 26.h,),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                    context: context,
                                    builder: (_){
                                      return GetBuilder<CardSettingsController>(
                                        init: CardSettingsController(),
                                        builder: (controller) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom,
                                            ),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width,
                                              child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(r'card_name'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                                                    SizedBox(height: 22.h,),
                                                    TextField(
                                                      keyboardType: TextInputType.name,
                                                      textInputAction: TextInputAction.done,
                                                      controller: controller.cardNumberController,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontFamily: AppFonts.primaryFont,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'card_name'.tr,
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
                                                            controller.onClearText();
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
                                                    (controller.status != Status.loading) ?
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: ElevatedButtonWithState(
                                                        isLoading: false,
                                                        isError: false,
                                                        onPressed: (){
                                                          controller.onChangeNickName();
                                                        },
                                                        child: Text(r'confirm'.tr, style: TextStyle(color: AppColors.white, fontSize: 14.sp),),
                                                        ),
                                                      ):
                                                    (controller.status == Status.loading)?
                                                      SizedBox(
                                                          width: 24.w,
                                                          height: 24.h,
                                                          child: CircularProgressIndicator(color: AppColors.green,)):
                                                      SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      );
                                });
                              },
                              child: Container(
                                color: AppColors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppAssets.edit, width: 24.w,),
                                        SizedBox(width: 10.w,),
                                        Text(r'card_name'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp,fontFamily: AppFonts.secondaryFont),),
                                      ],
                                    ),
                                    SvgPicture.asset(AppAssets.arrowRightIcon, width: 16.w,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h,),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(DeleteCardScreen.route, arguments: {'index': controller.index});
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium.r,
                            ),
                            border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dividerColor,
                                blurRadius: 4.r,
                              ),
                            ],
                            color: AppColors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.trash, width: 24.w,),
                                  SizedBox(width: 10.w,),
                                  Text(r'remove_card'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp,fontFamily: AppFonts.secondaryFont),),
                                ],
                              ),
                              SvgPicture.asset(AppAssets.arrowRightIcon, width: 16.w,)
                            ],
                          ),
                        ),
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
