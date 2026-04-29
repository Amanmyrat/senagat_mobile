import 'package:flutter/cupertino.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';

import '../../../core/control_state_variable_mixin.dart';
import '../../../core/local/key_value_storage_service.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../core/states/stateful_data.dart';
import 'package:get/get.dart';

import 'account_status_controller.dart';

class AuthController extends GetxController with StateControlMixin {
  AccountModel account = AccountModel();

  final _accountLoginStatusController = Get.put(
    AccountLoginStatusController(),
    permanent: true,
  );

  final _keyValueStorageService = KeyValueStorageService();

  StatefulData<AccountModel> state = StatefulData.empty();

  bool isOneDayOld = false;

  Future<void> onAccountUpdate(AccountModel account) async {
    debugPrint('[AuthController] onAccountUpdate called: id=${account.id}, phone=${account.phoneNumber}, token=${account.token?.length ?? 0} chars');
    
    state = StatefulData.completed(account);
    status = Status.loading;
    this.account = account;

    debugPrint('[AuthController] Saving user to storage...');
    await _keyValueStorageService.setAuthUser(account);

    final token = account.token;
    if (token != null && token.isNotEmpty) {
      debugPrint('[AuthController] Saving token to storage...');
      await _keyValueStorageService.setAuthToken(token);
    } else {
      debugPrint('[AuthController] Token is null or empty, skipping token save');
    }

    debugPrint('[AuthController] onAccountUpdate completed successfully');
    update();
    _accountLoginStatusController.getAccountStatus(state);
  }

  Future<void> onTokenUpdate(AccountModel account) async {
    final token = account.token;
    if (token != null && token.isNotEmpty) {
      await _keyValueStorageService.setAuthToken(token);
    }

    update();
  }

  Future<void> getAccount() async {
    debugPrint('[AuthController] getAccount() called on init...');
    final user = await _keyValueStorageService.getAuthUser();

    if (user != null) {
      debugPrint('[AuthController] Found stored user: id=${user.id}, phone=${user.phoneNumber}');
      state = StatefulData.loading();
      _accountLoginStatusController.getAccountStatus(state);
      update();

      await onAccountUpdate(user);
    } else {
      debugPrint('[AuthController] No stored user found, treating as unauthorized');
      _accountLoginStatusController.getAccountStatus(
        StatefulData.error(ExceptionType.UnauthorizedException),
      );
      update();
    }
  }

  @override
  void onInit() {
    getAccount();
    super.onInit();
  }
}
