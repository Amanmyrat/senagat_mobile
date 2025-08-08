import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget? actionWidget;

  const CustomAppBar({super.key, this.showBack = true, this.actionWidget});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.showBack) {
          Navigator.pop(context);
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
        child: Row(
          mainAxisAlignment: widget.actionWidget == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.showBack) ...[
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
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.greyInactive,
                  width: 1.w,
                  style: BorderStyle.solid,
                ),
              ),
              child: SvgPicture.asset(AppAssets.arrowLeftIcon, width: 20.w),
            ),

            if (widget.actionWidget != null) ...[widget.actionWidget!],
          ],
        ),
      ),
    );
  }
}
