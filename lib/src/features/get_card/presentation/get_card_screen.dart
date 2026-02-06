import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/get_card/controller/get_card_controller.dart';
import 'package:senagat_mobile/src/features/get_card/repository/card_repository.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class GetCardScreen extends StatefulWidget {
  static const route = '/get/card';

  const GetCardScreen({super.key});

  @override
  State<GetCardScreen> createState() => _GetCardScreenState();
}

class _GetCardScreenState extends State<GetCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<GetCardController>(
          init: GetCardController(
            CardRepository(apiService: ApiServices.apiService),
          ),
          builder: (controller) {
            if (controller.status == Status.loading || controller.cards.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!controller.tabController.hasListeners) {
              return const Center(child: CircularProgressIndicator());
            }
           return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge.w,
                              ),
                              child: Text(
                                r'get_a_card'.tr,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              height: 44.h,
                              // width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium.r,
                                ),
                                color: AppColors.green,
                              ),
                              child: TabBar(
                                controller: controller.tabController,
                                dividerHeight: 0,
                                labelColor: AppColors.white,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                unselectedLabelColor: AppColors.white,
                                labelStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  color: AppColors.blackText,
                                ),
                                tabs: controller.cards
                                    .where((c) => c.category == 'individual')
                                    .map((item) => Tab(text: item.title?.tr))
                                    .toList(),
                              ),
                            ),
                            SizedBox(height: 22.h),
                            Expanded(
                              child: TabBarView(
                                controller: controller.tabController,
                                children: controller.cards.where((c) => c.category == 'individual').map((item) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppDimensions.paddingExtraLarge.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              item.imageUrl ??
                                              AppAssets.cardImage,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 16.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions
                                                  .borderRadiusMedium
                                                  .r,
                                            ),
                                            border: Border.all(
                                              color: AppColors.dividerColor,
                                              width: 1.w,
                                              style: BorderStyle.solid,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.dividerColor,
                                                blurRadius: 4.r,
                                              ),
                                            ],
                                            color: AppColors.white,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppDimensions
                                                .paddingExtraLarge
                                                .w,
                                            vertical:
                                                AppDimensions.paddingMedium.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (item.advantages != null)
                                                ...item.advantages!.map(
                                                  (adv) => Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 10.h,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            adv.description ??
                                                                '',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: AppColors
                                                                  .grey,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          adv.name ?? '',
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: AppColors
                                                                .blackText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge.w,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButtonWithState(
                            isLoading: controller.status == Status.loading,
                            isError: controller.status == Status.error,
                            onPressed: () {
                              controller.onTap();
                            },
                            child: Text(
                              r'apply_for_a_card'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
