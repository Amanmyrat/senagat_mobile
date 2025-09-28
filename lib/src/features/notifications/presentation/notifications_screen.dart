import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  static const route = r'/notifications';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(actionWidget: Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.greyInactive,
                  width: 1.w,
                  style: BorderStyle.solid,
                ),
              ),
              child: SvgPicture.asset(AppAssets.broomIcon, width: 20.w, color: AppColors.greyInactive,),
            ),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingExtraLarge.w,
                ),
                child: GetBuilder<NotificationController>(
                  init: NotificationController(),
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r'notifications'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                        SizedBox(height: AppDimensions.paddingMedium.h),

                        Container(
                          decoration: BoxDecoration(
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
                          ),
                          child:
                          // controller.isNotificationEmpty ?
                          Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(AppAssets.magnIcon, width: 60.w,),
                                Text(r'no_notifications'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 17.sp),),
                                SizedBox(height: 20.h,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButtonWithState(
                                    onPressed: (){

                                    },
                                    isError: false,
                                    isLoading: false,
                                    child: Text(r'go_to_catologist'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                                  ),
                                ),
                              ],
                            ),
                          )
                                // :
                          // Column(
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                          //       child: SizedBox(
                          //         height: 23.h,
                          //         child: TabBar(
                          //           controller: controller.tabController,
                          //           dividerHeight: 1,
                          //           dividerColor: AppColors.dividerColor,
                          //           labelColor: AppColors.blackText,
                          //           unselectedLabelColor: AppColors.grey,
                          //           labelStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont, fontWeight: FontWeight.w700),
                          //           unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont),
                          //           indicatorSize: TabBarIndicatorSize.tab,
                          //           indicatorColor: AppColors.greyInactive,
                          //           tabs: [
                          //             Tab(text: r'all'.tr,),
                          //             Tab(text: r'manager'.tr,),
                          //             Tab(text: r'manager'.tr,),
                          //           ],),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: TabBarView(
                          //         physics: NeverScrollableScrollPhysics(),
                          //           controller: controller.tabController,
                          //           children: [
                          //             ListView.builder(
                          //               padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          //               itemCount: 5,
                          //                 physics: NeverScrollableScrollPhysics(),
                          //                 itemBuilder: (context, index) {
                          //                   return GestureDetector(
                          //                     onLongPress: (){
                          //                       controller.onLongTap();
                          //                     },
                          //                     child: Container(
                          //                       margin: EdgeInsets.only(bottom: 10.h),
                          //                       child: Row(
                          //                         children: [
                          //                           controller.isLongTap ? RoundCheckBox(
                          //                               size: 24.w,
                          //                               borderColor: AppColors.black,
                          //                               isRound: false,
                          //                               onTap: (v){
                          //
                          //                               }
                          //                           ): SizedBox(),
                          //                           SizedBox(width: controller.isLongTap ? AppDimensions.paddingMedium.w : 0),
                          //                           Container(
                          //                             width: 40.w,
                          //                             height: 40.h,
                          //                             padding:EdgeInsets.all(AppDimensions.paddingMedium.w),
                          //                             decoration: BoxDecoration(
                          //                               shape: BoxShape.circle,
                          //                               color: AppColors.green,
                          //                             ),
                          //                             child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.white, width: 20.w,),
                          //                           ),
                          //                           SizedBox(width: AppDimensions.paddingMedium.w),
                          //                           Expanded(
                          //                             child: Column(
                          //                               crossAxisAlignment: CrossAxisAlignment.start,
                          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                               children: [
                          //                                 Text(
                          //                                   r'Телефон',
                          //                                   style: TextStyle(
                          //                                     color: AppColors.blackText,
                          //                                     fontSize: 14.sp,
                          //                                   ),
                          //                                 ),
                          //                                 Text(
                          //                                   '01.08.2025',
                          //                                   style: TextStyle(
                          //                                       color: AppColors.blackText,
                          //                                       fontSize: 14.sp,
                          //                                       fontFamily: AppFonts.secondaryFont
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ),
                          //                           Text(
                          //                             '-25 ТМТ',
                          //                             style: TextStyle(
                          //                               color: AppColors.blackText,
                          //                               fontSize: 17.sp,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   );
                          //                 },),
                          //             ListView.builder(
                          //               padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          //               itemCount: 5,
                          //               physics: NeverScrollableScrollPhysics(),
                          //               itemBuilder: (context, index) {
                          //                 return Container(
                          //                   margin: EdgeInsets.only(bottom: 10.h),
                          //                   child: Row(
                          //                     children: [
                          //                       RoundCheckBox(
                          //                           size: 24.w,
                          //                           borderColor: AppColors.black,
                          //                           isRound: false,
                          //                           onTap: (v){
                          //
                          //                           }
                          //                       ),
                          //                       SizedBox(width: AppDimensions.paddingMedium.w,),
                          //                       Container(
                          //                         width: 40.w,
                          //                         height: 40.h,
                          //                         padding:EdgeInsets.all(AppDimensions.paddingMedium.w),
                          //                         decoration: BoxDecoration(
                          //                           shape: BoxShape.circle,
                          //                           color: AppColors.green,
                          //                         ),
                          //                         child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.white, width: 20,),
                          //                       ),
                          //                       SizedBox(width: AppDimensions.paddingMedium.w),
                          //                       Expanded(
                          //                         child: Column(
                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                           children: [
                          //                             Text(
                          //                               r'Телефон',
                          //                               style: TextStyle(
                          //                                 color: AppColors.blackText,
                          //                                 fontSize: 14.sp,
                          //                               ),
                          //                             ),
                          //                             Text(
                          //                               '01.08.2025',
                          //                               style: TextStyle(
                          //                                   color: AppColors.blackText,
                          //                                   fontSize: 14.sp,
                          //                                   fontFamily: AppFonts.secondaryFont
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                       Text(
                          //                         '-25 ТМТ',
                          //                         style: TextStyle(
                          //                           color: AppColors.blackText,
                          //                           fontSize: 17.sp,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 );
                          //               },),
                          //             ListView.builder(
                          //               padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          //               itemCount: 5,
                          //               physics: NeverScrollableScrollPhysics(),
                          //               itemBuilder: (context, index) {
                          //                 return Container(
                          //                   margin: EdgeInsets.only(bottom: 10.h),
                          //                   child: Row(
                          //                     children: [
                          //                       RoundCheckBox(
                          //                           size: 24.w,
                          //                           borderColor: AppColors.black,
                          //                           isRound: false,
                          //                           onTap: (v){
                          //
                          //                           }
                          //                       ),
                          //                       SizedBox(width: AppDimensions.paddingMedium.w,),
                          //                       Container(
                          //                         width: 40.w,
                          //                         height: 40.h,
                          //                         padding:EdgeInsets.all(AppDimensions.paddingMedium.w),
                          //                         decoration: BoxDecoration(
                          //                           shape: BoxShape.circle,
                          //                           color: AppColors.green,
                          //                         ),
                          //                         child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.white, width: 20,),
                          //                       ),
                          //                       SizedBox(width: AppDimensions.paddingMedium.w),
                          //                       Expanded(
                          //                         child: Column(
                          //                           crossAxisAlignment: CrossAxisAlignment.start,
                          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                           children: [
                          //                             Text(
                          //                               r'Телефон',
                          //                               style: TextStyle(
                          //                                 color: AppColors.blackText,
                          //                                 fontSize: 14.sp,
                          //                               ),
                          //                             ),
                          //                             Text(
                          //                               '01.08.2025',
                          //                               style: TextStyle(
                          //                                   color: AppColors.blackText,
                          //                                   fontSize: 14.sp,
                          //                                   fontFamily: AppFonts.secondaryFont
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                       Text(
                          //                         '-25 ТМТ',
                          //                         style: TextStyle(
                          //                           color: AppColors.blackText,
                          //                           fontSize: 17.sp,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 );
                          //               },),
                          //           ]
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Padding(
            //   padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: ElevatedButtonWithState(
            //       customStyle: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.white,
            //           side: BorderSide(color: AppColors.dividerColor),
            //           shadowColor: Colors.transparent
            //       ),
            //       isLoading: false,
            //       isError: false,
            //       onPressed:() {
            //
            //       },
            //       child: Text(r'delete'.tr,style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
