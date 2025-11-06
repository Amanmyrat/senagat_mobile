import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';

class ProfileController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  String fullName = '';
  String? phone;
  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    refreshProfile();
    phone = phoneBox.get('phone');
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh when screen becomes visible
    refreshProfile();
  }

  void refreshProfile() {
    final savedProfile = profileBox.get('currentProfile');
    phone = phoneBox.get('phone');
    fullName =
        '${savedProfile?.firstName ?? r'name'.tr} ${savedProfile?.lastName ?? r'last_name'.tr}';

    update();
  }
}
