import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/home/models/user_information_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/theme/constants/app_colors.dart';

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

  Color checkCertificateStatus(int index) {
    if (userInformationModel?.certificates?[index].status == 'pending') {
      return AppColors.orange;
    } else if (userInformationModel?.certificates?[index].status ==
        'rejected') {
      return AppColors.redDark;
    } else if (userInformationModel?.certificates?[index].status ==
        'approved') {
      return AppColors.green;
    } else {
      return AppColors.grey;
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
}
