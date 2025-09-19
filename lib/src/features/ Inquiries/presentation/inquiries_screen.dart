import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/controller/inquiries_controller.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class InquiriesScreen extends StatefulWidget {
  static const route = '/inquiries';
  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<InquiriesController>(
          init: InquiriesController(),
          builder: (controller) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  controller.onBack();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                                  margin: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: AppColors.greyInactive,
                                        width: 1.w,
                                        style: BorderStyle.solid,
                                      ),
                                      color: AppColors.white
                                  ),
                                  child: SvgPicture.asset(AppAssets.arrowLeftIcon, width: 20.w),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22.h),
                                child: Align(alignment: Alignment.bottomRight,child:
                                Text('step_of_5'.trParams({'page': controller.pageIndex.toString()}), style: TextStyle(fontSize: 14.sp), )),
                              ),
                            ],
                          ),
                          if(controller.pageIndex == 1)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r'select_the_type_of_certificate'.tr,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: AppColors.blackText,
                                    ),
                                  ),
                                  SizedBox(height: 16.h,),

                                  SizedBox(height: AppDimensions.paddingMedium,),
                                  DropdownButtonFormField2<String>(
                                      value: controller.selectedDropdownType,
                                      hint: Text(
                                        r"type_of_certificate".tr,
                                        style: TextStyle(fontSize: 14.sp, color: AppColors.greyInactive),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(0, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),

                                        ),
                                        elevation: 2,

                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w,),
                                      ),
                                      onChanged: (v) => controller.setDropdownType(v),
                                      items: controller.typeSelection
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),

                                  if(controller.continueEnabled)
                                    Column(
                                      children: [
                                        SizedBox(height: 16.h,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(AppAssets.infoIcon,width: 18.w, color: AppColors.green,),
                                            SizedBox(width: 6.h,),
                                            Expanded(
                                              child: Text(r'confirm_that_you_have_an_account'.tr,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: AppColors.blackText,
                                                    fontFamily: AppFonts.secondaryFont
                                                ),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          if(controller.pageIndex == 2)
                            Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r'passport_details'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                ListView.builder(
                                    itemCount: 6,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      if(controller.controllers[index] == controller.passportNumberController){
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 22.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(controller.textFieldTitle[index].tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                              SizedBox(height: AppDimensions.paddingMedium.h,),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 72.w,
                                                    height: 62.h,
                                                    child: TextFormField(
                                                      textAlign: TextAlign.center,
                                                      textInputAction: TextInputAction.next,
                                                      keyboardType: TextInputType.text,
                                                      maxLength: 2,
                                                      controller: controller.asController,
                                                      onChanged:(v) => controller.onTextIsNotEmpty(v),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'AS',
                                                        hintStyle: TextStyle(color: AppColors.black, fontSize: 14.sp),
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
                                                  SizedBox(width: 4.sp,),
                                                  Expanded(
                                                    child: TextFormField(
                                                      textInputAction: TextInputAction.next,
                                                      keyboardType: TextInputType.number,
                                                      maxLength: 7,
                                                      controller: controller.passportNumberController,
                                                      onChanged:(v) => controller.onTextIsNotEmpty(v),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'passport_number'.tr,
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
                                            ],
                                          ),
                                        );
                                      }
                                      return  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(controller.textFieldTitle[index].tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                          SizedBox(height: AppDimensions.paddingMedium.h,),
                                          TextFormField(
                                            textInputAction: TextInputAction.next,
                                            keyboardType: (index == controller.controllers.length - 2 ||
                                                index == controller.controllers.length - 4)
                                                ? TextInputType.number
                                                : TextInputType.name,
                                            controller: controller.controllers[index],
                                            inputFormatters: [?controller.controllers[index] == controller.dateOfBirthController ? controller.dateOfBirthFormatter : null],
                                            onChanged:(v) => controller.onTextIsNotEmpty(v),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: controller.textFieldTitle[index].tr,
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
                                          SizedBox(height: 22.h,),
                                        ],
                                      );
                                    }
                                ),
                                Text(r'place_of_issue'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium,),
                                DropdownButtonFormField2<String>(
                                    value: controller.selectedDropdownCity,
                                    hint: Text(r"place_of_issue".tr, style: TextStyle(
                                      fontSize: 14.sp, color: AppColors.grey, fontFamily: AppFonts.primaryFont),
                                    ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(0, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),

                                    ),
                                    elevation: 2,

                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w,),
                                  ),
                                    onChanged:(v) => controller.setDropdownCity(v),
                                    items: controller.citySelection
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item, style: TextStyle(
                                          fontSize: 14.sp,
                                        ),),
                                      ),
                                    )
                                        .toList(),
                                  ),

                                SizedBox(height: AppDimensions.padding30,),
                              ],
                            ),
                          ),
                          if(controller.pageIndex == 3)
                            Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r'information_for_reference'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                Text(r'bank_branch'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium,),

                                DropdownButtonFormField2<String>(
                                    value: controller.selectedDropdownBranch,
                                    hint: Text(r"bank_branch".tr, style: TextStyle(
                                      fontSize: 14.sp, fontFamily: AppFonts.primaryFont, color: AppColors.greyInactive),
                                    ),

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(0, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),

                                      ),
                                      elevation: 2,

                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w,),
                                    ),
                                    onChanged: (v) => controller.setDropdownBranch(v),
                                    items: controller.branchSelection
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item, style: TextStyle(
                                          fontSize: 14.sp,
                                        ),),
                                      ),
                                    ).toList(),
                                  ),

                                SizedBox(height: 22.h,),


                                Text(r'home_address'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium.h,),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  controller: controller.addressController,
                                  onChanged:(v) => controller.onInformationNotEmpty(v),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: r'home_address'.tr,
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

                                SizedBox(height: 22.h,),

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
                                        onChanged:(v) => controller.onInformationNotEmpty(v),
                                        maxLength: 8,
                                        style: TextStyle(
                                          fontSize: 14.sp,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  Opacity(
                    opacity: controller.continueEnabled ? 1 : 0.5,
                    child: Padding(
                      padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          isLoading: controller.status == Status.loading,
                          isError: controller.status == Status.error,
                          onPressed:() {
                            controller.onTap();
                          },
                          child: Text(r'next'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
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
