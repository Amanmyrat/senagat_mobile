import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../controller/login_accept_controller.dart';

class LoginAcceptScreen extends StatefulWidget {
  static const route = '/login_accept';
  const LoginAcceptScreen({Key? key}) : super(key: key);

  @override
  State<LoginAcceptScreen> createState() => _LoginAcceptScreenState();
}

class _LoginAcceptScreenState extends State<LoginAcceptScreen> {
  final LoginAcceptController _controller = Get.put(LoginAcceptController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.senagatIcon, width: 134.w, height: 135.h),
                Text(
                  'Senagat töleg',
                  style: TextStyle(
                    color: AppColors.blackText,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Оплатить можно практически всё!',
                  style: TextStyle(
                    color: AppColors.greyInactive,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 35.h),

                Obx(
                  () => SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: _controller.isLoading
                        ? CircularProgressIndicator(color: AppColors.green)
                        : SvgPicture.asset(
                            AppAssets.checkIcon,
                            color: AppColors.green,
                          ),
                  ),
                ),

                SizedBox(height: AppDimensions.paddingMedium.h),

                Text(
                  'Проверка со стороны банка',
                  style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
