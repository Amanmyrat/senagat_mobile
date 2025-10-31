import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';

class ProfileController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  String fullName = '';
  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    final savedProfile = profileBox.get('currentProfile');
    fullName =
        '${savedProfile?.firstName ?? r'name'.tr} ${savedProfile?.lastName ?? r'last_name'.tr}';
  }

  void refreshProfile() {
    final savedProfile = profileBox.get('currentProfile');
    fullName =
        '${savedProfile?.firstName ?? r'name'.tr} ${savedProfile?.lastName ?? r'last_name'.tr}';
    update();
  }
}
