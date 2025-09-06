import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/card_expenses/presentation/card_expenses_screen.dart';
import 'package:senagat_mobile/src/features/card_settings/presentation/card_settings_screen.dart';
import 'package:senagat_mobile/src/features/map_search/presentation/map_search_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../../../widgets/elevated_button_with_state.dart';

class CardScreen extends StatefulWidget {
  static const route = '/card';

  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CardController>(
            init: CardController(),
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium,),
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
                                        color: AppColors.white,
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
                                      vertical: 16.h,
                                      horizontal: AppDimensions.paddingLarge.w,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: (){
                                  controller.onQrScanTap();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium.r,
                                    ),
                                    color: controller.lastTap == CardTapType.qr ? AppColors.green : AppColors.inputFillBackground,
                                  ),
                                  child: SvgPicture.asset(
                                    AppAssets.qrCodeIcon,
                                    width: 20.w,
                                    color: controller.lastTap == CardTapType.qr ? AppColors.white : AppColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: () {
                                  controller.onNotificationScanTap();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium.r,
                                    ),
                                    color: controller.lastTap == CardTapType.notification ? AppColors.green : AppColors.inputFillBackground,
                                  ),
                                  child: SvgPicture.asset(
                                    AppAssets.bellSimpleIcon,
                                    width: 20.w,
                                    color: controller.lastTap == CardTapType.notification ? AppColors.white : AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(CardExpensesScreen.route);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                                color: AppColors.black,

                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('200,00', style: TextStyle(
                                        fontSize: 24.sp,
                                        color: AppColors.white
                                      ),),
                                      Text(r'Траты за Август'.tr, style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.greyInactive
                                      ),)
                                    ],
                                  ),
                                  SvgPicture.asset(AppAssets.diagram,),
                                ],
                              ),
                            ),
                          ),
                    
                          SizedBox(height: AppDimensions.padding40.h,),
                    
                          AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.cardBox.length,
                              itemBuilder: (context, index) {
                               return AnimationConfiguration.staggeredList(
                                 position: index,
                                 duration: 3.seconds,
                                 child: SlideAnimation(
                                   verticalOffset: 50,
                                   child: FadeInAnimation(
                                     child: Row(
                                       children: [
                                         Expanded(
                                           child: GestureDetector(
                                             onTap:(){
                                               Get.toNamed(CardSettingsScreen.route);
                                             },
                                             child: Container(
                                                padding: EdgeInsets.all(
                                                  AppDimensions.paddingExtraLarge,),
                                                margin: EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.r),
                                                  image: DecorationImage(
                                                    image: AssetImage(controller.cardBox.getAt(index)!.cardDesign),
                                                    fit: BoxFit.cover,),),
                                                child: Column(
                                                  children: [
                                                    Align(alignment: Alignment.topLeft,
                                                      child: Text('Senagat Bank', style:
                                                      TextStyle(
                                                        color: AppColors.white, fontSize: 14,),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: AppDimensions.paddingExtraLarge.h,),
                                                    Row(children: [
                                                      Text('xxxx', style: TextStyle(
                                                        fontSize: 24.sp, color: AppColors.white,),
                                                      ),
                                                      SizedBox(
                                                        width: AppDimensions.paddingExtraLarge.h,),
                                                      Text('0689', style: TextStyle(
                                                        fontSize: 24.sp, color: AppColors.white,),
                                                      ),
                                                      SizedBox(
                                                        width: AppDimensions.paddingExtraLarge.h,),
                                                    ],),
                                                  ],
                                                ),
                                              ),
                                           ),
                                         ),
                                         SizedBox(width: 10.w,),
                                         if(controller.cardBox.length == 2)
                                           GestureDetector(
                                           onTap: () {
                                             Get.toNamed(AddCardScreen.route);
                                           },
                                           child: Container(
                                             height: 120.h,
                                             width: 90.w,
                                             margin: EdgeInsets.only(bottom: 10),
                                             decoration:  BoxDecoration(
                                               borderRadius: BorderRadius.circular(
                                                 AppDimensions.borderRadiusMedium.r,
                                               ),
                                               color: AppColors.inputFillBackground,
                                             ),
                                             child:  Center(
                                               child: SvgPicture.asset(AppAssets.plusIcon,width: 30.w, color: AppColors.black),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                              }
                            ),
                          ),
                    
                        ],
                      ),
                    ),
                  ),
                ),
                if(controller.cardBox.length > 1)
                  Padding(
                  padding: EdgeInsets.fromLTRB(AppDimensions.paddingExtraLarge, AppDimensions.paddingExtraLarge,  AppDimensions.paddingExtraLarge, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButtonWithState(
                      isLoading: false,
                      isError: false,
                      onPressed: (){
                        Get.toNamed(AddCardScreen.route);
                      },
                      child: Text(r'add_a_card'.tr),
                    ),
                  ),
                ),
              ],
            )

        ),
      ),
    );
  }
}
