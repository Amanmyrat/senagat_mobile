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
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/services/show_snack.dart';
import '../../foundation/presentation/foundation_screen.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../inquiries/presentation/inquiries_screen.dart';
import '../../pay/model/pay_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';
import '../../service_settings/controller/service_settings_controller.dart';
import '../../profile/controller/profile_controller.dart';

enum HomeTapType { none, qr, foundation, service, fastOperation, notification }

class HomeController extends GetxController with StateControlMixin {
  HomeTapType lastTap = HomeTapType.none;
  int? lastFastServiceTapIndex;
  int? lastServiceTapIndex;
  AccountModel accountModel = AccountModel();
  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');

  ExchangeRateRepository repository;
  AuthRepository authRepository;

  late ServiceSettingsController fastServiceController;
  late AddCardController addCardController;
  late AccountLoginStatusController accountLoginStatusController;

  final cardBox = Hive.box<CardModel>('cardsBox');
  final payBox = Hive.box<PayModel>('payBox');

  String cardKey = 'card';

  bool isProfileRequired = true;

  final _exchange = <ExchangeRateModel>[];
  List<ExchangeRateModel> get exchange => _exchange;
  bool _isFetchingExchangeRates = false;
  bool _isFetchingUserInfo = false;

  UserInformationModel? userInformationModel;

  final List<String> serviceTitles = [r'inquiries', r'cards', r'credits'];

  final List<String> serviceSecondaryTitles = [
    r'get_any_type_of_help',
    r'get_a_card_in_just_a_few_seconds',
    r'get_a_credit_in_just_a_few_seconds',
  ];

  final List<String> serviceImage = [
    AppAssets.spreadsheet,
    AppAssets.threeDCard,
    AppAssets.threeDPercent,
  ];

  final List<String> serviceRoute = [
    InquiriesScreen.route,
    GetCardScreen.route,
    GetCreditScreen.route,
  ];

  HomeController(this.repository, this.authRepository);

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
    Get.toNamed(FoundationScreen.route);
  }

  void onServiceTap(int index) {
    if (!isProfileRequired) {
      lastTap = HomeTapType.service;
      lastServiceTapIndex = index;
      update();
      Get.toNamed(serviceRoute[index]);
    } else {
      ShowSnack.showSnack(r'most_functions'.tr, SnackType.warning);
    }
  }

  void onFastServiceTap(int index) {
    lastTap = HomeTapType.fastOperation;
    lastFastServiceTapIndex = index;
    update();

    if (fastServiceController.selectedServiceTitle[index] == r'net_and_TV') {
      Get.offNamed(
        NetAndTvScreen.route,
        arguments: {
          'selectedServiceTitle':
              fastServiceController.selectedServiceTitle[index],
        },
      );
    } else {
      Get.offNamed(
        PaymentScreen.route,
        arguments: {
          'selectedServiceTitle':
              fastServiceController.selectedServiceTitle[index],
          'selectedServiceIcon':
              fastServiceController.selectedServiceIcons[index],
        },
      );
    }
  }

  @override
  void onInit() {
    fastServiceController = Get.find<ServiceSettingsController>();
    addCardController = Get.find<AddCardController>();
    accountLoginStatusController = Get.find<AccountLoginStatusController>();

    // Listen to login status changes and fetch data when user logs in
    ever(accountLoginStatusController.accountLoginStatus, (
      AccountLoginStatus status,
    ) {
      if (status == AccountLoginStatus.loggedIn) {
        getUserProfileInfo();
        getExchangeRates();
      }
    });

    // Also check initial status
    if (accountLoginStatusController.accountLoginStatus.value ==
        AccountLoginStatus.loggedIn) {
      getUserProfileInfo();
      getExchangeRates();
    }

    super.onInit();
  }

  void getExchangeRates() async {
    if (_isFetchingExchangeRates) return;

    _isFetchingExchangeRates = true;
    status = Status.loading;
    update();

    await repository
        .getExchangeRateTypes()
        .then((value) {
          _exchange.clear();
          _exchange.addAll(value);
          status = Status.completed;
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ShowSnack.showSnack(r'error'.tr, SnackType.error);
          debugPrint(e.toString());
        })
        .whenComplete(() {
          _isFetchingExchangeRates = false;
        });
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

            // Notify ProfileController to refresh
            try {
              final profileController = Get.find<ProfileController>();
              profileController.refreshProfile();
            } catch (e) {
              // ProfileController might not be initialized yet
            }
          }

          checkProfile();
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ShowSnack.showSnack(r'error'.tr, SnackType.error);
          debugPrint(e.toString());
        })
        .whenComplete(() {
          _isFetchingUserInfo = false;
        });
  }

  checkProfile() {
    if (userInformationModel?.profileModel == null) {
      isProfileRequired = true;
    } else {
      isProfileRequired = false;
    }
  }

  getFastOperationsCount() {
    return fastServiceController.selectedServiceTitle.length <= 4
        ? fastServiceController.selectedServiceTitle.length + 1
        : fastServiceController.selectedServiceTitle.length;
  }
}
