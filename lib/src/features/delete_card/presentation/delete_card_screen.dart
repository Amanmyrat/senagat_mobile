import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/delete_card/controller/delete_card_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';

class DeleteCardScreen extends StatefulWidget {
  static const route = '/delete/card';
  const DeleteCardScreen({super.key});

  @override
  State<DeleteCardScreen> createState() => _DeleteCardScreenState();
}

class _DeleteCardScreenState extends State<DeleteCardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<DeleteCardController>(
            init: DeleteCardController(),
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            CustomAppBar(),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
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
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppAssets.infoIcon, color: AppColors.green,),
                                          SizedBox(width: 6.w,),
                                          Flexible(
                                            child: Text(r'replenishment_bank'.tr,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.black, fontFamily: AppFonts.secondaryFont),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 22.h,),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(
                                        AppDimensions.paddingExtraLarge,
                                      ),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                                        image: DecorationImage(
                                          image: AssetImage(AppAssets.cardImage),
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
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 72.h,),
                                          Text(
                                             '2131 2312 3123 1231',
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
                                                 'aaaaa',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              Text(
                                                '11/27',
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
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButtonWithState(
                                  customStyle: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.redDark
                                  ),
                                  isLoading: false,
                                  isError: false,
                                  onPressed: (){
                                    controller.startBankVerification();
                                  },
                                  child: Text(r'remove_card'.tr),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if(controller.check)
                          CheckWidget(isLoading: controller.status == Status.loading, isTitle: true, title: r'remove_card'.tr,),
                      ],
                    ),
                  ),
                ],
              );
            }
          )
      ),
    );
  }
}
