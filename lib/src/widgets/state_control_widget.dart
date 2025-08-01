import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import 'error_widget.dart';

class StateControlWidget extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? titleWidget;
  final Widget? customAppBar;
  final TextStyle? style;
  final List<Widget> slivers;
  final bool isEmpty;
  final bool isLoading;
  final bool isError;
  final VoidCallback? onError;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final ScrollController? scrollController;
  final Widget? emptyWidget;
  final bool isHome;
  final ScrollPhysics? scrollPhysics;
  final bool isAppBar;

  const StateControlWidget({
    Key? key,
    this.title,
    required this.slivers,
    this.isEmpty = false,
    this.onError,
    this.actions,
    this.style,
    this.backgroundColor,
    this.titleWidget,
    this.customAppBar,
    this.leading,
    this.scrollController,
    this.isLoading = false,
    this.isError = false,
    this.emptyWidget,
    this.isHome = true,
    this.scrollPhysics,
    this.isAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: scrollPhysics,
      slivers: [
        if (isAppBar)
          SliverAppBar(
            floating: true,
            actions: actions,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            title: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(right: AppDimensions.paddingExtraLarge,
                  //       left: AppDimensions.paddingSmall),
                  //   child: SvgPicture.asset(
                  //     color: AppColors.white,
                  //     AppAssets.arrowLeftIcon,
                  //     height: 20.w,
                  //   ),
                  // ),
                  Text(
                    title ?? 'back'.tr,
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.blue,
          ),
        if (isLoading)
          SliverFillViewport(
            viewportFraction: 1,
            padEnds: false,
            delegate: SliverChildListDelegate([
              const Center(
                  child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
              )),
            ]),
          ),
        if (isEmpty)
          SliverFillViewport(
            viewportFraction: 1,
            padEnds: false,
            delegate: SliverChildListDelegate([
              emptyWidget ??
                  Center(
                    child: Text('empty'.tr),
                  ),
            ]),
          ),
        if (isError)
          SliverFillViewport(
            viewportFraction: 1,
            padEnds: false,
            delegate: SliverChildListDelegate([
              CustomErrorWidget(onError: onError),
            ]),
          ),
        if (!isLoading && !isError && !isEmpty) ...slivers,
      ],
    );
  }
}
