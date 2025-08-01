import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/blank/presentation/blank_screen.dart';
import 'package:senagat_mobile/src/widgets/bottom_nav_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../controller/dashboard_controller.dart';
import '../utils/custom_navigator.dart';
import '../utils/nested_nav_ids.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/';

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
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _controller.onWillPop,
            child: IndexedStack(
              index: _controller.currentIndex,
              children: const [
                CustomNavigator(
                  initialRoute: BlankScreen(),
                  nestedId: NestedNavigationIds.contacts,
                ),
                CustomNavigator(
                  initialRoute: BlankScreen(),
                  nestedId: NestedNavigationIds.chats,
                ),
                CustomNavigator(
                  initialRoute: BlankScreen(),
                  nestedId: NestedNavigationIds.services,
                ),
                CustomNavigator(
                  initialRoute: BlankScreen(),
                  nestedId: NestedNavigationIds.profile,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          onTap: (index) {
            _controller.updateCurrentIndex(index);
          },
          currentIndex: _controller.currentIndex,
          backgroundColor: AppColors.lightBackground,
          children: [
            // BottomNavBarItem(
            //   icon: AppAssets.navigationContacts,
            // ),
            // BottomNavBarItem(
            //   icon: AppAssets.navigationChats,
            // ),
            // BottomNavBarItem(
            //   icon: AppAssets.navigationServices,
            // ),
            // BottomNavBarItem(
            //   icon: AppAssets.navigationProfile,
            // ),
          ],
        ),
      ),
    );
  }
}
