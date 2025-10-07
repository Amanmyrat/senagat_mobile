import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../identity_verification/models/profile_model.dart';


class ProfileController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {

  final profileBox = Hive.box<ProfileModel>('profileBox');
  late final String fullName;

  @override
  void onInit() {
    super.onInit();
   final savedProfile = profileBox.get('currentProfile');
   fullName = '${savedProfile!.firstName} ${savedProfile.lastName}';
  }
}
