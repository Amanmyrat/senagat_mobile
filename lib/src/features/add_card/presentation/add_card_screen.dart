import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class AddCardScreen extends StatefulWidget {
  static const route = r'/add/card';

  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingExtraLarge.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r'Выберите дизайн'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                        SizedBox(height: 16.h,),
                        SizedBox(
                          height: 240.h,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                            return Container(
                              height: 220.h,
                              padding: EdgeInsets.all(
                                AppDimensions.paddingExtraLarge,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                    image: AssetImage(AppAssets.cardImage),
                                    fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Senagat Bank',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 72.h,),
                                  Row(
                                    children: [
                                      Text(
                                        '3576',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                      Text(
                                        '1239',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                      Text(
                                        '1234',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppDimensions.paddingExtraLarge.h,),
                                      Text(
                                        '0689',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 41.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Имя на карте',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        'Срок',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: AppDimensions.paddingMedium.h,),

                        Center(
                          child: SmoothPageIndicator(
                            count: 4,
                            controller: _controller,
                            effect: WormEffect(
                              dotHeight: 10.h,
                              dotWidth: 10.w,
                              spacing: 4,
                              activeDotColor: AppColors.green,
                              dotColor: AppColors.green.withOpacity(0.5)
                            ),
                          ),
                        ),
                        SizedBox(height: 26.h,),

                        Text('Данные карты', style: TextStyle(color: AppColors.blackText,fontSize: 24.sp),),
                        SizedBox(height: 32.h,),
                        Text('Номер карты', style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                        SizedBox(height: AppDimensions.paddingMedium.h,),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 8,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.primaryFont,
                          ),
                          decoration: InputDecoration(
                            hintText: r'Номер карты'.tr,
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.white,
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

                        SizedBox(height: 22.h,),

                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:190,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Имя на карте', style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 8,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: r'Имя на карте'.tr,
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
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.white,
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
                                  ],
                                ),
                              ),
                              SizedBox(width: AppDimensions.paddingMedium.h,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Срок', style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      maxLength: 8,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: r'Срок'.tr,
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
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.white,
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
                                  ],
                                ),
                              ),
                              SizedBox(width: AppDimensions.paddingMedium.h,),
                              Flexible(
                                child: Column(
                                  children: [
                                    SizedBox(height: 25,),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      textAlign: TextAlign.center,
                                      maxLength: 8,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: r'CVC'.tr,
                                        hintStyle: TextStyle(color: AppColors.blackText,),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.green,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.white,
                                            width: 1,
                                          ),
                                        ),
                                        suffixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: SvgPicture.asset(AppAssets.infoIcon, width: 18.w,),
                                        ),
                                        counter: const SizedBox(),
                                        contentPadding: EdgeInsets.only(
                                          top: AppDimensions.paddingExtraLarge.h,
                                          bottom: AppDimensions.paddingExtraLarge.h,
                                          left: AppDimensions.paddingMedium.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButtonWithState(
                  isLoading: false,
                  isError: false,
                  onPressed: (){

                  },
                  child: Text(r'Подтвердить'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
