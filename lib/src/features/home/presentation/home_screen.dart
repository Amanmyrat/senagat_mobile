import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/foundation/presentation/foundation_screen.dart';
import 'package:senagat_mobile/src/features/map_search/presentation/map_search_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/service_settings/presentation/service_settings_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../../qr_code/presentation/qr_code_screen.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(
      AppDimensions.borderRadiusMedium.r,
    ),
    border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
    boxShadow: [
      BoxShadow(
        color: AppColors.dividerColor,
        blurRadius: 4.r,
      ),
    ],
    color: AppColors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onTap: () {
                                Get.toNamed(MapSearchScreen.route);
                              },
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              maxLength: 8,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: AppFonts.primaryFont,
                              ),
                              decoration: InputDecoration(
                                hintText: r'find_an_ATM'.tr,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.green,
                                    width: 1.w,
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 20.w,
                                  minHeight: 20.h,
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: AppDimensions.paddingExtraLarge.w, right: AppDimensions.paddingMedium.w),
                                  child: SvgPicture.asset(
                                    AppAssets.searchIcon,
                                    width: 20.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.white,
                                    width: 1.w,
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
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(QrCodeScreen.route);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.w),
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
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(NotificationsScreen.route);
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      controller.cardBox.isNotEmpty ?
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(AddCardScreen.route);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            image: DecorationImage(
                              image: AssetImage(controller.cardBox.get(controller.cardKey)!.cardDesign),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                                controller.cardBox.get(controller.cardKey)?.cardNumber ?? '',
                                style: TextStyle(
                                  wordSpacing: 10.sp,
                                  fontSize: 24.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 41.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.cardBox.get(controller.cardKey)?.name ?? '',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    controller.cardBox.get(controller.cardKey)?.expiryDate ?? '',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ) :
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AddCardScreen.route);
                        },
                        child: Container(
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

                              Text(r'add_a_card'.tr, style: TextStyle(
                                color: AppColors.blackText, fontSize: 17.sp,),),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.padding40.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r'fast_operations'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(ServiceSettingsScreen.route);
                            },
                            child: Text(
                              r'tune'.tr,
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 14.sp,
                                fontFamily: AppFonts.secondaryFont,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      SizedBox(
                        height: 78.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.serviceController.selectedServiceTitle.length <= 4
                              ? controller.serviceController.selectedServiceTitle.length + 1
                              : controller.serviceController.selectedServiceTitle.length,
                          itemBuilder: (context, index) {
                            if (controller.serviceController.selectedServiceTitle.length <= 4 &&
                                index == controller.serviceController.selectedServiceTitle.length) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(ServiceSettingsScreen.route);
                                },
                                child: Container(
                                  width: 90.w,
                                  height: 78.h,
                                  margin: EdgeInsets.only(
                                    right: AppDimensions.marginMedium.w,
                                  ),
                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium.r,
                                    ),
                                    border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.dividerColor,
                                        blurRadius: 4.r,
                                      ),
                                    ],
                                    color: AppColors.green,
                                  ),
                                  child:  Center(
                                    child: SvgPicture.asset(AppAssets.plusIcon,width: 30.w, color: AppColors.white),
                                  ),
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                controller.onServiceTap(index);
                              },
                              child: Container(
                                width: 90.w,
                                height: 78.h,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingMedium.h,
                                ),
                                margin: EdgeInsets.only(
                                  right: AppDimensions.marginMedium.w,
                                ),
                                decoration: boxDecoration,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                      controller.serviceController.selectedServiceIcons[index],
                                      width: 30.w,
                                      color: AppColors.green,
                                    ),
                                    Text(
                                      controller.serviceController.selectedServiceTitle[index],
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.secondaryFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: AppDimensions.padding40.h),

                      GestureDetector(
                        onTap: (){
                          Get.toNamed(FoundationScreen.route);
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: boxDecoration,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r'charitable_foundation'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    SizedBox(height: AppDimensions.paddingMedium.w),
                                    Text(
                                      r'donations_of_any_amount'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.secondaryFont,
                                      ),
                                    ),
                                    SizedBox(height: AppDimensions.paddingMedium.h),
                                    Row(
                                      children: [
                                        Text(
                                          r'donate'.tr,
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          AppAssets.arrowRightIcon,
                                          color: AppColors.green,
                                          width: 14.w,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(AppAssets.glowingObjectIcon,),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.padding40.h),

                      Text(
                        r'services'.tr,
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 17.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                SizedBox(
                  height: 232.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge),
                    itemCount: 2,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge.w,
                        ),
                        margin: EdgeInsets.only(
                            right: AppDimensions.marginMedium),
                        width: 290.w,
                        decoration: boxDecoration,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          r'inquiries'.tr,
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                r'get_any_type_of_help'.tr,
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                  fontFamily: AppFonts.secondaryFont,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),

                                      ],),
                                    Positioned(
                                      bottom: 0,
                                      left: 80,
                                      child: Image.asset(
                                          AppAssets.spreadsheet),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SvgPicture.asset(
                                        AppAssets.arrowRightIcon,
                                        color: AppColors.black,
                                        width: 14.w,
                                      ),
                                    ),
                                  ]),
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppDimensions.padding40.h),
                      controller.payBox.isEmpty?
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 200,
                        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                        decoration: boxDecoration,
                        child: Column(
                          children: [
                            Image.asset(AppAssets.sandClock),
                            SizedBox(height: AppDimensions.paddingExtraLarge.h),
                            Text(
                              r'history_is_empty'.tr,
                              style: TextStyle(
                                color: AppColors.blackText,
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r'history'.tr, style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 17.sp,
                          ),),
                          SizedBox(height: 6.h),

                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.payBox.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 90.h,
                              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: boxDecoration,
                              child: Row(
                                children: [
                                  Container(
                                    padding:EdgeInsets.all(AppDimensions.paddingMedium.w) ,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                    child: SvgPicture.asset(controller.payBox.getAt(index)?.serviceIcon ?? '', color: AppColors.white,),
                                  ),
                                  SizedBox(width: AppDimensions.paddingMedium.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.payBox.getAt(index)?.serviceName ?? '',
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          controller.payBox.getAt(index)?.number ?? '',
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                            fontFamily: AppFonts.secondaryFont
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '-${controller.payBox.getAt(index)?.sum ?? ''}',
                                    style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: AppDimensions.padding40.h),
                      Text(r'exchange_rates'.tr, style: TextStyle(
                        color: AppColors.blackText,
                        fontSize: 17.sp,
                      ),),
                      SizedBox(height: 16.h),

                      Container(
                        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                        decoration: boxDecoration,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    r'currency'.tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      r'purchase'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppDimensions.paddingExtraLarge.w,),
                                    Text(
                                      r'sale'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: AppDimensions.paddingExtraLarge.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(controller.flags[index]),
                                            SizedBox(width: 4.w,),
                                            Text(
                                              controller.currency[index],
                                              style: TextStyle(
                                                color: AppColors.blackText,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: AppDimensions.padding60.w,
                                              child: Text(
                                                textAlign: TextAlign.end,
                                                '1213',
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: AppDimensions.paddingSuperExtraLarge.w,),
                                            SizedBox(
                                              width: AppDimensions.padding60.w,
                                              child: Text(
                                                textAlign: TextAlign.end,
                                                '124',
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],),
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )

          ),
        ),
      ),
    );
  }
}
