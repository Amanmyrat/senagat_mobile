import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/card_expenses/presentation/card_expenses_screen.dart';
import 'package:senagat_mobile/src/features/card_settings/presentation/card_settings_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/header_widget.dart';
import '../../../core/states/stateful_data.dart';
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
            init: CardController(AuthRepository(apiService: ApiServices.apiService)),
            builder: (controller) => controller.status == Status.loading
                ? Center(
              child: CircularProgressIndicator(color: AppColors.green),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderWidget(),
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
                                      Text(r'expenses_per_month'.tr, style: TextStyle(
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

                          Text(r'cards'.tr, style: TextStyle(fontSize: 17.sp, color: AppColors.black),),
                          SizedBox(height: 16.h,),

                          controller.cardBox.length == 0 ?
                          GestureDetector(
                              onTap: () {
                                Get.toNamed(AddCardScreen.route);
                              },
                              child: Container(
                                height: 120.h,
                                width:  MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom: 10.h),
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  color: AppColors.inputFillBackground,
                                ),
                                child:  Center(
                                  child: SvgPicture.asset(AppAssets.plusIcon,width: 30.w, color: AppColors.black),
                                ),
                              ) ):
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.cardBox.length,
                            itemBuilder: (context, index) {
                             return Row(
                               children: [
                                 Expanded(
                                   child: GestureDetector(
                                     onTap:(){
                                       Get.toNamed(CardSettingsScreen.route, arguments: {'index': index});
                                     },
                                     child: Container(
                                        padding: EdgeInsets.all(
                                          AppDimensions.paddingExtraLarge,),
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          image: DecorationImage(
                                            image: AssetImage(controller.cardBox.getAt(index)!.cardDesign),
                                            fit: BoxFit.cover,),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Align(alignment: Alignment.topLeft,
                                              child: Text('Senagat Bank', style:
                                              TextStyle(
                                                color: AppColors.white, fontSize: 14.sp,),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.paddingExtraLarge.h,),

                                              Text(controller.hideCardCenter(controller.cardBox.getAt(index)?.cardNumber ?? ''), style: TextStyle(
                                                fontSize: 17.sp, color: AppColors.white,),
                                              ),
                                          ],
                                        ),
                                      ),
                                   ),
                                 ),
                                 SizedBox(width: 10.w,),
                                 if(controller.cardBox.length == 1)
                                   GestureDetector(
                                   onTap: () {
                                     Get.toNamed(AddCardScreen.route);
                                   },
                                   child: Container(
                                     height: 120.h,
                                     width: 90.w,
                                     margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium.h),
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
                             );
                            }
                          ),
                          SizedBox(height: AppDimensions.padding40.h,),
                          if(controller.userInformationModel?.cards != null)...[
                            Text(r'open_applications'.tr, style: TextStyle(fontSize: 17.sp, color: AppColors.black),),
                            SizedBox(height: 16.h),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.userInformationModel?.cards?.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final card = controller.userInformationModel?.cards?[index];

                                return Padding(
                                  padding: EdgeInsets.only(bottom: AppDimensions.padding40.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.dividerColor,
                                            width: 1.w,
                                            style: BorderStyle.solid,
                                          ),
                                          boxShadow: [
                                            BoxShadow(color: AppColors.dividerColor, blurRadius: 4.r),
                                          ],
                                          color: AppColors.inputFillBackground,
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                controller.onOpenApplication();
                                                },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      card?.status?.tr ?? '',
                                                      style: TextStyle(color: AppColors.black, fontSize: 14.sp),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        r'01 Августа, 10:15'.tr,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      SvgPicture.asset(
                                                        controller.isOpen ? AppAssets.caretDownIcon :AppAssets.arrowRightIcon,
                                                        width: 14.w,
                                                        color: AppColors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if(controller.isOpen)...[
                                            SizedBox(height: AppDimensions.paddingExtraLarge.h),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            r'card'.tr,
                                                            style: TextStyle(
                                                              color: AppColors.grey,
                                                              fontSize: 14.sp,
                                                              fontFamily: AppFonts.secondaryFont,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            card?.cardTitle.toString() ?? '',
                                                            style: TextStyle(
                                                              color: AppColors.black,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                    ),

                                                    Container(
                                                      width: 1.w,
                                                      height: 44.h,
                                                      margin: EdgeInsets.symmetric(
                                                        horizontal: AppDimensions.paddingExtraLarge.w,
                                                      ),
                                                      color: AppColors.dividerColor,
                                                    ),

                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            r'payment_amount'.tr,
                                                            style: TextStyle(
                                                              color: AppColors.grey,
                                                              fontSize: 14.sp,
                                                              fontFamily: AppFonts.secondaryFont,
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            card?.cardPrice.toString() ??
                                                                '',
                                                            style: TextStyle(
                                                              color: AppColors.black,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: AppDimensions.paddingLarge.h,),
                                              ],
                                            ),

                                            SizedBox(height: AppDimensions.paddingExtraLarge.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        r'bank_branch'.tr,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp,
                                                          fontFamily: AppFonts.secondaryFont,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        card?.bankBranch ?? '',
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 1.w,
                                                  height: 44.h,
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: AppDimensions.paddingExtraLarge.w,
                                                  ),
                                                  color: AppColors.dividerColor,
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        r'delivery'.tr,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp,
                                                          fontFamily: AppFonts.secondaryFont,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      if(card?.delivery ?? false)...[
                                                        Text(
                                                          'delivery_service_available'.tr,
                                                          style: TextStyle(
                                                            color: AppColors.black,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ]else...[
                                                        Text(
                                                          'no_delivery_service'.tr,
                                                          style: TextStyle(
                                                            color: AppColors.black,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ]

                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],


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
                      child: Text(r'add_a_card'.tr, style: TextStyle(fontSize: 14.sp),),
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
