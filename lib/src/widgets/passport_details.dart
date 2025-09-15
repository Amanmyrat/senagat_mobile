import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/loan/controller/loan_controller.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';

class PassportDetails extends StatefulWidget {

  final LoanController controller;

  const PassportDetails({super.key, required this.controller});

  @override
  State<PassportDetails> createState() => _PassportDetailsState();
}

class _PassportDetailsState extends State<PassportDetails> {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SingleChildScrollView(
        child: Padding(
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
                    if(widget.controller.controllers[index] == widget.controller.passportNumberController){
                      return Padding(
                        padding: EdgeInsets.only(bottom: 22.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.controller.textFieldTitle[index].tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                            SizedBox(height: AppDimensions.paddingMedium.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 72.w,
                                  height: 62.h,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    controller: widget.controller.asController,
                                    onChanged:(v) => widget.controller.onTextIsNotEmpty(v),
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
                                    controller: widget.controller.passportNumberController,
                                    onChanged:(v) => widget.controller.onTextIsNotEmpty(v),
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
                        Text(widget.controller.textFieldTitle[index].tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                        SizedBox(height: AppDimensions.paddingMedium.h,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: (index == widget.controller.controllers.length - 2 ||
                              index == widget.controller.controllers.length - 4)
                              ? TextInputType.number
                              : TextInputType.name,
                          controller: widget.controller.controllers[index],
                          onChanged:(v) => widget.controller.onTextIsNotEmpty(v),
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.controller.textFieldTitle[index].tr,
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
                  value: widget.controller.selectedDropdownIssuance,
                  hint: Text(r"place_of_issue".tr, style: TextStyle(
                    fontSize: 14.sp, color: AppColors.greyInactive, fontFamily: AppFonts.primaryFont),
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
                  onChanged:(v) => widget.controller.setDropdownIssuance(v),
                  items: widget.controller.issuanceSelection
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
    );
  }
}
