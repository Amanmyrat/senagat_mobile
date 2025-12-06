import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/controller/dashboard_controller.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';

class ProfileController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  String fullName = '';
  String? phone;
  final homeController = Get.find<HomeController>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void onInit() {
    super.onInit();
    refreshProfile();
  }

  @override
  void onReady() {
    super.onReady();
    refreshProfile();
  }

  Color checkProfileStatus()  {
    final savedProfile = profileBox.get('currentProfile');

    if(savedProfile?.status == 'pending'){
      return AppColors.orange;
    }else if(savedProfile?.status == 'rejected'){
      return AppColors.redDark;
    }else if(savedProfile?.status == 'approved'){
      return AppColors.green;
    }else{
      return AppColors.grey;
    }
  }

  void refreshProfile() {
    final savedProfile = profileBox.get('currentProfile');

    fullName = '${savedProfile?.firstName ?? r'name'.tr} ${savedProfile?.lastName ?? r'last_name'.tr}';

    update();
  }
}
