import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../core/states/stateful_data.dart';

enum AccountLoginStatus { error, loggedIn, notLoggedIn, loading, empty }

class AccountLoginStatusController extends GetxController {
  Rx<AccountLoginStatus> accountLoginStatus = AccountLoginStatus.loading.obs;

  void getAccountStatus(StatefulData accountResponse) async {
    final status = accountResponse.status;
    AccountLoginStatus updateLoginStatus;
    switch (status) {
      case Status.completed:
        updateLoginStatus = AccountLoginStatus.loggedIn;
        break;
      case Status.loading:
        updateLoginStatus = AccountLoginStatus.loading;
        break;
      case Status.error:
        if (accountResponse.error == ExceptionType.UnauthorizedException) {
          updateLoginStatus = AccountLoginStatus.notLoggedIn;
        } else {
          updateLoginStatus = AccountLoginStatus.error;
        }
        break;
      default:
        updateLoginStatus = AccountLoginStatus.empty;
        break;
    }
    if (accountLoginStatus.value != updateLoginStatus) {
      accountLoginStatus.value = updateLoginStatus;
    }

    debugPrint(accountLoginStatus.value.toString());
    update();
  }
}
