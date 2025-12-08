import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';

class NoInternetScreen extends StatefulWidget {
  static const route = '/no_internet';

  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('no_internet_connection'.tr, style: TextStyle(fontSize: 24.sp)),
              SizedBox(height: AppDimensions.paddingMedium.h,),
              Text('Требуется подключение к интернету', style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont)),
              SizedBox(height: 32.h,),
              Image.asset(AppAssets.wifi, width: 190.w, height: 157.h),
              SizedBox(height: 32.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButtonWithState(
                    onPressed: () async {
                      final hasInternet = await _checkInternet();

                      if (hasInternet) {
                        Get.back();
                      }
                    },

                    isError: false,
                    isLoading:false,
                    child: Text('Повторить подключение', style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<bool> _checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
