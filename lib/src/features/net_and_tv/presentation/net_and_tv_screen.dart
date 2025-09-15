import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/net_and_tv/controller/net_and_tv_controller.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';

class NetAndTvScreen extends StatefulWidget {
  static const route = r'/net/pay';

  const NetAndTvScreen({super.key});

  @override
  State<NetAndTvScreen> createState() => _NetAndTvScreenState();
}

class _NetAndTvScreenState extends State<NetAndTvScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<NetAndTvController>(
            init: NetAndTvController(),
            builder: (controller) {
              return Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingExtraLarge.w,
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.serviceName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: AppDimensions.padding40.h,),

                            ListView.builder(
                                itemCount: controller.serviceTitle.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: (){
                                      controller.onServiceTap(index);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: AppDimensions.paddingExtraLarge.h),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50.w,
                                            height: 50.h,
                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.dividerColor, width: 1.w),
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                            ),
                                            child: SvgPicture.asset(controller.serviceIcons[index], color: AppColors.green, width: 30.w,),
                                          ),
                                          SizedBox(width: AppDimensions.paddingMedium.w,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                  child: Text(controller.serviceTitle[index].tr,
                                                    style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
