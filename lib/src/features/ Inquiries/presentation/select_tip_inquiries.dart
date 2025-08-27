import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/presentation/inquiries_screen.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/select_tip_inquiries_controller.dart';

class SelectTipInquiries extends StatefulWidget {
  static const route = '/select/inquiries';
  const SelectTipInquiries({super.key});

  @override
  State<SelectTipInquiries> createState() => _SelectTipInquiriesState();
}

class _SelectTipInquiriesState extends State<SelectTipInquiries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<SelectTipInquiriesController>(
            init: SelectTipInquiriesController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomAppBar(),
                          Padding(
                            padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22),
                            child: Align(alignment: Alignment.bottomRight,child: Text(r'Шаг 2 из 4'.tr, style: TextStyle(fontSize: 14.sp), )),
                          ),
                        ],
                      ),
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
                                value: controller.selectedDropdownValue,
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
                                onChanged: (v) => controller.setDropdownValue(v),
                                items: controller.dropdownItems
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
                                        child: Text('Подтвердить, что у вас есть учетная запись, личный кабинет или он закрыт',
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
                    ],
                  ),

                  Opacity(
                    opacity: controller.continueEnabled ? 1 : 0.5,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          isLoading: controller.status == Status.loading,
                          isError: controller.status == Status.error,
                          onPressed: controller.continueEnabled
                              ? () {
                            Get.toNamed(InquiriesScreen.route);
                          }
                              : null,
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
