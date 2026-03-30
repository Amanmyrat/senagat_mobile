import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../pay/repository/payment_repository.dart';
import '../controller/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  static const route = '/category';

  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: GetBuilder<CategoryController>(
            init: CategoryController(
              PaymentRepository(apiService: ApiServices.apiService),
            ),
            builder: (controller) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                        vertical: AppDimensions.paddingMedium.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.paddingExtraLarge),
                          fastOperationsWidget(controller),
                          SizedBox(height: 16.h),

                          Text(
                            r'payments'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          GridView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.paymentsTitle.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.onServiceTap(index);
                                },
                                child: Container(
                                  width: 190.w,
                                  height: 70.h,
                                  padding: EdgeInsets.symmetric(
                                   vertical: AppDimensions.paddingMedium.h,
                                   horizontal: AppDimensions.paddingMedium.w,
                                  ),
                                  margin: EdgeInsets.only(
                                    right: AppDimensions.marginMedium.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium.r,
                                    ),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                      width: 1.w,
                                      style: BorderStyle.solid,
                                    ),
                                    boxShadow: softCardShadow,
                                    color: AppColors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        controller.paymentsIcons[index],
                                        // color: isSelected ? AppColors.green : AppColors.white,
                                        width: 30.w,
                                      ),
                                      SizedBox(
                                        width: AppDimensions.paddingMedium.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.paymentsTitle[index].tr,
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                            fontFamily: AppFonts.secondaryFont,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3,
                                  mainAxisSpacing: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (controller.check)
                  CheckWidget(
                    isLoading: controller.status == Status.loading,
                    isTitle: true,
                    title: r'remove_card'.tr,
                    successTitle: 'card_removed',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fastOperationsWidget(CategoryController controller) {
    return controller.status == Status.loading
        ? Center(
      child: CircularProgressIndicator(color: AppColors.green),
    )
        :  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'selected2'.tr,
                style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20.h),
            clipBehavior: Clip.none,
            itemCount: controller.selected.length + 1,
            itemBuilder: (context, index) {
              /// ADD BUTTON — appears only when selected.length < 4
              if (index == controller.selected.length) {
                return GestureDetector(
                  onTap: () {
                    _showFilterBottomSheet(context, controller);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(AppDimensions.borderRadiusMedium.r),
                    dashPattern: [6, 3],
                    // dash, space
                    color: AppColors.green,
                    strokeWidth: 1,
                    child: Container(
                      width: 250.w,
                      height: 200.h,
                      padding: EdgeInsets.all(
                        AppDimensions.paddingExtraLarge.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium.r,
                        ),
                        // boxShadow: softCardShadow,
                        color: AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 50.w,
                              height: 50.h,
                              padding: EdgeInsets.all(
                                AppDimensions.paddingMedium.w,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.dividerColor,
                                  width: 1.w,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppAssets.plusIcon,
                                width: 30.w,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                          Text(
                            'add_services'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                              fontFamily: AppFonts.secondaryFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              /// FAST SERVICE ITEM
              final item = controller.selected[index];

              return GestureDetector(
                onTap: () => controller.onFastServiceTap(index),
                onLongPress: () {
                  controller.removeFastServiceWithConfirm(index, context);
                },
                child: Container(
                  width: 270.w,
                  height: 180.h,
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingExtraLarge.h,
                    horizontal: AppDimensions.paddingExtraLarge.w,
                  ),
                  margin: EdgeInsets.only(right: AppDimensions.marginMedium.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                    border: Border.all(
                      color: AppColors.dividerColor,
                      width: 1.w,
                    ),
                    boxShadow: softCardShadow,
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            padding: EdgeInsets.all(
                              AppDimensions.paddingSmall.w,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.dividerColor,
                                width: 1.w,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(item.icon, width: 70.w),
                          ),
                          SizedBox(width: AppDimensions.paddingMedium),
                          Text(
                            item.title.tr,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.paddingMedium.h,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [

                              if (item.title == 'astu_internet' || item.title == 'telecom_internet') ...[
                                Image.asset(
                                  AppAssets.router,
                                  width: 20.w,
                                  color: AppColors.green,
                                ),
                              ] else  if (item.phone.startsWith('12')) ...[
                                SvgPicture.asset(
                                  AppAssets.oldPhoneIcon,
                                  width: 20.w,
                                  color: AppColors.green,
                                ),
                              ] else ...[
                                SvgPicture.asset(
                                  AppAssets.deviceMobileIcon,
                                  width: 20.w,
                                  color: AppColors.green,
                                ),
                              ],

                              SizedBox(width: AppDimensions.paddingMedium.w),
                              Text(
                                item.phone.startsWith('12')
                                    ? item.phone
                                    : '+993 ${item.phone}',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.secondaryFont,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.paddingMedium.h,),

                          if(item.title == 'TM CELL' || item.title == 'Belet')...[
                            if(item.phone == controller.phoneBox.get('phone'))...[
                              Text(
                                '${item.balance} TMT',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 17.sp,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                              ),
                            ],
                          ]else...[
                            Text(
                              '${item.balance} TMT',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.blackText,
                                fontSize: 17.sp,
                                fontFamily: AppFonts.primaryFont,
                              ),
                            ),
                          ],

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    CategoryController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: AppColors.white,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text('payments'.tr, style: TextStyle(fontSize: 17.sp)),
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
                  return GestureDetector(
                    onTap: () {
                      if (type == 'state_traffic_safety_inspectorate' ||
                          type == 'ÄlemTv') {
                        ShowSnack.showSnack(
                          'payment_temporarily_unavailable'.tr,
                          SnackType.warning,
                        );
                      } else {
                        Navigator.pop(context);

                        Future.delayed(const Duration(milliseconds: 100), () {
                          _showCheckBalanceBottomSheet(context, controller, index);
                        });
                      }
                    },
                    child: Container(
                      width: 190.w,
                      height: 70.h,
                      padding: EdgeInsets.all(AppDimensions.paddingMedium.h),
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
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Image.asset(controller.paymentsIcons[index]),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              type.tr,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: AppFonts.secondaryFont,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCheckBalanceBottomSheet(
    BuildContext context,
    CategoryController controller,
    int index,
  ) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      useRootNavigator: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: AppColors.white,

      builder: (_) {
        return GetBuilder<CategoryController>(
          builder: (controller) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 40.h,
                  bottom: 0.h, // or 0
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.paymentsTitle[index].tr,
                      style: TextStyle(color: AppColors.black, fontSize: 24.sp),
                    ),
                    SizedBox(height: 22.h),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputFillBackground,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium,
                            ),
                          ),
                          child: Text('+993', style: TextStyle(fontSize: 14.sp)),
                        ),
                        SizedBox(width: AppDimensions.paddingSmall.w),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: controller.phoneController,
                            inputFormatters: [
                              if (controller.paymentsTitle[index] ==
                                  'telecom_internet') ...[
                                controller.currentMask,
                              ] else if (controller.paymentsTitle[index] ==
                                  'Belet') ...[
                                controller.beletMask,
                              ] else if (controller.paymentsTitle[index] ==
                                  'TM CELL') ...[
                                controller.beletMask,
                              ] else if (controller.paymentsTitle[index] ==
                                  'CDMA') ...[
                                controller.cdmaMask,
                              ] else ...[
                                controller.defaultMask,
                              ],
                            ],
                            onChanged: (v) {
                              final digits = v.replaceAll(' ', '');

                              controller.currentMask.updateMask(
                                mask: digits.startsWith('12')
                                    ? '## ######'
                                    : '### ######',
                              );
                              controller.isTextNotEmpty(index);
                            },
                            maxLength: 9,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.primaryFont,
                            ),
                            decoration: InputDecoration(
                              hintText: controller.hintText(index),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: controller.status == Status.error
                                      ? AppColors.redDark
                                      : AppColors.green,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: controller.status == Status.error
                                      ? AppColors.redDark
                                      : AppColors.white,
                                  width: 1,
                                ),
                              ),
                              counter: const SizedBox(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingExtraLarge.h,
                                horizontal: AppDimensions.paddingLarge.w,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.contacts,
                                  color: AppColors.green,
                                  size: 20.w,
                                ),
                                onPressed: () async {
                                  controller.contactPicker(index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 22.h),
                    (controller.status != Status.loading)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Opacity(
                              opacity: controller.continueEnabled ? 1 : 0.5,
                              child: ElevatedButtonWithState(
                                isLoading: false,
                                isError: false,
                                onPressed: () {
                                  if (controller.continueEnabled) {
                                    controller.checkBalance(index);

                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  r'confirm'.tr,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (controller.status == Status.loading)
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  List<BoxShadow> softCardShadow = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color(0xFFD5D9D3).withOpacity(0.39),
    ),
    BoxShadow(
      offset: Offset(0, 7),
      blurRadius: 7,
      color: Color(0xFFD5D9D3).withOpacity(0.34),
    ),
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 10,
      color: Color(0xFFD5D9D3).withOpacity(0.20),
    ),
    BoxShadow(
      offset: Offset(0, 29),
      blurRadius: 12,
      color: Color(0xFFD5D9D3).withOpacity(0.06),
    ),
    BoxShadow(
      offset: Offset(0, 45),
      blurRadius: 13,
      color: Color(0xFFD5D9D3).withOpacity(0.01),
    ),
  ];
}
