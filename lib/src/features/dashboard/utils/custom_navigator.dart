import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/blank/presentation/blank_screen.dart';

class CustomNavigator extends StatelessWidget {
  final Widget initialRoute;
  final int nestedId;

  const CustomNavigator(
      {required this.initialRoute, required this.nestedId, Key? key})
      : super(key: key);

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
        case BlankScreen.route:
          screen = initialRoute;
          break;
        default:
          screen = const Center(
            child: Text(r'route is not found'),
          );
          break;
      }
      return GetPageRoute(
          routeName: settings.name,
          page: () => screen,
          transition: Transition.cupertino,
          curve: Curves.fastOutSlowIn);
    };
  }
}
