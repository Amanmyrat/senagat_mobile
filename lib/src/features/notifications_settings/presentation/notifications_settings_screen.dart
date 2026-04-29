import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  static const route = '/notification/settings';
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              Padding(
                padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r'notifications'.tr, style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                    SizedBox(height: 32.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r'sms'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                        FlutterSwitch(
                          width: 47.w,
                          height: 27.h,
                          padding: 1,
                          toggleSize: 23.w,
                          activeToggleColor: AppColors.green,
                          inactiveToggleColor: AppColors.greyInactive,
                          activeSwitchBorder: Border.all(color: AppColors.black),
                          inactiveSwitchBorder: Border.all(color: AppColors.black),
                          inactiveColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          value: true,
                          onToggle: (value) {
                        
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r'push_notifications'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
                        FlutterSwitch(
                          width: 47.w,
                          height: 27.h,
                          padding: 1,
                          toggleSize: 23.w,
                          activeToggleColor: AppColors.green,
                          inactiveToggleColor: AppColors.greyInactive,
                          activeSwitchBorder: Border.all(color: AppColors.black),
                          inactiveSwitchBorder: Border.all(color: AppColors.black),
                          inactiveColor: Colors.transparent,
                          activeColor: Colors.transparent,
                          value: false,
                          onToggle: (value) {

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )

            ],
          )
      ),
    );
  }
}
