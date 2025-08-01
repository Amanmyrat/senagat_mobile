import 'dart:ui';

class AppColors {
  static const _singleton = AppColors._();

  factory AppColors() => _singleton;

  const AppColors._();

  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightBlack = Color.fromRGBO(30, 30, 30, 1.0);
  static const Color white = Color.fromRGBO(252, 252, 252, 1);
  static const Color grey = Color(0xff9DA1B1); // icons
  static const Color mediumGrey = Color.fromRGBO(227, 227, 227, 1);
  static const Color lighterGrey = Color.fromRGBO(248, 248, 248, 1);
  static const Color extraLightGrey = Color.fromRGBO(245, 242, 245, 1);
  static const Color lightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const Color transparent = Color.fromRGBO(0, 0, 0, 0);
  static const Color redMedium = Color.fromRGBO(200, 80, 64, 1);
  static const Color redLight = Color.fromARGB(255, 240, 138, 138);
  static const Color orange = Color.fromRGBO(238, 116, 20, 1);
  static const Color blue = Color(0xff5879FA);
  static const Color blueDark = Color(0xff0047FF);
  static const Color blueInactive = Color(0xffA2AAB8);
  static const Color blueLight = Color(0xff6690B9);
  static const Color lightBackground = Color(0xffEFF2FF);
  static const Color greenDark = Color(0xff088142);
  static const Color redDark = Color(0xffAA3535);
  static const Color inputFillBackground = Color(0xffE8ECFF);
  static const Color blackText = Color(0xff071026);
  static const Color blackText2 = Color(0xff1C1C1C);
}
