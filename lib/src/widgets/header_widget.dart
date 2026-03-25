import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/home/repository/exchage_rate_repository.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/features/web_view/presentation/web_view.dart';
import '../features/home/controller/home_controller.dart';
import '../features/map.dart';
import '../features/map_search/presentation/map_search_screen.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';
import '../utils/theme/constants/app_fonts.dart';

class HeaderWidget extends StatefulWidget{
  const HeaderWidget({super.key});


  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(
        ExchangeRateRepository(apiService: ApiServices.apiService),
        AuthRepository(apiService: ApiServices.apiService),
        PaymentRepository(apiService: ApiServices.apiService),
      ),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {
                    Get.toNamed(WebViewScreen.route);
                    // Get.toNamed(MapSearchScreen.route);
                  },
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  maxLength: 8,
                  style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
                  decoration: InputDecoration(
                    hintText: '${r'find_an_ATM'.tr}/${r'find_a_branch'.tr}',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                      borderSide: BorderSide(color: AppColors.white, width: 1.w),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 20.w,
                      minHeight: 20.h,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: AppDimensions.paddingMedium.w,
                        right: AppDimensions.paddingExtraLarge.w,
                      ),
                      child: SvgPicture.asset(AppAssets.buildingApartmentIcon, width: 20.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                      borderSide: BorderSide(color: AppColors.white, width: 1.w),
                    ),

                    counter: const SizedBox(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: AppDimensions.paddingLarge.w,
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 4.w),
              // GestureDetector(
              //   onTap: () {
              //     controller.onQrScanTap();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(16.w),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         AppDimensions.borderRadiusMedium.r,
              //       ),
              //       color: controller.lastTap == HomeTapType.qr
              //           ? AppColors.green
              //           : AppColors.inputFillBackground,
              //     ),
              //     child: SvgPicture.asset(
              //       AppAssets.qrCodeIcon,
              //       width: 20.w,
              //       color: controller.lastTap == HomeTapType.qr
              //           ? AppColors.white
              //           : AppColors.black,
              //     ),
              //   ),
              // ),
              // SizedBox(width: 4.w),
              // GestureDetector(
              //   onTap: () {
              //     controller.onNotificationScanTap();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(16.w),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         AppDimensions.borderRadiusMedium.r,
              //       ),
              //       color: controller.lastTap == HomeTapType.notification
              //           ? AppColors.green
              //           : AppColors.inputFillBackground,
              //     ),
              //     child: SvgPicture.asset(
              //       AppAssets.bellSimpleIcon,
              //       width: 20.w,
              //       color: controller.lastTap == HomeTapType.notification
              //           ? AppColors.white
              //           : AppColors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }
    );
  }
}

class AnimatedHintField extends StatefulWidget {
  @override
  State<AnimatedHintField> createState() => _AnimatedHintFieldState();
}

class _AnimatedHintFieldState extends State<AnimatedHintField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  int index = 0;

  final hints = [
    'find_an_ATM'.tr,
    'find_an_branch'.tr,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );

    _animation = Tween<Offset>(
      begin: Offset(1, 0), // справа
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      await _controller.forward(); // 👉 анимация входа

      await Future.delayed(Duration(seconds: 2)); // пауза

      if (!mounted) return;

      // await _controller.reverse(); // 👉 уехал влево

      if (!mounted) return;

      setState(() {
        index = (index + 1) % hints.length; // смена текста
      });

      _controller.reset(); // подготовка к следующему
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(WebViewScreen.route);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge.w,
          vertical: AppDimensions.paddingLarge.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppDimensions.borderRadiusMedium,
          ),
          border: Border.all(color: AppColors.white, width: 1.w),
          color: AppColors.inputFillBackground,
        ),
        child: Row(
          children: [
            Expanded(
              child: ClipRect(
                child: SlideTransition(
                  position: _animation,
                  child: Text(
                    hints[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssets.buildingApartmentIcon,
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}