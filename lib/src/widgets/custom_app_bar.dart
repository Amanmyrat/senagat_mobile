import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool showBack;
  final Widget? actionWidget;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (showBack) {
          Navigator.pop(context);
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(
          AppDimensions.paddingExtraLarge.w,
        ),
        child: Row(
          mainAxisAlignment: actionWidget == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (showBack) ...[
              // Padding(
              //   padding: const EdgeInsets.only(
              //       right: AppDimensions.paddingSmall,
              //       left: AppDimensions.paddingSmall),
              //   child: SvgPicture.asset(
              //     color: AppColors.white,
              //     AppAssets.arrowLeftIcon,
              //     height: 20.w,
              //   ),
              // ),
            ],
            Text(
              title ?? 'back'.tr,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (actionWidget != null) ...[actionWidget!]
          ],
        ),
      ),
    );
  }
}
