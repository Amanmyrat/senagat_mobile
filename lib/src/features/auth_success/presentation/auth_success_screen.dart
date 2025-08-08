import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../controller/auth_success_controller.dart';

class AuthSuccessScreen extends StatefulWidget {
  static const route = '/auth/success';
  const AuthSuccessScreen({Key? key}) : super(key: key);

  @override
  State<AuthSuccessScreen> createState() => _AuthSuccessScreenState();
}

class _AuthSuccessScreenState extends State<AuthSuccessScreen> {
  final AuthSuccessController _controller = Get.put(AuthSuccessController());

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
                            color: AppColors.greenDark,
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
