import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/loan/controller/loan_controller.dart';

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
                        Text(widget.controller.textFieldTitle[index], style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                        SizedBox(height: AppDimensions.paddingMedium.h,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: widget.controller.controllers[index],
                          onChanged:(v) => widget.controller.onTextIsNotEmpty(v),
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.controller.textFieldTitle[index],
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
                  value: widget.controller.selectedDropdownIssuance,
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
