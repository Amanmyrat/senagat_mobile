import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Expanded(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppDimensions.paddingMedium,
                right: AppDimensions.paddingMedium,
                top: AppDimensions.paddingExtraLarge.w,
                bottom: AppDimensions.padding40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,

                          maxLength: 8,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.primaryFont,
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
                                width: 1,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxWidth: 20,
                              maxHeight: 20,
                            ),
                            prefixIcon: SvgPicture.asset(
                              AppAssets.searchIcon,
                              width: 20.w,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.green,
                                width: 1,
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
                      SizedBox(width: 4.w),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium.r,
                          ),
                          color: AppColors.inputFillBackground,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.qrCodeIcon,
                          width: 20.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium.r,
                          ),
                          color: AppColors.inputFillBackground,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.bellSimpleIcon,
                          width: 20.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Container(
                    width: 390.w,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: AppColors.inputFillBackground,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium.r,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.plusIcon, width: 32.w),

                        SizedBox(height: AppDimensions.paddingMedium),

                        Text('Добавить карту'),
                      ],
                    ),
                  ),

                  SizedBox(height: AppDimensions.padding40.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Быстрые опирации'),
                      Text(
                        'Настроить',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 14.sp,
                          fontFamily: AppFonts.secondaryFont,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  SizedBox(
                    height: 78,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingLarge.w,
                            vertical: AppDimensions.paddingMedium.h,
                          ),
                          margin: EdgeInsets.only(
                            left: AppDimensions.marginMedium.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightGrey,
                                blurRadius: 4,
                              ),
                            ],
                            color: AppColors.white,
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AppAssets.deviceMobileIcon,
                                width: 30.w,
                                color: AppColors.green,
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),

                              Text(
                                'Телефон',
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.secondaryFont,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppDimensions.padding40.h),

                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium.r,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.lightGrey, blurRadius: 4),
                      ],
                      color: AppColors.white,
                    ),

                    child: Row(
                      children: [
                        SizedBox(
                          width: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Благотворительный \n фонд',
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.w),
                              Text(
                                'Пожертвование любой суммы приветствуется',
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.secondaryFont,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.w),
                              Row(
                                children: [
                                  Text(
                                    'Пожертвовать',
                                    style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.arrowLeftIcon,
                                    color: AppColors.green,
                                    width: 14.w,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Image.asset(AppAssets.glowingObjectIcon),
                      ],
                    ),
                  ),

                  SizedBox(height: AppDimensions.padding40.h),

                  Text(
                    'Сервисы',
                    style: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 232,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge.w,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightGrey,
                                blurRadius: 4,
                              ),
                            ],
                            color: AppColors.white,
                          ),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Справки',
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.secondaryFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Получите любой тип справки',
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.secondaryFont,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(AppAssets.spreadsheet),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppDimensions.padding40.h),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium.r,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.lightGrey, blurRadius: 4),
                      ],
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Image.asset(AppAssets.sandClock),
                        SizedBox(height: AppDimensions.paddingExtraLarge.h),
                        Text(
                          'История пуста',
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 17.sp,
                            fontFamily: AppFonts.secondaryFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text('data'),

                  Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
