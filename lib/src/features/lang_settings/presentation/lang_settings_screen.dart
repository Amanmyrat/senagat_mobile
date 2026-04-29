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
                            controller.updateLanguage('TM');
                          },
                          child: Container(
                            color: AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(r'Türkmen'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                                Checkbox(
                                  side: BorderSide(width: 1.w),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    value: controller.currentLang == 'TM' || controller.currentLang == 'TK',
                                    onChanged: (value) {
                                      controller.updateLanguage('TM');
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                Checkbox(
                                    side: BorderSide(width: 1.w),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    value: controller.currentLang == 'RU' || controller.currentLang == 'RU',
                                    onChanged: (value) {
                                      controller.updateLanguage('RU');
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                Checkbox(
                                    side: BorderSide(width: 1.w),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    value: controller.currentLang == 'EN' || controller.currentLang == 'EN',
                                    onChanged: (value) {
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
