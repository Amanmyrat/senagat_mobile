import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/home/presentation/home_screen.dart';

class CustomNavigator extends StatelessWidget {
  final Widget initialRoute;
  final int nestedId;

  const CustomNavigator({
    required this.initialRoute,
    required this.nestedId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(nestedId),
      onGenerateRoute: _routes(initialRoute),
    );
  }

  RouteFactory _routes(Widget initialRoute) {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case HomeScreen.route:
          screen = initialRoute;
          break;
        default:
          screen = initialRoute;
          break;
      }
      return GetPageRoute(
        routeName: settings.name,
        page: () => screen,
        transition: Transition.cupertino,
        curve: Curves.fastOutSlowIn,

      );
    };
  }
}
