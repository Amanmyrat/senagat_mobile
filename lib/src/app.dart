import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import 'package:senagat_mobile/src/features/foundation/presentation/foundation_screen.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import 'package:senagat_mobile/src/features/qr_code/presentation/qr_code_screen.dart';
import 'package:senagat_mobile/src/features/register/presentation/register_screen.dart';
import 'package:senagat_mobile/src/features/register_confirmation/presentation/register_confirmation.dart';
import 'package:senagat_mobile/src/features/register_password_setup/presentation/register_password_setup_screen.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';
import 'package:senagat_mobile/src/features/service_settings/presentation/service_settings_screen.dart';
import 'package:senagat_mobile/src/features/welcome/presentation/welcome_screen.dart';
import 'package:senagat_mobile/src/features/splash/presentation/splash_screen.dart';
import 'package:senagat_mobile/src/utils/localization/controller/language_controller.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';
import 'package:senagat_mobile/src/utils/theme/app_theme.dart';
import 'package:senagat_mobile/src/utils/theme/controller/theme_controller.dart';
import 'features/ Inquiries/presentation/inquiries_screen.dart';
import 'features/add_card/controller/add_card_controller.dart';
import 'features/dashboard/controller/dashboard_controller.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/payment_verification/presentation/payment_verification_screen.dart';

class SenagatApp extends StatefulWidget {
  const SenagatApp({super.key});

  @override
  State<SenagatApp> createState() => _SenagatAppState();
}

class _SenagatAppState extends State<SenagatApp> {
  final localizationService = LocalizationService();
  final _box = GetStorage();

  ThemeMode _initThemeMode() {
    bool? isDarkMode = _box.read<bool>(r'theme');
    if (isDarkMode == null) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    }
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);

    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return OverlaySupport(
          child: GetMaterialApp(
            title: 'senagat_mobile',
            localizationsDelegates: LocalizationService.localizationsDelegate(),
            locale: localizationService.getLocale(),
            fallbackLocale: LocalizationService.fallbackLocale,
            translations: localizationService,
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            themeMode: _initThemeMode(),
            initialRoute: DashboardScreen.route,
            initialBinding: DashboardBinding(),
            defaultTransition: Transition.cupertino,
            getPages: [
              GetPage(
                name: DashboardScreen.route,
                page: () => const DashboardScreen(),
              ),
              GetPage(
                name: SplashScreen.route,
                page: () => const SplashScreen(),
              ),
              GetPage(
                name: RegisterScreen.route,
                page: () => const RegisterScreen(),
              ),
              GetPage(
                name: RegisterConfirmationScreen.route,
                page: () => const RegisterConfirmationScreen(),
              ),
              GetPage(
                name: RegisterPasswordSetupScreen.route,
                page: () => const RegisterPasswordSetupScreen(),
              ),
              GetPage(
                name: AuthSuccessScreen.route,
                page: () => const AuthSuccessScreen(),
              ),
              GetPage(
                name: WelcomeScreen.route,
                page: () => const WelcomeScreen(),
              ),
              GetPage(
                name: NotificationsScreen.route,
                page: () => const NotificationsScreen(),
              ),
              GetPage(
                name: AddCardScreen.route,
                page: () => const AddCardScreen(),
              ),
              GetPage(
                name: PaymentScreen.route,
                page: () => const PaymentScreen(),
              ),
              GetPage(
                name: PaymentVerificationScreen.route,
                page: () => const PaymentVerificationScreen(),
              ),
              GetPage(
                name: ServiceSettingsScreen.route,
                page: () => const ServiceSettingsScreen(),
              ),
              GetPage(
                name: QrCodeScreen.route,
                page: () => const QrCodeScreen(),
              ),
              GetPage(
                name: FoundationScreen.route,
                page: () => const FoundationScreen(),
              ),
              GetPage(
                name: NetAndTvScreen.route,
                page: () => const NetAndTvScreen(),
              ),
              GetPage(
                name: InquiriesScreen.route,
                page: () => const InquiriesScreen(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(ServiceSettingsController());
    Get.put(AddCardController());
    Get.put(HomeController());

  }
}
