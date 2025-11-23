import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:senagat_mobile/src/features/lang_settings/controller/lang_settings_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';

class LangSettingsScreen extends StatefulWidget {
  static const route = '/lang/settings';
  const LangSettingsScreen({super.key});

  @override
  State<LangSettingsScreen> createState() => _LangSettingsScreenState();
}

class _LangSettingsScreenState extends State<LangSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<LangSettingsController>(
            init: LangSettingsController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(),
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r'language'.tr, style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                        SizedBox(height: 32.h,),
                        GestureDetector(
                          onTap: (){
                            controller.updateLanguage('TK');
                          },
                          child: Container(
                            color: AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r'Turkmen'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                                RoundCheckBox(
                                    size: 27.w,
                                    checkedColor: Colors.transparent,
                                    checkedWidget: SvgPicture.asset(AppAssets.checkBoxIcon, color: AppColors.green,),
                                    border: Border.all(color: AppColors.black),
                                    isChecked: controller.currentLang == 'TM' || controller.currentLang == 'TK',
                                    onTap: (value) {
                                      controller.updateLanguage('TM');
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h,),
                        GestureDetector(
                          onTap: (){
                            controller.updateLanguage('RU');
                          },
                          child: Container(
                            color: AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r'Русский'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                                RoundCheckBox(
                                    size: 27.w,
                                    checkedColor: Colors.transparent,
                                    checkedWidget: Padding(
                                      padding: EdgeInsets.all(2.w),
                                      child: SvgPicture.asset(AppAssets.checkBoxIcon, color: AppColors.green, width: 12.w,),
                                    ),
                                    border: Border.all(color: AppColors.black),
                                    isChecked: controller.currentLang == 'RU',
                                    onTap: (value) {
                                      controller.updateLanguage('RU');
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h,),
                        GestureDetector(
                          onTap: (){
                            controller.updateLanguage('EN');
                          },
                          child: Container(
                            color: AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r'English'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                                RoundCheckBox(
                                    size: 27.w,
                                    checkedColor: Colors.transparent,
                                    checkedWidget: SvgPicture.asset(AppAssets.checkBoxIcon, color: AppColors.green, width: 12.w,),
                                    border: Border.all(color: AppColors.black),
                                    isChecked: controller.currentLang == 'EN',
                                    onTap: (value) {
                                      controller.updateLanguage('EN');
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              );
            }
          )
      ),
    );
  }
}
