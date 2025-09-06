import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/card_expenses/controller/card_expenses_controller.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart' show AppFonts;

class CardExpensesScreen extends StatefulWidget {
  static const route = '/card/expenses';
  const CardExpensesScreen({super.key});

  @override
  State<CardExpensesScreen> createState() => _CardExpensesScreenState();
}

class _CardExpensesScreenState extends State<CardExpensesScreen> {
  final List<int> values = [0, 0, 100, 40, 0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<CardExpensesController>(
            init: CardExpensesController(),
            builder: (controller) {
              return Column(
                children: [
                  CustomAppBar(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: 20),
                        child: Text(r'Spending'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                      ),
                      SizedBox(height: 16.h,),
                      SizedBox(
                        height: 270.h,
                        child: PageView.builder(
                            controller: controller.pageController,
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,

                            itemBuilder: (context, index){
                              return Container(
                                height: 270.h,
                                padding: EdgeInsets.all(
                                  AppDimensions.paddingExtraLarge,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium.w),
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
                                  color: AppColors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Август 2025",
                                      style:  TextStyle(fontSize: 14.sp, color: AppColors.greyInactive),
                                    ),
                                     Text(
                                      "200,00",
                                      style: TextStyle(fontSize: 24.sp, color: AppColors.black),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      height: 145.h,
                                      child: BarChart(
                                        BarChartData(
                                          alignment: BarChartAlignment.spaceAround,
                                          barGroups: [
                                            makeGroupData(0, 1, isActive: false),
                                            makeGroupData(1, 4),
                                            makeGroupData(2, 4),
                                            makeGroupData(3, 5000),
                                            makeGroupData(4, 10000),
                                          ],
                                          titlesData: FlTitlesData(
                                            rightTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 70,
                                                interval: 40,
                                                getTitlesWidget: (value, meta) {
                                                  switch (value.toInt()) {
                                                    case 0:
                                                      return Text("0 tmt", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 10:
                                                      return Text("10 tmt", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 40:
                                                      return Text("40 tmt", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 5000:
                                                      return Text("100 tmt", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 10000:
                                                      return Text("10000 tmt", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                  }
                                                  return const SizedBox.shrink();
                                                },
                                              ),
                                            ),

                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (value, meta) {
                                                  switch (value.toInt()) {
                                                    case 0: return Text("1-5", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 1: return Text("6-12", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 2: return Text("13-19", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 3: return Text("20-26", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                    case 4: return Text("27-31", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont));
                                                  }
                                                  return const SizedBox.shrink();
                                                },
                                              ),
                                            ),
                                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          gridData: FlGridData(show: false),
                                        ),
                                      ),
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
                          controller: controller.pageController,
                          effect: WormEffect(
                              dotHeight: 10.h,
                              dotWidth: 10.w,
                              spacing: 4,
                              activeDotColor: AppColors.green,
                              dotColor: AppColors.green.withOpacity(0.5)
                          ),
                        ),
                      ),

                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r'history'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                      SizedBox(height: 16.h,),
                      Container(
                        padding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge,
                        ),
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
                        child: ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              child: Row(
                                children: [
                                  Container(
                                    padding:EdgeInsets.all(AppDimensions.paddingMedium.w) ,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                    child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.white,),
                                  ),
                                  SizedBox(width: AppDimensions.paddingMedium.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Altyn Asyr',
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          '+99311111111',
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
                                    '-500',
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      ],
                    ),
                  ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
  double findMaxY(List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    // Add some headroom so tallest bar doesn’t touch the top
    return (maxValue * 1.2).ceilToDouble();
  }
  BarChartGroupData makeGroupData(int x, double y, {bool isActive = true}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isActive ? AppColors.green : AppColors.greyInactive,
          width: 18.w,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r),
            topRight: Radius.circular(6.r),
          ),
        ),
      ],
    );
  }

}
