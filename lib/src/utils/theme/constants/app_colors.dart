import 'dart:ui';

class AppColors {
  static const _singleton = AppColors._();

  factory AppColors() => _singleton;

  const AppColors._();

  static const Color black = Color(0xff191B19);
  static const Color lightBlack = Color.fromRGBO(30, 30, 30, 1.0);
  static const Color white = Color(0xffEEF2ED);
  static const Color grey = Color(0xff6F736D); // icons
  static const Color mediumGrey = Color.fromRGBO(227, 227, 227, 1);
  static const Color lighterGrey = Color.fromRGBO(248, 248, 248, 1);
  static const Color extraLightGrey = Color.fromRGBO(245, 242, 245, 1);
  static const Color lightGrey = Color(0xffE6EAE3);
  static const Color transparent = Color.fromRGBO(0, 0, 0, 0);
  static const Color redMedium = Color.fromRGBO(200, 80, 64, 1);
  static const Color redLight = Color.fromARGB(255, 240, 138, 138);
  static const Color orange = Color(0xffB97E00);
  static const Color orangeLight = Color(0xffD4A43B);
  static const Color blue = Color(0xff5B85EE);
  static const Color greyInactive = Color(0xff6F736D);
  static const Color blueLight = Color(0xffC0CDEF);
  static const Color lightBackground = Color(0xffEEF2ED);
  static const Color green = Color(0xff2C702C);
  static const Color lightGreen = Color(0xff769983);
  static const Color redDark = Color(0xffCC1717);
  static const Color inputFillBackground = Color(0xffE6EAE3);
  static const Color blackText = Color(0xff191B19);
  static const Color blackText2 = Color(0xff1C1C1C);
  static const Color dividerColor = Color(0xffDADFD8);

}