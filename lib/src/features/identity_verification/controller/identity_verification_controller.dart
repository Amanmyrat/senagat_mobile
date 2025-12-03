import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import 'package:senagat_mobile/src/features/identity_verification/repository/profile_repository.dart';
import 'package:senagat_mobile/src/features/profile/controller/profile_controller.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';
import 'package:senagat_mobile/src/utils/services/show_snack.dart';
import 'package:senagat_mobile/src/utils/services/error_utils.dart';
import '../../../core/states/stateful_data.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/utils/nested_nav_ids.dart';
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
  late final TextEditingController citizenshipController;
  late final TextEditingController homePhoneController;
  late final TextEditingController homeAddressController;

  final profileBox = Hive.box<ProfileModel>('profileBox');
  final ProfileRepository repository;
  final GlobalKey<FormState> key;

  /// NEW VARIABLES FOR DROPDOWNS
  String? selectedDropdownLetters;
  String? selectedDropdownNumber;

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
    r'place_of_issue',
    r'citizenship',
    r'home_phone',
    r'home_address',
  ];

  final List<String> citySelection = ["AŞ", "AH", "LB", 'MR', 'DŞ'];
  final List<String> number = ["I", "II", "III", 'IV'];

  late List<TextEditingController> controllers;
  File? pdfFile;

  IdentityVerificationController(this.repository, this.key);

  @override
  void onInit() {
    super.onInit();
    ProfileModel? savedProfile;

    try {
      savedProfile = profileBox.get('currentProfile');
    } catch (_) {
      profileBox.delete('currentProfile');
      savedProfile = null;
    }

    /// Extract dropdown values from saved passport number
    if (savedProfile?.passportNumber != null && savedProfile!.passportNumber!.length >= 3) {
      selectedDropdownLetters =
          savedProfile.passportNumber!.substring(0, 2);
      selectedDropdownNumber =
          savedProfile.passportNumber!.substring(2, 3);
    } else {
      selectedDropdownLetters = "AS";
      selectedDropdownNumber = null;
    }

    controllers = [
      nameController = TextEditingController(text: savedProfile?.firstName),
      lastNameController =
          TextEditingController(text: savedProfile?.lastName),
      surNameController =
          TextEditingController(text: savedProfile?.middleName),
      dateOfBirthController =
          TextEditingController(text: savedProfile?.birthDate),
      passportNumberController = TextEditingController(
        text: savedProfile?.passportNumber != null &&
            savedProfile!.passportNumber!.length > 3
            ? savedProfile.passportNumber!.substring(4)
            : savedProfile?.passportNumber ?? '',
      ),
      dateIssueController =
          TextEditingController(text: savedProfile?.issuedDate),
      placeIssueController =
          TextEditingController(text: savedProfile?.issuedBy),
      citizenshipController =
          TextEditingController(text: savedProfile?.citizenship),
      homePhoneController = TextEditingController(
          text: savedProfile?.homePhone.toString()),
      homeAddressController =
          TextEditingController(text: savedProfile?.homeAddress),
    ];
  }

  /// VALIDATION
  void onTextIsNotEmpty(String? v) {
    continueEnabled = controllers.every((c) => c.text.isNotEmpty) &&
        pdfFile != null &&
        selectedDropdownNumber != null &&
        selectedDropdownLetters != null;

    update();
  }

  /// BUILD PROFILE MODEL
  Future<ProfileModel> _getProfileModel() async {
    final passportFile = await _parseImage();

    return ProfileModel(
      firstName: nameController.text,
      lastName: lastNameController.text,
      middleName: surNameController.text,
      birthDate: dateOfBirthController.text,

      /// NEW PASSPORT FORMAT
      passportNumber:
      "${selectedDropdownLetters ?? ''}${selectedDropdownNumber ?? ''}${passportNumberController.text}",

      issuedDate: dateIssueController.text,
      issuedBy: placeIssueController.text,
      passportScan: passportFile,
      citizenship: citizenshipController.text,
      homePhone: int.parse(homePhoneController.text),
      homeAddress: homeAddressController.text,
    );
  }

  /// START VERIFICATION
  Future<void> startBankVerification() async {
    try {
      status = Status.loading;
      update();

      final model = await _getProfileModel();
      final formData = dio.FormData.fromMap(await model.toMap());

      await repository.createProfile(formData);

      status = Status.completed;
      await profileBox.put('currentProfile', model);

      final dashboardController = Get.find<DashboardController>();
      final profileController = Get.find<ProfileController>();
      final homeController = Get.find<HomeController>();

      profileController.refreshProfile();
      homeController.getUserProfileInfo();

      dashboardController.updateCurrentIndex(NestedNavigationIds.settings);
      dashboardController.updateCurrentIndex(NestedNavigationIds.home);

      update();

      Navigator.of(Get.context!).pushNamedAndRemoveUntil(
        DashboardScreen.route,
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      status = Status.error;
      final errorText = ErrorUtils.extractErrorText(e);
      ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
      update();
    }
  }

  /// PICK PDF
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {
      pdfFile = File(result.files.single.path!);
      onTextIsNotEmpty(null);
      update();
    }
  }

  Future<dio.MultipartFile> _parseImage() async {
    final fileName = pdfFile!.path.split('/').last;
    return dio.MultipartFile.fromFile(pdfFile!.path, filename: fileName);
  }

  /// UPDATE DROPDOWNS
  void setDropdownCity(String? value) {
    selectedDropdownLetters = value;
    onTextIsNotEmpty(value);
    update();
  }

  void setDropdownNumber(String? value) {
    selectedDropdownNumber = value;
    onTextIsNotEmpty(value);
    update();
  }

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }

  /// DATE PICKER
  Future<void> pickDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: LocalizationService.defaultLocale,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
      update();
    }
  }
}
