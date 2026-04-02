import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/map_search/repository/location_repository.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../credit/repository/credit_repository.dart';
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
            init: LoanController(
              CreditRepository(apiService: ApiServices.apiService),
              LocationRepository(apiService: ApiServices.apiService),
            ),
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
                                  padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22.h),
                                  child: Align(alignment: Alignment.bottomRight,child:
                                  Text('step_of_3'.trParams({'page':controller.pageIndex.toString()}), style: TextStyle(fontSize: 14.sp), )),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  if(controller.pageIndex == 1)
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
                                                  r'job_information'.tr,
                                                  style: TextStyle(
                                                    fontSize: 24.sp,
                                                    color: AppColors.blackText,
                                                  ),
                                                ),
                                                SizedBox(height: 32.h,),
                    
                                              ],
                                            ),
                                          ),
                    
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 20.h),
                                                  child: Text(
                                                    r'entrepreneur'.tr,
                                                    style: TextStyle(
                                                      fontSize: 17.sp,
                                                      color: AppColors.blackText,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 16.h),
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
                                                      Tab(text: r'yes'.tr,),
                                                      Tab(text: r'no'.tr,),
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
                                                                    Text(r'patent_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                                        hintText: r'patent_number'.tr,
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
                                                                    Text(r'registration_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.number,
                                                                      controller: controller.registerNumController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'registration_number'.tr,
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
                                                                    Text(r'work_address'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                                        hintText: r'work_address'.tr,
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
                                                                _pdfUpload(controller, controller.profitDocument, 'income_certificate_6_12_months', 'profit'),
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
                                                                    Text(r'workplace'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                                        hintText: r'workplace'.tr,
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
                                                                    Text(r'job_title'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                                                        hintText: r'job_title'.tr,
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
                                                                    Text(r'work_address'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.name,
                                                                      controller: controller.managerWorkAddressController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'work_address'.tr,
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
                                                                    Text(r'wages'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                                                    SizedBox(height: AppDimensions.paddingMedium.h,),

                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      keyboardType: TextInputType.number,
                                                                      controller: controller.wagesController,
                                                                      onChanged:(v) => controller.onInformationNotEmpty(v),
                                                                      style: TextStyle(
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        hintText: r'wages'.tr,
                                                                        border: OutlineInputBorder(),
                                                                        errorBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            AppDimensions.borderRadiusMedium,
                                                                          ),
                                                                          borderSide: BorderSide(
                                                                            color: AppColors.redDark,
                                                                            width: 1.w,
                                                                          ),
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            AppDimensions.borderRadiusMedium,
                                                                          ),
                                                                          borderSide: BorderSide(
                                                                            color: controller.wagesError != null ? AppColors.redDark : AppColors.green,
                                                                            width: 1.w,
                                                                          ),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            AppDimensions.borderRadiusMedium,
                                                                          ),
                                                                          borderSide: BorderSide(
                                                                            color:controller.wagesError != null ? AppColors.redDark : AppColors.white,
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
                                                                _pdfUpload(controller, controller.profitDocument2, 'salary_certificate', 'profit2'),
                                                                _pdfUpload(controller, controller.workDocument, 'work_book_copy', 'work'),
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
                                  if(controller.pageIndex == 2)
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r'select_bank_branch'.tr,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(height: 16.h,),
                    

                                          Text(r'bank'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
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
                                            child: DropdownButtonFormField2<int>(
                                              value: controller.selectedDropdownBank,
                                              hint: Text(
                                                "select_bank".tr,
                                                style: TextStyle(fontSize: 14.sp),
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.fromLTRB(
                                                  0,
                                                  AppDimensions.paddingExtraLarge.w,
                                                  AppDimensions.paddingExtraLarge.w,
                                                  AppDimensions.paddingExtraLarge.h,
                                                ),
                                              ),
                                              dropdownStyleData: DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.r),

                                                ),
                                                elevation: 2,

                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w,),
                                              ),
                                              onChanged: (v) => controller.setDropdownBank(v),

                                              items: controller.branches
                                                  .map(
                                                    (item) =>
                                                    DropdownMenuItem<int>(
                                                      value: item.id,
                                                      child: Text(
                                                        item.name,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                              ).toList(),
                                            ),
                                          )
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
                          CheckWidget(isLoading: controller.status == Status.loading, isTitle: false, route: DashboardScreen.route, buttonTitle: r'home_page'.tr, successTitle: 'application_send',),
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

  Widget _pdfUpload(LoanController controller, File? pdfFile, String text, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.tr,
          style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButtonWithState(
            isLoading: false,
            isError: controller.status == Status.error,
            customStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: BorderSide(
                color: controller.status == Status.error
                    ? AppColors.redDark
                    : AppColors.dividerColor,
              ),
              shadowColor: Colors.transparent,
            ),
            onPressed:() =>  controller.pickPdf(type),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                if(controller.status == Status.error)...[
                  SvgPicture.asset(
                    AppAssets.X,
                    width: 24.w,
                    color:  AppColors.redDark,
                  ),
                ]else...[
                  SvgPicture.asset(
                    pdfFile == null
                        ? AppAssets.pdfIcon
                        : AppAssets.checkIcon,
                    width: 24.w,
                    color: pdfFile == null
                        ? AppColors.grey
                        : AppColors.green,
                  ),],

              ],
            ),
          ),
        ),
        SizedBox(height: 22.h,),
      ],
    );
  }
}