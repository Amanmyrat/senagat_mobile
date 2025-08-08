// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:senagat_mobile/src/features/home/presentation/home_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';

import '../../../utils/theme/constants/app_colors.dart';
import '../controller/dashboard_controller.dart';
import '../utils/custom_navigator.dart';
import '../utils/nested_nav_ids.dart';
import '../../blank/presentation/blank_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = Get.find();
  late PersistentTabController _navController;

  @override
  void initState() {
    super.initState();
    _navController = PersistentTabController(
      initialIndex: _controller.currentIndex,
    );

    // Sync PersistentTabController when GetX index changes
    ever<int>(_controller.currentIndexRx, (index) {
      if (_navController.index != index) {
        _navController.index = index;
      }
    });
  }

  List<Widget> _buildScreens() {
    return [
      CustomNavigator(
        initialRoute: const HomeScreen(),
        nestedId: NestedNavigationIds.home,
      ),
      CustomNavigator(
        initialRoute: const HomeScreen(),
        nestedId: NestedNavigationIds.catalog,
      ),
      CustomNavigator(
        initialRoute: const HomeScreen(),
        nestedId: NestedNavigationIds.card,
      ),
      CustomNavigator(
        initialRoute: const HomeScreen(),
        nestedId: NestedNavigationIds.settings,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.navigationhouseIcon,
          color: AppColors.green,
          width: 24.w,
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.navigationhouseIcon,
          color: AppColors.greyInactive,
          width: 24.w,
        ),
        title: r"home".tr,
        textStyle: TextStyle(fontSize: 14.sp),
        activeColorPrimary: AppColors.inputFillBackground,
        activeColorSecondary: AppColors.green,
        inactiveColorPrimary: AppColors.greyInactive,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.navigationcardsThreeIcon,
          color: AppColors.green,
          width: 24.w,
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.navigationcardsThreeIcon,
          color: AppColors.greyInactive,
          width: 24.w,
        ),
        title: r"catalog".tr,
        textStyle: TextStyle(fontSize: 14.sp),
        activeColorPrimary: AppColors.inputFillBackground,
        activeColorSecondary: AppColors.green,
        inactiveColorPrimary: AppColors.greyInactive,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.navigationCreditCardIcon,
          color: AppColors.green,
          width: 24.w,
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.navigationCreditCardIcon,
          color: AppColors.greyInactive,
          width: 24.w,
        ),
        title: r"card".tr,
        textStyle: TextStyle(fontSize: 14.sp),
        activeColorPrimary: AppColors.inputFillBackground,
        activeColorSecondary: AppColors.green,
        inactiveColorPrimary: AppColors.greyInactive,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.navigationSettingIcon,
          color: AppColors.green,
          width: 24.w,
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.navigationSettingIcon,
          color: AppColors.greyInactive,
          width: 24.w,
        ),
        title: r"setting".tr,
        textStyle: TextStyle(fontSize: 14.sp),
        activeColorPrimary: AppColors.inputFillBackground,
        activeColorSecondary: AppColors.green,
        inactiveColorPrimary: AppColors.greyInactive,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _controller.onWillPop,
      child: PersistentTabView(
        context,
        controller: _navController,
        screens: _buildScreens(),
        items: _navBarItems(),
        backgroundColor: AppColors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: false, // GetX handles it
        navBarHeight: 68,
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.marginExtraLarge.w,
          vertical: AppDimensions.marginMedium.h,
        ),

        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(6.r),
          colorBehindNavBar: Colors.white,
          useBackdropFilter: false,
          border: Border.all(
            color: AppColors.lightGrey,
            style: BorderStyle.solid,
            width: 1.w,
          ),
        ),

        navBarStyle: NavBarStyle.style10, // Style 9

        onItemSelected: (index) {
          _controller.updateCurrentIndex(index);
        },
      ),
    );
  }
}
