import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/controller/inquiries_controller.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
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
                                padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22),
                                child: Align(alignment: Alignment.bottomRight,child:
                                Text('Шаг ${controller.pageIndex} из 4'.tr, style: TextStyle(fontSize: 14.sp), )),
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
                                    r'Выберите тип справки'.tr,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: AppColors.blackText,
                                    ),
                                  ),
                                  SizedBox(height: 16.h,),

                                  SizedBox(height: AppDimensions.paddingMedium,),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: AppColors.inputFillBackground,
                                      cardTheme:  CardThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(AppDimensions.borderRadiusMedium.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: controller.selectedDropdownType,
                                      hint: Text(
                                        r"Тип справки".tr,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      icon: SvgPicture.asset(
                                        AppAssets.caretDownIcon,
                                        width: 18.w,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingExtraLarge.h,
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
                                  ),

                                  if(controller.continueEnabled)
                                    Column(
                                      children: [
                                        SizedBox(height: 16.h,),
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppAssets.infoIcon,width: 18.w, color: AppColors.green,),
                                            SizedBox(width: 6.h,),
                                            Expanded(
                                              child: Text(r'Подтвердить, что у вас есть учетная запись, личный кабинет или он закрыт'.tr,
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
                                  r'Данные паспорта'.tr,
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
                                      return  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(controller.textFieldTitle[index], style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                          SizedBox(height: AppDimensions.paddingMedium.h,),
                                          TextFormField(
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.name,
                                            controller: controller.controllers[index],
                                            onChanged:(v) => controller.onTextIsNotEmpty(v),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: controller.textFieldTitle[index],
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
                                Text(r'Место выдачи'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium,),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: AppColors.inputFillBackground,
                                    cardTheme:  CardThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(AppDimensions.borderRadiusMedium.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.selectedDropdownCity,
                                    hint: Text(r"Место выдачи".tr, style: TextStyle(
                                      fontSize: 14.sp,),
                                    ),
                                    icon: SvgPicture.asset(
                                      AppAssets.caretDownIcon,
                                      width: 18.w,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.paddingExtraLarge.h,
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
                                  r'Информация для справки'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                Text(r'Филиал банка'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium,),

                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: AppColors.inputFillBackground,
                                    cardTheme:  CardThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(AppDimensions.borderRadiusMedium.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: controller.selectedDropdownBranch,
                                    hint: Text(r"Филиал банка".tr, style: TextStyle(
                                      fontSize: 14.sp,),
                                    ),

                                    icon: SvgPicture.asset(
                                      AppAssets.caretDownIcon,
                                      width: 18.w,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.paddingExtraLarge.h,
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
                                ),

                                SizedBox(height: 22.h,),


                                Text(r'Домашний адрес'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                    hintText: r'Домашний адрес'.tr,
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
                          child: Text(r'Далее'.tr),
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
