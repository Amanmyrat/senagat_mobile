import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/theme/constants/app_dimensions.dart';

class EmptyWidget extends StatelessWidget {
  final String? lightModeLogo;
  final String? darkModeLogo;
  final String title;
  final String? subtitle;
  const EmptyWidget(
      {super.key, this.lightModeLogo, this.darkModeLogo,
      required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(darkModeLogo != null || lightModeLogo != null)
            SvgPicture.asset(
              Get.isDarkMode ? darkModeLogo! : lightModeLogo!,
              height: 170.h,
            ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18.sp),
            ),
          ),
          if(subtitle != null)
            Text(
              textAlign: TextAlign.center,
              subtitle!,
              style:
              Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
            ),
        ],
      ),
    );
  }
}
