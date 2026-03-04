import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/auth/controller/account_status_controller.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/credit/presentation/get_credit_screen.dart';
import 'package:senagat_mobile/src/features/get_card/presentation/get_card_screen.dart';
import 'package:senagat_mobile/src/features/home/models/exchange_rate_model.dart';
import 'package:senagat_mobile/src/features/home/models/user_information_model.dart';
import 'package:senagat_mobile/src/features/home/repository/exchage_rate_repository.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/astu_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/belet_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/foundation_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/tmcell_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../check_phone_balance/presentation/check_phone_balance.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../inquiries/presentation/inquiries_screen.dart';
import '../../pay/model/pay_model.dart';
import '../../pay/model/paymet_history_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';
import '../../service_settings/controller/service_settings_controller.dart';

enum HomeTapType { none, qr, foundation, service, notification }

class HomeController extends GetxController with StateControlMixin {
  HomeTapType lastTap = HomeTapType.none;
  int? lastFastServiceTapIndex;
  int? lastServiceTapIndex;
  AccountModel accountModel = AccountModel();
  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  ProfileModel? currentProfile;

  ExchangeRateRepository repository;
  AuthRepository authRepository;
  PaymentRepository paymentRepository;

  late ServiceSettingsController fastServiceController;
  late AddCardController addCardController;
  late AccountLoginStatusController accountLoginStatusController;
  late final PageController pageController;

  final cardBox = Hive.box<CardModel>('cardsBox');
  final payBox = Hive.box<PayModel>('payBox');

  String cardKey = 'card';

  bool isProfileRequired = false;
  bool isServiceRequired = true;

  List<ExchangeRateModel> exchange = [];
  bool _isFetchingExchangeRates = false;
  bool _isFetchingUserInfo = false;

  List<PaymentHistoryModel> history = [];


  UserInformationModel? userInformationModel;

  final List<String> serviceTitles = [
    r'get_inquiries',
    r'get_a_card',
    r'get_a_loan',
  ];

  final List<String> serviceImage = [
    AppAssets.reference,
    AppAssets.paymentCardImage,
    AppAssets.creditIcon,
  ];

  final List<String> serviceRoute = [
    InquiriesScreen.route,
    GetCardScreen.route,
    GetCreditScreen.route,
  ];

  HomeController(this.repository, this.authRepository, this.paymentRepository);

  void onQrScanTap() {
    lastTap = HomeTapType.qr;
    update();
    Get.toNamed(QrCodeScreen.route);
  }

  void onNotificationScanTap() {
    lastTap = HomeTapType.notification;
    update();
    Get.toNamed(NotificationsScreen.route);
  }

  void onFoundationTap() {
    lastTap = HomeTapType.foundation;
    update();
    Get.toNamed(
      FoundationPaymentScreen.route,
      arguments: {
        'selectedServiceTitle': r'charitable_foundation'.tr,
        'isInquiries': false,
        'isFoundation': true,
      },
    );
  }

  void onServiceTap(int index) {
    if (accountLoginStatusController.accountLoginStatus.value !=
        AccountLoginStatus.loggedIn) {
      ShowSnack.showSnack(r'please_login'.tr, SnackType.warning);
      return;
    }
    if (isServiceRequired == false) {
      lastTap = HomeTapType.service;
      lastServiceTapIndex = index;
      update();
      Get.toNamed(serviceRoute[index]);
    } else {
      final message = textStatus();
      ShowSnack.showSnack(
        message.isEmpty ? r'not_confirmed'.tr : message,
        SnackType.warning,
      );
    }
  }

  String textStatus() {
    if (currentProfile?.status == 'pending' && userInformationModel?.profileModel?.status == 'pending') {
      return r'pending'.tr;
    } else if (currentProfile?.status == 'rejected') {
      return 'rejected'.tr;
    } else {
      return '';
    }
  }

  void onFastServiceTap(int index) {
    final item = fastServiceController.selected[index];

    if (item.title == r'state_traffic_safety_inspectorate') {
      Get.toNamed(
        NetAndTvScreen.route,
        arguments: {'selectedServiceTitle': item.title},
      );
    }else if(item.icon == AppAssets.astu){
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': item.title,
        'selectedServiceIcon': item.icon,
      });
    } else {
      final title = item.title;
      final route = title == 'Belet'
          ? BeletPaymentScreen.route
          : title == 'TM CELL'
              ? TmcellPaymentScreen.route
              : AstuPaymentScreen.route;

      Get.toNamed(
        route,
        arguments: {
          'selectedServiceTitle': item.title,
          'selectedServiceIcon': item.icon,
        },
      );
      print(item.title);
    }
  }

  @override
  void onInit() {
    pageController = PageController();
    fastServiceController = Get.find<ServiceSettingsController>();
    addCardController = Get.find<AddCardController>();
    accountLoginStatusController = Get.find<AccountLoginStatusController>();
    currentProfile = profileBox.get('currentProfile');
    ever(accountLoginStatusController.accountLoginStatus, (
      AccountLoginStatus status,
    ) {
      if (status == AccountLoginStatus.loggedIn) {
        getUserProfileInfo();
        loadHistory();
        getExchangeRates();

      }
    });

    // If already logged in on app start, fetch user info immediately
    if (accountLoginStatusController.accountLoginStatus.value ==
        AccountLoginStatus.loggedIn) {
      getUserProfileInfo();
      loadHistory();
      getExchangeRates();

    }

    getExchangeRates();
    checkProfile();
    checkProfileStatus();
    textStatus();

    super.onInit();
  }

  void getExchangeRates() async {
    if (_isFetchingExchangeRates) return;

    // _isFetchingExchangeRates = true;
    status = Status.loading;
    update();

    try {
      final value = await repository.getExchangeRateTypes();

      exchange.clear();
      exchange.addAll(value);

      status = Status.completed;
      update();
    } catch (e) {
      status = Status.error;
      debugPrint("ERROR => $e");
      ApiErrorHandler.handleApiError(e);
    } finally {
      update();
      _isFetchingExchangeRates = false;
    }
  }

  void getUserProfileInfo() async {
    if (_isFetchingUserInfo) return;

    _isFetchingUserInfo = true;
    status = Status.loading;
    update();

    await authRepository
        .getUserInformation()
        .then((value) {
          userInformationModel = value;
          status = Status.completed;
          if (userInformationModel?.profileModel != null) {
            profileBox.put(
              'currentProfile',
              userInformationModel!.profileModel!,
            );
            phoneBox.put('phone', userInformationModel!.phone!);
            currentProfile = userInformationModel!.profileModel!;

          }

          checkProfile();
          checkProfileStatus();
          textStatus();
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        })
        .whenComplete(() {
          _isFetchingUserInfo = false;
        });
  }

  void loadHistory() async {
    status = Status.loading;
    update();

    await paymentRepository.getPaymentHistory().then((value){
       history = value;
       status = Status.completed;
       update();
     }).catchError((e){
       status = Status.error;
       update();
       ApiErrorHandler.handleApiError(e);
       debugPrint(e.toString());
     });
  }

  checkProfile() {
    if(accountLoginStatusController.accountLoginStatus.value ==
        AccountLoginStatus.loggedIn) {
      // Keep in-memory state aligned with persisted state
      currentProfile = profileBox.get('currentProfile');
      if (currentProfile == null &&
          userInformationModel?.profileModel == null) {
        isProfileRequired = true;
        update();
      } else {
        isProfileRequired = false;
        update();
      }
    }
  }

  checkProfileStatus() {
    // Keep in-memory state aligned with persisted state
    currentProfile = profileBox.get('currentProfile');
    // Check both sources - use userInformationModel if available, otherwise fall back to Hive
    final profileStatus = userInformationModel?.profileModel?.status ?? currentProfile?.status;
    if (profileStatus == 'approved') {
      isServiceRequired = false;
      update();
    } else {
      isServiceRequired = true;
      update();
    }
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 11;
    final hidden = '*' * hiddenCount;
    final masked = '$start$hidden$end';

    final buffer = StringBuffer();
    for (int i = 0; i < masked.length; i++) {
      buffer.write(masked[i]);
      if ((i + 1) % 4 == 0 && i != masked.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  String iconByType(String type) {
    switch (type) {
      case 'mobile':
        return AppAssets.deviceMobileIcon;
      case 'charity':
        return AppAssets.foundation;
      case 'belet':
        return AppAssets.beletIcon;
      default:
        return AppAssets.deviceMobileIcon;
    }
  }
  Color checkPaymentsStatus(int index) {
    if (history[index].status == 'pending') {
      return AppColors.orange;
    } else if (history[index].status ==
        'failed') {
      return AppColors.redDark;
    } else if (history[index].status ==
        'confirmed') {
      return AppColors.green;
    } else {
      return AppColors.grey;
    }
  }
  int getFastOperationsCount() {
    final count = fastServiceController.selected.length;
    return count <= 4 ? count + 1 : count;
  }
}
