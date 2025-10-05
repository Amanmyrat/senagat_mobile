import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../core/networking/custom_exception.dart';
import '../models/profile_model.dart';

class IdentityVerificationController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController surNameController;
  late final TextEditingController dateOfBirthController;
  late final TextEditingController dateIssueController;
  late final TextEditingController placeIssueController;
  late final TextEditingController passportNumberController;
  late final TextEditingController asController;

  final AuthRepository repository;
  final GlobalKey<FormState> key;

  bool continueEnabled = false;
  bool check = false;

  final dateFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  List<String> textFieldTitle = [
    r'name',
    r'last_name',
    r'surname',
    r'date_birth',
    r'passport_number',
    r'date_issue',
  ];

  final List<String> citySelection = ["Option 1", "Option 2", "Option 3"];

  late List<TextEditingController> controllers;

  IdentityVerificationController(this.repository, this.key);

  @override
  void onInit() {
    super.onInit();
    controllers = [
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      surNameController = TextEditingController(),
      dateOfBirthController = TextEditingController(),
      passportNumberController = TextEditingController(),
      dateIssueController = TextEditingController(),
      placeIssueController = TextEditingController(),
      asController = TextEditingController(),
    ];
  }

  void onTextIsNotEmpty(String? v) {
    if (nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        surNameController.text.isNotEmpty &&
        dateOfBirthController.text.isNotEmpty &&
        passportNumberController.text.isNotEmpty &&
        dateIssueController.text.isNotEmpty &&
        asController.text.isNotEmpty &&
        placeIssueController.text.isNotEmpty &&
        pdfFile != null) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  String? _encodeFileToBase64(File? file) {
    if (file == null) return null;
    final bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  }

  ProfileModel _getProfileModel() {
    return ProfileModel(
      firstName: nameController.text,
      lastName: lastNameController.text,
      middleName: surNameController.text,
      birthDate: dateOfBirthController.text,
      passportNumber: passportNumberController.text,
      issuedDate: dateIssueController.text,
      issuedBy: placeIssueController.text,
      gender: 'male',
      passportScan: File(AppAssets.pdf),
    );
  }

  // Future<void> startBankVerification() async {
  //   // if (key.currentState?.validate() ?? false) {
  //   //   key.currentState!.save();
  //
  //   final profileModel = _getProfileModel();
  //   await repository
  //       .createProfileWithFile(profileModel: profileModel)
  //       .then((value) {
  //         status = Status.completed;
  //         print(value);
  //         update();
  //         Get.offAllNamed(DashboardScreen.route);
  //       })
  //       .catchError((e) {
  //         status = Status.error;
  //         update();
  //
  //         // Enhanced error logging
  //         debugPrint('=== Profile Creation Error ===');
  //         debugPrint('Error type: ${e.runtimeType}');
  //         debugPrint('Error message: $e');
  //
  //         // Check if it's a CustomException and get detailed info
  //         if (e is CustomException) {
  //           debugPrint('CustomException name: ${e.name}');
  //           debugPrint('CustomException message: ${e.message}');
  //           debugPrint('CustomException exceptionType: ${e.exceptionType}');
  //           debugPrint('CustomException statusCode: ${e.statusCode}');
  //           debugPrint('CustomException code: ${e.code}');
  //         } else {
  //           debugPrint('Exception is not a CustomException: ${e.runtimeType}');
  //         }
  //
  //         debugPrint('Profile model: ${profileModel.toString()}');
  //         debugPrint('=== End Error Details ===');
  //
  //         // Show user-friendly error message
  //         String errorMessage = r'error'.tr;
  //         if (e is CustomException && e.message.contains('413')) {
  //           errorMessage = 'File is too large. Please try with a smaller file.';
  //         }
  //         ShowSnack.showSnack(errorMessage, SnackType.error);
  //       });
  //   // }
  // }
  Future<void> startBankVerification() async {
    // if (key.currentState?.validate() ?? false) {
    //   key.currentState!.save();
    final profileModel = _getProfileModel();
    await repository
        .createProfile(data: await profileModel.toMap())
        .then((value) {
          status = Status.completed;
          update();
          Get.offAllNamed(DashboardScreen.route);
        })
        .catchError((e) {
      status = Status.error;
      update();

      if (e is CustomException) {
        debugPrint('=== CustomException ===');
        debugPrint('Name: ${e.name}');
        debugPrint('Message: ${e.message}');
        debugPrint('StatusCode: ${e.statusCode}');
        debugPrint('Code: ${e.code}');
        debugPrint('Type: ${e.exceptionType}');
        debugPrint('=======================');

        ShowSnack.showSnack(e.message.isNotEmpty ? e.message : 'Unknown error', SnackType.error);
      } else {
        debugPrint('Unhandled exception: $e');
        ShowSnack.showSnack('Unexpected error occurred', SnackType.error);
      }
    });

    // }
  }

  File? pdfFile;

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {
      pdfFile = File(result.files.single.path!);
      update();
    }
  }

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
}
