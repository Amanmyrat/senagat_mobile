import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/controller/dashboard_controller.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';

class ProfileController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  String appVersion = '';
  String? phone;


  @override
  void onInit() {
    super.onInit();
    _loadVersion();

  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    update();
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
}
