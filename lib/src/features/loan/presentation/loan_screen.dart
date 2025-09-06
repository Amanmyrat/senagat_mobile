import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/passport_details.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../controller/loan_controller.dart';

class LoanScreen extends StatefulWidget {
  static const route = '/loan';
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<LoanController>(
            init: LoanController(),
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
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
                                  Text('step_of_3'.trParams({'page':controller.pageIndex.toString()}), style: TextStyle(fontSize: 14.sp), )),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  if(controller.pageIndex == 1)
                                    PassportDetails(controller: controller,),
                                  if(controller.pageIndex == 2)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'Job_information'.tr,
                                                  style: TextStyle(
                                                    fontSize: 24.sp,
                                                    color: AppColors.blackText,
                                                  ),
                                                ),
                                                SizedBox(height: 16.h,),
                    
                                              ],
                                            ),
                                          ),
                    
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 42.h,
                                                  margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                      AppDimensions.borderRadiusMedium.r,
                                                    ),
                                                    color: AppColors.lightGreen,
                                                  ),
                                                  child: TabBar(
                                                    controller: controller.tabController,
                                                    dividerHeight: 0,
                                                    labelColor: AppColors.white,
                                                    unselectedLabelColor: AppColors.white,
                                                    labelStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont,),
                                                    indicatorSize: TabBarIndicatorSize.tab,
                                                    indicator: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                          AppDimensions.borderRadiusMedium.r,
                                                        ),
                                                        color: AppColors.blackText
                                                    ),
                                                    tabs: [
                                                      Tab(text: r'Entrepreneur'.tr,),
                                                      Tab(text: r'Manager'.tr,),
                                                    ],),
                                                ),
                                                SizedBox(height: AppDimensions.padding40,),
                                                Expanded(
                                                  child: TabBarView(
                                                    controller: controller.tabController,
                                                      children: [
                                                        SingleChildScrollView(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                    
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Patent_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.number,
                                                                      controller: controller.patentNumController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Patent_number'.tr,
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
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Registration_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.number,
                                                                      controller: controller.registrNumController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Registration_number'.tr,
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
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Work_address'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.workAddressController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Work_address'.tr,
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
                                                                ),
                    
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Workplace'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.workplaceController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Workplace'.tr,
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
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Job_title'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.positionAtWorkController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Job_title'.tr,
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
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Work_address'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.workAddress2Controller,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Work_address'.tr,
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
                                                                ),
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
                                                                            onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                            textInputAction: TextInputAction.next,
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
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(r'Wages'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.wagesController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'Wages'.tr,
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                    
                    
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
                                            r'Bank_branch_for_application'.tr,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(height: 16.h,),
                    
                                          Text(r'City'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                              value: controller.selectedDropdownCity,
                                              hint: Text(
                                                r"Select_city".tr,
                                                style: TextStyle(fontSize: 14.sp),
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
                                              onChanged: (v) => controller.setDropdownCity(v),
                                              items: controller.citySelection
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
                                          SizedBox(height: 22.h,),
                                          Text(r'Bank'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                              value: controller.selectedDropdownBank,
                                              hint: Text(r"Select_bank".tr, style: TextStyle(
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

                                              onChanged: (v) => controller.setDropdownBank(v),
                                              items: controller.bankSelection
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
                    
                                        ],
                                      ),
                                    ),
                                ],
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
                        ),
                        if(controller.check)
                          CheckWidget(isLoading: controller.status == Status.loading, isTitle: false, route: DashboardScreen.route, buttonTitle: r'home_page'.tr,),
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