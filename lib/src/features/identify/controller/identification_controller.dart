import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/welcome/presentation/welcome_screen.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../core/local/key_value_storage_service.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../core/states/stateful_data.dart';
import '../../auth/controller/account_status_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/utils/nested_nav_ids.dart';
import '../../register_confirmation/models/account_model.dart';

class IdentificationController extends GetxController with StateControlMixin {

  final _keyValueStorageService = KeyValueStorageService();
  final _accountLoginStatusController =
      Get.put(AccountLoginStatusController(), permanent: true);

  AccountModel? currentUser;

  void logout() {
    _keyValueStorageService.resetKeys();
    _accountLoginStatusController.getAccountStatus(
      StatefulData.error(ExceptionType.UnauthorizedException),
    );
    update();

    final dashboardController = Get.find<DashboardController>();
    dashboardController.updateCurrentIndex(NestedNavigationIds.home);

    Navigator.of(Get.context!).pushNamedAndRemoveUntil(
        WelcomeScreen.route, (Route<dynamic> route) => false);
  }

}
