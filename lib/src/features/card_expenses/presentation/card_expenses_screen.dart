import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/card_expenses/controller/card_expenses_controller.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';

class CardExpensesScreen extends StatefulWidget {
  static const route = '/card/expenses';
  const CardExpensesScreen({super.key});

  @override
  State<CardExpensesScreen> createState() => _CardExpensesScreenState();
}

class _CardExpensesScreenState extends State<CardExpensesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CardExpensesController>(
          init: CardExpensesController(
            PaymentRepository(apiService: ApiServices.apiService),
          ),
          builder: (controller) {
            if (controller.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.green),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingExtraLarge.w,
                      vertical: AppDimensions.paddingMedium.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              r'history'.tr,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 24.sp,
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () => _showFilterBottomSheet(context, controller),
                              child: Container(
                                height: 44.h,
                                width: 44.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.dividerColor),
                                ),
                                child: Icon(Icons.filter_list, color: AppColors.blackText),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.padding40.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'status'.tr,
                                  //   style: TextStyle(
                                  //     fontSize: 14.sp,
                                  //     color: AppColors.black,
                                  //   ),
                                  // ),
                                  // SizedBox(height: 10.h,),

                                  // DropdownButtonFormField2<String>(
                                  //   value: controller.selectedStatus.name,
                                  //   isExpanded: true,
                                  //   // hint: Text(
                                  //   //   'status'.tr,
                                  //   //   style: TextStyle(
                                  //   //     fontSize: 14.sp,
                                  //   //     color: AppColors.greyInactive,
                                  //   //   ),
                                  //   // ),
                                  //   decoration: InputDecoration(
                                  //     contentPadding: EdgeInsets.fromLTRB(
                                  //       0,
                                  //       AppDimensions.paddingExtraLarge.w,
                                  //       AppDimensions.paddingExtraLarge.w,
                                  //       AppDimensions.paddingMedium,
                                  //     ),
                                  //   ),
                                  //   dropdownStyleData: DropdownStyleData(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(
                                  //         AppDimensions.borderRadiusMedium.r,
                                  //       ),
                                  //     ),
                                  //     elevation: 2,
                                  //   ),
                                  //   iconStyleData: IconStyleData(
                                  //     icon: SvgPicture.asset(
                                  //       AppAssets.caretDownIcon,
                                  //       width: 18.w,
                                  //     ),
                                  //   ),
                                  //   items: controller.statuses.map(
                                  //           (type) => DropdownMenuItem<String>(
                                  //         value: type,
                                  //         child:  Text(
                                  //           type.tr,
                                  //           style: TextStyle(
                                  //             color: AppColors.blackText,
                                  //             fontSize: 14.sp,
                                  //             fontFamily: AppFonts.primaryFont,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ).toList(),
                                  //   onChanged: (value) {
                                  //     if (value == null) return;
                                  //     controller.setStatusFilter(
                                  //       PaymentStatus.values.firstWhere((e) => e.name == value),
                                  //     );
                                  //   },
                                  // ),
                                  Container(
                                    height: 44.h,
                                    // width: MediaQuery.of(context).size.width,

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
                                      tabs: controller.statusTabs
                                          .map((item) => Tab(text: item.key.tr))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(width: 16.w,),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width /4,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       // Text(
                            //       //   'payments'.tr,
                            //       //   style: TextStyle(
                            //       //     fontSize: 14.sp,
                            //       //     color: AppColors.black,
                            //       //   ),
                            //       // ),
                            //       // SizedBox(height: 10.w,),
                            //       DropdownButtonFormField2<String>(
                            //         value: controller.selectedType,
                            //         isExpanded: true,
                            //         // hint: Text(
                            //         //   'payments'.tr,
                            //         //   style: TextStyle(
                            //         //     fontSize: 14.sp,
                            //         //     color: AppColors.greyInactive,
                            //         //   ),
                            //         // ),
                            //         decoration: InputDecoration(
                            //           contentPadding: EdgeInsets.fromLTRB(
                            //             0,
                            //             AppDimensions.paddingExtraLarge.w,
                            //             AppDimensions.paddingExtraLarge.w,
                            //             AppDimensions.paddingMedium,
                            //           ),
                            //         ),
                            //         dropdownStyleData: DropdownStyleData(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(
                            //               AppDimensions.borderRadiusMedium.r,
                            //             ),
                            //           ),
                            //           elevation: 2,
                            //         ),
                            //         iconStyleData: IconStyleData(
                            //           icon: SvgPicture.asset(
                            //             AppAssets.caretDownIcon,
                            //             width: 18.w,
                            //           ),
                            //         ),
                            //         items: [
                            //           DropdownMenuItem<String>(
                            //             value: 'all',
                            //             child: Text(
                            //               'all'.tr,
                            //               style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
                            //             ),
                            //           ),
                            //           ...controller.paymentsTitle.map(
                            //                 (type) => DropdownMenuItem<String>(
                            //               value: type,
                            //               child:  Row(
                            //                 children: [
                            //                   Container(
                            //                     width: 50.w,
                            //                     height: 50.h,
                            //                     padding: EdgeInsets.all(AppDimensions.paddingSmall.w),
                            //
                            //                     child: Image.asset(
                            //                       controller.iconByType(type),
                            //                       width: 30.w,),
                            //                   ),
                            //                   SizedBox(width: AppDimensions.paddingMedium.w,),
                            //                   Expanded(
                            //                     child: Text(
                            //                       type.tr,
                            //                       style: TextStyle(
                            //                         color: AppColors.blackText,
                            //                         fontSize: 14.sp,
                            //                         fontFamily: AppFonts.primaryFont,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //         onChanged: (value) {
                            //           if (value == null) return;
                            //           controller.setTypeFilter(value);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),

                          ],
                        ),

                        SizedBox(height: 16.h),

                        if (controller.filteredHistory.isEmpty)
                          Center(child: _EmptyHistory())
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:  controller.filteredHistory.length,
                            itemBuilder: (context, index) {
                              final item = controller.filteredHistory[index];

                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  AppDimensions.paddingExtraLarge.w,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  border: Border.all(
                                    color: AppColors.dividerColor,
                                    width: 1.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.dividerColor,
                                      blurRadius: 4.r,
                                    ),
                                  ],
                                  color: AppColors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.createdAt,
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                            AppDimensions.paddingMedium.w,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions
                                                  .borderRadiusMedium
                                                  .r,
                                            ),
                                            color: controller
                                                .checkPaymentsStatus(index),
                                          ),
                                          child: Text(
                                            item.status == 'approved'
                                                ? 'payment_approved'.tr
                                                : item.status.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.white,
                                              fontFamily:
                                              AppFonts.secondaryFont,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12.h),

                                    /// CONTENT
                                    Row(
                                      children: [
                                        Image.asset(
                                          controller.iconByType(item.type),
                                          width: 50.w,
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.type.tr,
                                                style: TextStyle(
                                                  color:
                                                  AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              Text(
                                                item.paymentTarget.value,
                                                style: TextStyle(
                                                  color:
                                                  AppColors.blackText,
                                                  fontSize: 14.sp,
                                                  fontFamily:
                                                  AppFonts.secondaryFont,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${item.amount} TMT',
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 17.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
void _showFilterBottomSheet(
    BuildContext context,
    CardExpensesController controller,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    backgroundColor: AppColors.white,
    builder: (_) {
      return GetBuilder<CardExpensesController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'payments'.tr,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12.h),
                
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: controller.paymentsTitle.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 2.7,
                  ),
                  itemBuilder: (_, index) {
                    final type = controller.paymentsTitle[index];
                    final isSelected =
                    controller.selectedTypes.contains(type);

                    return GestureDetector(
                      onTap: () => controller.toggleType(type),
                      child: Container(
                        width: 190.w,
                        height: 70.h,
                        padding: EdgeInsets.all(AppDimensions.paddingMedium.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium.r,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.green
                                : AppColors.dividerColor,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dividerColor,
                              blurRadius: 4.r,
                            ),
                          ],
                          color: AppColors.white,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                              height: 50.h,
                              child: Image.asset(
                                controller.paymentsIcons[index],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                type.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.secondaryFont,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? AppColors.green
                                  : AppColors.greyInactive,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 12.h),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    child: Text('apply'.tr),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

}


class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: AppColors.greyInactive,
          ),
          SizedBox(height: 16.h),
          Text(
            'not_found'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'not_found_for_search'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyInactive,
            ),
          ),
        ],
      ),
    );
  }
}
