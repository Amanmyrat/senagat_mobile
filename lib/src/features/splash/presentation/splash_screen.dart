import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = r'/splash';

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
        child: Container(color: Colors.red,)
        // child: SvgPicture.asset(AppAssets.splashAsset,fit: BoxFit.fitWidth,)
      ),
    );
  }
}

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
