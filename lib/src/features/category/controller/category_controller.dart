import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/check_phone_balance/presentation/check_phone_balance.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/astu_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/belet_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/tmcell_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/telecom_payment_screen.dart';
import 'package:senagat_mobile/src/utils/services/show_snack.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/constants/app_assets.dart';
import '../../check_phone_balance/model/check_balance_model.dart';
import '../../foundation/presentation/foundation_screen.dart';
import '../../pay/repository/payment_repository.dart';
import '../../qr_code/presentation/qr_code_screen.dart';
import '../../service_settings/controller/service_settings_controller.dart';
import '../model/fast_service_model.dart';

enum CategoryTapType { none, qr, service, fastOperation, notification, foundation }

class CategoryController extends GetxController with StateControlMixin {
  CategoryTapType lastTap = CategoryTapType.none;
  late ServiceSettingsController fastServiceController;
  late TextEditingController phoneController;
  late var checkBalanceModel = CheckBalanceModel();
  PaymentRepository repository;
  bool continueEnabled = false;
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  String type = '';
  List<FastServiceItem> selected = [];
  late Box<FastServiceItem> fastBox;

  late bool check = false;

  CategoryController(this.repository);

  final List<String> paymentsIcons = [
    AppAssets.tmCell,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.telecom,
    AppAssets.beletIcon,
    AppAssets.policeCar,
    AppAssets.alemTv,
  ];


  final List<String> paymentsTitle = [
    r'TM CELL',
    r'CDMA',
    r'IP TV',
    r'astu_phone',
    r'astu_internet',
    r'telecom_internet',
    r'Belet',
    r'state_traffic_safety_inspectorate',
    r'ÄlemTv',
  ];

  late MaskTextInputFormatter currentMask = telecomMaskOther;

  final beletMask = MaskTextInputFormatter(
    mask: '########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final telecomMaskOther = MaskTextInputFormatter(
    mask: '### ######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final defaultMask = MaskTextInputFormatter(
    mask: '12 ######',
    filter: { "#": RegExp(r'[0-9]') },
    initialText: "12 ",

  );
  @override
  void onInit() {
    fastServiceController = Get.find<ServiceSettingsController>();
    phoneController = TextEditingController();
    fastBox = Hive.box<FastServiceItem>('fastServices');

    selected = fastBox.values.toList();
    _refreshBalances();
    super.onInit();
  }

  void onQrScanTap() {
    lastTap = CategoryTapType.qr;
    update();
    Get.toNamed(QrCodeScreen.route);
  }
  void onNotificationScanTap() {
    lastTap = CategoryTapType.notification;
    update();
    Get.toNamed(NotificationsScreen.route);
  }


  void onFoundationTap() {
    lastTap = CategoryTapType.foundation;
    update();
    Get.toNamed(FoundationScreen.route);
  }

  void saveFastService(FastServiceItem item) {
    /// remove duplicate
    final existingIndex = fastBox.values.toList().indexWhere(
          (e) => e.phone == item.phone && e.type == item.type,
    );

    if (existingIndex != -1) {
      fastBox.deleteAt(existingIndex);
    }

    fastBox.add(item);

    selected = fastBox.values.toList();

    update();
  }

  void isTextNotEmpty(int index){
    if(paymentsTitle[index] == 'Belet' || paymentsTitle[index] == 'TM CELL'){
      phoneController.text.length >= 8 ? continueEnabled = true : continueEnabled = false;
      update();
    }else {
      phoneController.text.length >= 9
          ? continueEnabled = true
          : continueEnabled = false;
      update();
    }
  }

  void onServiceTap(int index) {

    if (paymentsTitle[index] == r'state_traffic_safety_inspectorate') {
      ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      // Get.toNamed(NetAndTvScreen.route, arguments: {
      //   'selectedServiceTitle': paymentsTitle[index],
      // });
    } else if (paymentsTitle[index] == 'Belet') {
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    }else if (paymentsTitle[index] == 'TM CELL') {
      // ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else if (paymentsTitle[index] == 'ÄlemTv') {
      ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      // Get.toNamed(TmcellPaymentScreen.route, arguments: {
      //   'selectedServiceTitle': paymentsTitle[index],
      //   'selectedServiceIcon': paymentsIcons[index],
      // });
    } else if (paymentsTitle[index] == 'telecom_internet') {
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else if(paymentsIcons[index] == AppAssets.astu){
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else {
      Get.toNamed(AstuPaymentScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    }
  }

  void onFastServiceTap(int index) {

    if (selected[index].title == r'state_traffic_safety_inspectorate') {
      ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      // Get.toNamed(NetAndTvScreen.route, arguments: {
      //   'selectedServiceTitle': paymentsTitle[index],
      // });
    } else if (selected[index].title == 'Belet') {
      Get.toNamed(BeletPaymentScreen.route, arguments: {
        'selectedServiceTitle': selected[index].title,
        'selectedServiceIcon': selected[index].icon,
        'number': selected[index].phone,
        'balance': selected[index].balance,
      });
    }else if (selected[index].title == 'TM CELL') {
      // ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      Get.toNamed(TmcellPaymentScreen.route, arguments: {
        'selectedServiceTitle': selected[index].title,
        'selectedServiceIcon': selected[index].icon,
        'number': selected[index].phone,
        'balance': selected[index].balance,
      });
    } else if (selected[index].title == 'ÄlemTv') {
      ShowSnack.showSnack('payment_temporarily_unavailable'.tr, SnackType.warning);

      // Get.toNamed(TmcellPaymentScreen.route, arguments: {
      //   'selectedServiceTitle': paymentsTitle[index],
      //   'selectedServiceIcon': paymentsIcons[index],
      // });
    } else if (selected[index].title == 'telecom_internet') {
      Get.toNamed(TelecomPaymentScreen.route, arguments: {
        'selectedServiceTitle': selected[index].title,
        'selectedServiceIcon': selected[index].icon,
        'number': selected[index].phone,
        'balance': selected[index].balance,
      });
    } else if(selected[index].icon == AppAssets.astu){
      Get.toNamed(AstuPaymentScreen.route, arguments: {
        'selectedServiceTitle': selected[index].title,
        'selectedServiceIcon': selected[index].icon,
        'number': selected[index].phone,
        'balance': selected[index].balance,
      });
    } else {
      Get.toNamed(AstuPaymentScreen.route, arguments: {
        'selectedServiceTitle': selected[index].title,
        'selectedServiceIcon': selected[index].icon,
      });
    }
  }

  String _cleanSpaces(String phoneNumber) {
    return phoneNumber.replaceAll(' ', '');
  }
  String _clean12(String phoneNumber) {
    return phoneNumber.replaceAll('12 ', '').replaceAll(' ', '');
  }
  Future<CheckBalanceModel> _getTelecomBalanceModel() async {
    return CheckBalanceModel(
      phone: _cleanSpaces(phoneController.text),
    );
  }

  Future<CheckBalanceModel> _getAstuBalanceModel() async {
    return CheckBalanceModel(
      phone: _clean12(phoneController.text),
      type: type,
    );
  }

  Future<CheckBalanceModel> _getBeletBalanceModel() async {
    return CheckBalanceModel(
      phone: _clean12('993${phoneController.text}'),
    );
  }

  Future<void> checkBalance(int index) async {

    if(paymentsTitle[index] == 'telecom_internet'){
      status = Status.loading;
      update();

      final requestModel = await _getTelecomBalanceModel();
      await repository.telecomBalance(data: requestModel.toMap()).then((value){
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;

          final item = FastServiceItem(
            type: 'telecom_internet',
            phone: phoneController.text,
            title: paymentsTitle[index],
            icon: paymentsIcons[index],
            balance: checkBalanceModel.balance,
          );
          saveFastService(item);

          selected.removeWhere((e) =>
          e.phone == item.phone && e.type == item.type);

          selected.add(item);

          update();

        } else {

          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e){
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });

    }else if(paymentsTitle[index] == 'Belet') {
      status = Status.loading;
      update();

      final requestModel = await _getBeletBalanceModel();
      await repository.beletBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;

          final item = FastServiceItem(
            type: 'Belet',
            phone: phoneController.text,
            title: paymentsTitle[index],
            icon: paymentsIcons[index],
            balance: checkBalanceModel.balance,
          );
          saveFastService(item);

          selected.removeWhere((e) =>
          e.phone == item.phone && e.type == item.type);

          selected.add(item);

          update();
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }
    else if(paymentsTitle[index] == 'TM CELL'){
      status = Status.loading;
      update();

      final requestModel = await _getTelecomBalanceModel();
      await repository.tmcellBalance(data: requestModel.toMap()).then((value){
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;

          final item = FastServiceItem(
            type: 'TM CELL',
            phone: phoneController.text,
            title: paymentsTitle[index],
            icon: paymentsIcons[index],
            balance: checkBalanceModel.balance,
          );
          saveFastService(item);

          selected.removeWhere((e) =>
          e.phone == item.phone && e.type == item.type);

          selected.add(item);

          update();

        } else {

          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e){
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });

    }else{
      status = Status.loading;
      update();

      if(paymentsTitle[index] == 'IP TV'){
        type = 'iptv';
      }else if(paymentsTitle[index] == 'astu_phone'){
        type = 'phone';
      }else if(paymentsTitle[index] == 'astu_internet'){
        type = 'internet';
      }else if(paymentsTitle[index] == 'CDMA'){
        type = 'cdma';
      }
      final requestModel = await _getAstuBalanceModel();

      await repository.astuBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;

        if (checkBalanceModel.success == true) {
          status = Status.completed;

          final item = FastServiceItem(
            type: type,
            phone: phoneController.text,
            title: paymentsTitle[index],
            icon: paymentsIcons[index],
            balance: checkBalanceModel.balance,
          );
          saveFastService(item);
          selected.removeWhere((e) =>
          e.phone == item.phone && e.type == item.type);

          selected.add(item);

          update();

        } else {

          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }

      }).catchError((e) {

        status = Status.error;
        update();

        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());

      });

    }

    phoneController.clear();
  }

  void removeFastServiceWithConfirm(int index, BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("remove_service".tr),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,

            child: Text("no".tr),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          CupertinoDialogAction(
            child: Text("yes".tr),
            onPressed: () { fastBox.deleteAt(index);
            selected = fastBox.values.toList();
            update();

            Get.back(); // close dialog
              },
          ),
        ],
      ),
    );
  }

  Future<void> _refreshBalances() async {
    for (var item in selected) {
      phoneController.text = item.phone;
      type = item.type;

      int index = paymentsTitle.indexOf(item.title);
      if (index != -1) {
        await checkBalance(index);
      }
    }
  }

  Future<void> contactPicker(int index) async {
    try {
      final Contact? contact = await _contactPicker.selectContact();
      if (contact == null) {
        print('No contact selected');
        return;
      }

      String? phone = contact.selectedPhoneNumber;

      // If selectedPhoneNumber is null, use the first phone number if available
      if (phone == null && contact.phoneNumbers != null) {
        phone = contact.phoneNumbers?.first ?? '';
      }

      if (phone == null) {
        print('Contact has no phone number');
        return;
      }

      // Remove +993 or leading 8
      if (phone.startsWith('+993')) {
        phone = phone.substring(4);
      } else if (phone.startsWith('8')) {
        phone = phone.substring(1);
      }

      print('Phone after formatting: $phone');
      phoneController.text = phone;
      isTextNotEmpty(index);
      update();
    } catch (e) {
      print('Contact picker cancelled or failed: $e');
    }
  }

  String hintText(int index){
    if( paymentsTitle[index] == 'telecom_internet'){
      return '12 xxxxxx / xxx xxxxxx';
    }else if(paymentsTitle[index] == 'Belet' || paymentsTitle[index] == 'TM CELL'){
      return 'xxxxxxxx';
    }else{
      return '12 xxxxxx';
    }

  }
}
