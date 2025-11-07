import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/home/models/user_information_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/error_utils.dart';

class InquiriesListController extends GetxController with StateControlMixin {

  AuthRepository authRepository;

  bool _isFetchingUserInfo = false;

  UserInformationModel? userInformationModel;

  InquiriesListController(this.authRepository);

  @override
  void onInit() {
    super.onInit();
    getUserProfileInfo();
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

      update();
    }).catchError((e) {
      status = Status.error;
      update();
      final errorText = ErrorUtils.extractErrorText(e);
      ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
      debugPrint(e.toString());
    })
        .whenComplete(() {
      _isFetchingUserInfo = false;
    });
  }


}
