
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/blank/presentation/blank_screen.dart';
import 'package:senagat_mobile/src/features/home/presentation/home_screen.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/widgets/bottom_nav_bar.dart';
import '../../../utils/constants/app_assets.dart';
import '../controller/dashboard_controller.dart';
import '../utils/custom_navigator.dart';
import '../utils/nested_nav_ids.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
            backgroundColor: Colors.transparent,
        extendBody: true,
        body: WillPopScope(
          onWillPop: _controller.onWillPop,
          child: IndexedStack(
            index: _controller.currentIndex,
            children: const [
              CustomNavigator(
                initialRoute: HomeScreen(),
                nestedId: NestedNavigationIds.home,
              ),
              CustomNavigator(
                initialRoute: BlankScreen(),
                nestedId: NestedNavigationIds.catalog,
              ),
              CustomNavigator(
                initialRoute: BlankScreen(),
                nestedId: NestedNavigationIds.card,
              ),
              CustomNavigator(
                initialRoute: BlankScreen(),
                nestedId: NestedNavigationIds.settings,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: BottomNavBar(
            onTap: (index) {
              _controller.updateCurrentIndex(index);
            },
            currentIndex: _controller.currentIndex,
            backgroundColor: AppColors.lightBackground,
            children: [
              BottomNavBarItem(
                icon: AppAssets.navigationhouseIcon,
                label: 'Home',
              ),
              BottomNavBarItem(
                icon: AppAssets.navigationcardsThreeIcon,
                label: 'Catalog',
              ),
              BottomNavBarItem(
                icon: AppAssets.navigationCreditCardIcon,
                label: 'Card',
              ),
              BottomNavBarItem(
                icon: AppAssets.navigationSettingIcon,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
