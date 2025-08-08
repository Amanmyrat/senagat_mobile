import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:senagat_mobile/src/features/welcome/presentation/welcome_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initializeSettings() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Get.locale.toString();

    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError) {
            return errorView(snapshot);
          } else {
            return const OnBoard();
          }
        }
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Scaffold waitingView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.senagatIcon, width: 134.w, height: 135.h),
            Text(
              'Senagat töleg',
              style: TextStyle(
                color: AppColors.blackText,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Xolonium',
              ),
            ),
            Text(
              'Оплатить можно практически всё!',
              style: TextStyle(color: AppColors.greyInactive, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
