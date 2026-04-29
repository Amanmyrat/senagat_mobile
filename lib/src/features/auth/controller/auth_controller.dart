import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';

import '../../../core/control_state_variable_mixin.dart';
import '../../../core/local/key_value_storage_service.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../core/states/stateful_data.dart';
import 'package:get/get.dart';

import 'account_status_controller.dart';

class AuthController extends GetxController with StateControlMixin {
  AccountModel account = AccountModel();
  final _accountLoginStatusController =
      Get.put(AccountLoginStatusController(), permanent: true);

  final _keyValueStorageService = KeyValueStorageService();

  StatefulData<AccountModel> state = StatefulData.empty();

  bool isOneDayOld = false;

  void onAccountUpdate(AccountModel account) {
    state = StatefulData.completed(account);
    status = Status.loading;
    this.account = account;
    _keyValueStorageService.setAuthUser(account);
    _keyValueStorageService.setAuthToken(account.token!);

    update();
    _accountLoginStatusController.getAccountStatus(state);
  }

  void onTokenUpdate(AccountModel account) {
    _keyValueStorageService.setAuthToken(account.token!);
    update();
  }

  void getAccount() async {
    if ((_keyValueStorageService.getAuthUser()) != null) {
      state = StatefulData.loading();
      _accountLoginStatusController.getAccountStatus(state);
      update();

      onAccountUpdate(_keyValueStorageService.getAuthUser()!);
      // _authRepository.getAccount().then((value) {
      //   state = StatefulData.completed(value);
      //   account = value;
      //   _accountLoginStatusController.getAccountStatus(state);
      //   update();
      // }).onError((error, stackTrace) {
      //   state = StatefulData.error(error);
      //   _accountLoginStatusController.getAccountStatus(state);
      //   update();
      // });
    } else {
      _accountLoginStatusController.getAccountStatus(
          StatefulData.error(ExceptionType.UnauthorizedException));
      update();
    }
  }

  @override
  void onInit() {
    getAccount();
    super.onInit();
  }
}
