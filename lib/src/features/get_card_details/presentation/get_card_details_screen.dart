import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/get_card_details/controller/get_card_details_controller.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';

class GetCardDetailsScreen extends StatefulWidget {
  static const route = '/get/card/details';
  const GetCardDetailsScreen({super.key});

  @override
  State<GetCardDetailsScreen> createState() => _GetCardDetailsScreenState();
}

class _GetCardDetailsScreenState extends State<GetCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<GetCardDetailsController>(
            init: GetCardDetailsController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text('step_of_5'.trParams({'page': controller.pageIndex.toString()}), style: TextStyle(fontSize: 14.sp), )),
                      ),
                    ],
                  ),
                  if(controller.pageIndex == 1)
                    Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.selectedCard ?? '',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: 16.h,),
                            Image.asset(AppAssets.paymentCardImage),
                            SizedBox(height: AppDimensions.padding40.h,),
                            Text(
                              r'Details_for_obtaining'.tr,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: 32.h,),
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
                            SizedBox(height: 22.h,),
                            Text(r'Bank_branch'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                            SizedBox(height: AppDimensions.paddingMedium,),

                            DropdownButtonFormField2<String>(
                              value: controller.selectedDropdownBranch,
                              hint: Text(r"Bank_branch".tr, style: TextStyle(
                                fontSize: 14.sp,),
                              ),

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(AppDimensions.paddingMedium.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                elevation: 2,

                              ),
                              iconStyleData: IconStyleData(
                                icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18,),
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


                            Text(r'Home_phone_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                            SizedBox(height: AppDimensions.paddingMedium.h,),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: controller.addressController,
                              onChanged:(v) => controller.onInformationNotEmpty(v),
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




                          ],
                        ),
                      ),
                    ),
                  ),
                  if(controller.pageIndex == 2)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r'Passport_details'.tr,
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
                              Text(r'Place_of_issue'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                child: DropdownButtonFormField2<String>(
                                  value: controller.selectedDropdownIssuance,
                                  hint: Text(r"Place_of_issue".tr, style: TextStyle(
                                    fontSize: 14.sp,),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(AppDimensions.paddingMedium.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),

                                    ),
                                    elevation: 2,

                                  ),

                                  iconStyleData: IconStyleData(
                                    icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18,),
                                  ),
                                  onChanged:(v) => controller.setDropdownIssuance(v),
                                  items: controller.issuanceSelection
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
          )
      ),

    );
  }
}
