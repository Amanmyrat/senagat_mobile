import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import 'package:senagat_mobile/src/features/identity_verification/repository/profile_repository.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';
import 'package:senagat_mobile/src/utils/api_error_handler.dart';
import 'package:senagat_mobile/src/widgets/text_input_masks.dart';
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
  String? selectedCity;
  String? selectedRoman;
  String parsedRoman = "";
  String parsedCity = "";
  String parsedNumbers = "";

  bool continueEnabled = false;
  bool check = false;

  final dateFormatter = CustomMaskFormatter(
    mask: '##-##-####', prefix: '',
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

  final List<String> citySelection = ["AŞ", "AH", "LB", 'MR', 'DZ', 'BN'];
  final List<String> number = ["I", "II", "III", 'IV'];

  final defaultMask = CustomMaskFormatter(
    mask: '## ######', prefix: '12',
  );

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

    if (savedProfile?.passportNumber != null) {
      parsePassport(savedProfile?.passportNumber ?? 'aaaa');
    }

    // ------------ CONTROLLERS SETUP -------------
    controllers = [
      nameController = TextEditingController(text: savedProfile?.firstName),
      lastNameController = TextEditingController(text: savedProfile?.lastName),
      surNameController = TextEditingController(text: savedProfile?.middleName),
      dateOfBirthController = TextEditingController(
        text: savedProfile?.birthDate,
      ),

      // use correct numeric part from parsed passport
      passportNumberController = TextEditingController(text: parsedNumbers),

      dateIssueController = TextEditingController(
        text: savedProfile?.issuedDate,
      ),
      placeIssueController = TextEditingController(
        text: savedProfile?.issuedBy,
      ),
      citizenshipController = TextEditingController(
        text: savedProfile?.citizenship,
      ),
      homePhoneController = TextEditingController(
        text: savedProfile?.homePhone.toString(),
      ),
      homeAddressController = TextEditingController(
        text: savedProfile?.homeAddress,
      ),
    ];
  }

  void parsePassport(String value) {
    final regex = RegExp(
      r'^(I|II|III|IV)-(AŞ|AH|LB|MR|DZ|BN)(\d+)$',
    );

    final match = regex.firstMatch(value);

    if (match != null) {
      parsedRoman = match.group(1)!;
      parsedCity = match.group(2)!;
      parsedNumbers = match.group(3)!;

      selectedRoman = parsedRoman;
      selectedCity = parsedCity;
    }
  }

  void onTextIsNotEmpty(String? v) {
    final savedProfile = profileBox.get('currentProfile');

    final isUpdate = savedProfile != null;

    continueEnabled = controllers
        .where(
          (c) =>
      c != homePhoneController &&
          c != surNameController,
    )
        .every((c) => c.text.isNotEmpty) &&
        selectedRoman != null &&
        selectedCity != null &&
        (isUpdate || pdfFile != null);

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

      passportNumber:
      "${selectedRoman ?? ''}-${selectedCity ?? ''}${passportNumberController.text}",

      issuedDate: dateIssueController.text,
      issuedBy: placeIssueController.text,
      passportScan: passportFile,
      citizenship: citizenshipController.text,
      homePhone: int.parse(homePhoneController.text),
      homeAddress: homeAddressController.text,
    );
  }

  Future<ProfileModel> _getUpdatedProfileModel() async {
    final savedProfile = profileBox.get('currentProfile');

    dio.MultipartFile? passportFile;

    if (pdfFile != null) {
      passportFile = await _parseImage();
    }

    final newPassport =
        "${selectedRoman ?? ''}-${selectedCity ?? ''}${passportNumberController.text}";

    print(newPassport);

    return ProfileModel(
      firstName: nameController.text != savedProfile?.firstName
          ? nameController.text
          : null,

      lastName: lastNameController.text != savedProfile?.lastName
          ? lastNameController.text
          : null,

      middleName: surNameController.text != savedProfile?.middleName
          ? surNameController.text
          : null,

      birthDate: dateOfBirthController.text != savedProfile?.birthDate
          ? dateOfBirthController.text
          : null,

      passportNumber: newPassport != savedProfile?.passportNumber
          ? newPassport
          : null,

      issuedDate: dateIssueController.text != savedProfile?.issuedDate
          ? dateIssueController.text
          : null,

      issuedBy: placeIssueController.text != savedProfile?.issuedBy
          ? placeIssueController.text
          : null,

      citizenship: citizenshipController.text != savedProfile?.citizenship
          ? citizenshipController.text
          : null,

      homePhone:
      homePhoneController.text != savedProfile?.homePhone.toString()
          ? int.parse(homePhoneController.text)
          : null,

      homeAddress: homeAddressController.text != savedProfile?.homeAddress
          ? homeAddressController.text
          : null,

      passportScan: passportFile,
    );
  }


  Future<void> createOrUpdateProfile() async {
    try {
      status = Status.loading;
      update();

      final savedProfile = profileBox.get('currentProfile');

      if (savedProfile != null) {
        final updateModel = await _getUpdatedProfileModel();

        final updateMap = await updateModel.toMap();

        updateMap.removeWhere((key, value) => value == null);

        final updateFormData = dio.FormData.fromMap(updateMap);

        await repository.createProfile(updateFormData);
      } else {
        /// CREATE -> send all fields
        final createModel = await _getProfileModel();

        final createFormData = dio.FormData.fromMap(
          await createModel.toMap(),
        );

        await repository.createProfile(createFormData);
      }

      status = Status.completed;

      final oldProfile = profileBox.get('currentProfile');

      final latestProfile = ProfileModel(
        firstName: nameController.text,
        lastName: lastNameController.text,
        middleName: surNameController.text,
        birthDate: dateOfBirthController.text,
        passportNumber:
        "${selectedRoman ?? ''}-${selectedCity ?? ''}${passportNumberController.text}",
        issuedDate: dateIssueController.text,
        issuedBy: placeIssueController.text,
        citizenship: citizenshipController.text,
        homePhone: int.parse(homePhoneController.text),
        homeAddress: homeAddressController.text,

        /// keep server fields
        status: oldProfile?.status,
        rejectedText: oldProfile?.rejectedText,
        passportScan: oldProfile?.passportScan,
      );

      await profileBox.put('currentProfile', latestProfile);

      final dashboardController = Get.find<DashboardController>();
      final homeController = Get.find<HomeController>();

      homeController.getUserProfileInfo();

      dashboardController.updateCurrentIndex(
        NestedNavigationIds.settings,
      );

      dashboardController.updateCurrentIndex(
        NestedNavigationIds.home,
      );

      update();

      Navigator.of(Get.context!).pushNamedAndRemoveUntil(
        DashboardScreen.route,
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      status = Status.error;
      update();
      ApiErrorHandler.handleApiError(e);
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

  Future<dio.MultipartFile?> _parseImage() async {
    if (pdfFile == null) return null;

    final fileName = pdfFile!.path.split('/').last;

    return dio.MultipartFile.fromFile(
      pdfFile!.path,
      filename: fileName,
    );
  }

  /// UPDATE DROPDOWNS
  void setDropdownCity(String? value) {
    selectedCity = value;
    onTextIsNotEmpty(value);
    update();
  }

  void setDropdownNumber(String? value) {
    selectedRoman = value;
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
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: LocalizationService.defaultLocale,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
      update();
    }
  }
}
