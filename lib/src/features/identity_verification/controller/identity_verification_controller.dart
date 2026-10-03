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
import 'package:senagat_mobile/src/utils/api_error_handler.dart';
import 'package:senagat_mobile/src/utils/services/show_snack.dart';
import 'package:senagat_mobile/src/widgets/input_formatter.dart';
import 'package:senagat_mobile/src/widgets/text_input_masks.dart';
import '../../../core/states/stateful_data.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/utils/nested_nav_ids.dart';
import '../models/profile_model.dart';

class IdentityVerificationController extends GetxController with StateControlMixin {
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

  String? selectedCity;
  String? selectedRoman;

  bool continueEnabled = false;
  String? validationMessage;
  String? profileStatus;
  List<String> rejectedReasons = [];

  static final _passportPattern = RegExp(
    r'^(I|II|III|IV)-(AŞ|AH|LB|MR|DZ|BN)\s*(\d+)$',
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

  final homePhoneFormatter = DynamicPhoneFormatter();

  late List<TextEditingController> controllers;
  File? pdfFile;

  bool get isUnderReview => profileStatus == 'pending';

  String? get pdfFileName => pdfFile?.path.split('/').last;

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

    profileStatus = savedProfile?.status;
    rejectedReasons = List<String>.from(savedProfile?.rejectedText ?? []);

    var parsedNumbers = '';
    if (savedProfile?.passportNumber != null) {
      final parsed = _parsePassport(savedProfile!.passportNumber!);
      selectedRoman = parsed.$1;
      selectedCity = parsed.$2;
      parsedNumbers = parsed.$3;
    }

    controllers = [
      nameController = TextEditingController(text: savedProfile?.firstName),
      lastNameController = TextEditingController(text: savedProfile?.lastName),
      surNameController = TextEditingController(text: savedProfile?.middleName),
      dateOfBirthController = TextEditingController(
        text: _displayDate(savedProfile?.birthDate),
      ),
      passportNumberController = TextEditingController(text: parsedNumbers),
      dateIssueController = TextEditingController(
        text: _displayDate(savedProfile?.issuedDate),
      ),
      placeIssueController = TextEditingController(
        text: savedProfile?.issuedBy,
      ),
      citizenshipController = TextEditingController(
        text: savedProfile?.citizenship,
      ),
      homePhoneController = TextEditingController(
        text: _displayHomePhone(savedProfile?.homePhone),
      ),
      homeAddressController = TextEditingController(
        text: savedProfile?.homeAddress,
      ),
    ];

    for (final controller in [
      nameController,
      lastNameController,
      surNameController,
    ]) {
      controller.addListener(() => _keepFirstLetterUpper(controller));
    }

    onTextIsNotEmpty(null);
  }

  void _keepFirstLetterUpper(TextEditingController controller) {
    final updated = capitalizeFirstLetter(controller.text);
    if (updated == controller.text) return;

    final offset = controller.selection.extentOffset;
    controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(
        offset: offset < 0 ? updated.length : offset.clamp(0, updated.length),
      ),
    );
  }

  (String?, String?, String) _parsePassport(String value) {
    final match = _passportPattern.firstMatch(value.trim());
    if (match != null) {
      return (match.group(1), match.group(2), match.group(3)!);
    }

    final digits = RegExp(r'(\d+)$').firstMatch(value.trim())?.group(1) ?? '';
    final clipped = digits.length > 6 ? digits.substring(digits.length - 6) : digits;
    return (null, null, clipped);
  }

  String _normalizePassport(String? value) {
    if (value == null) return '';
    final match = _passportPattern.firstMatch(value.trim());
    if (match == null) return value.trim();
    return '${match.group(1)}-${match.group(2)} ${match.group(3)}';
  }

  String buildPassportNumber() {
    final digits = passportNumberController.text.replaceAll(RegExp(r'\D'), '');
    return '${selectedRoman ?? ''}-${selectedCity ?? ''} $digits';
  }

  String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  String _displayHomePhone(int? phone) {
    if (phone == null) return '';
    final digits = phone.toString();
    final mask = digits.startsWith('12') ? '## ######' : '### ######';
    final formatted = StringBuffer();
    var digitIndex = 0;
    for (var i = 0; i < mask.length && digitIndex < digits.length; i++) {
      if (mask[i] == '#') {
        formatted.write(digits[digitIndex]);
        digitIndex++;
      } else {
        formatted.write(mask[i]);
      }
    }
    return formatted.toString();
  }

  int? _homePhoneOrNull() {
    final digits = _digits(homePhoneController.text);
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  DateTime? tryParseDate(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final dayFirst = RegExp(r'^(\d{2})[./-](\d{2})[./-](\d{4})$').firstMatch(text);
    if (dayFirst != null) {
      return _validDate(
        int.parse(dayFirst.group(3)!),
        int.parse(dayFirst.group(2)!),
        int.parse(dayFirst.group(1)!),
      );
    }

    final yearFirst = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(text);
    if (yearFirst != null) {
      return _validDate(
        int.parse(yearFirst.group(1)!),
        int.parse(yearFirst.group(2)!),
        int.parse(yearFirst.group(3)!),
      );
    }
    return null;
  }

  DateTime? _validDate(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) return null;
    return date;
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  String _displayDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final parsed = tryParseDate(raw);
    if (parsed == null) return raw.trim();
    return formatDate(parsed);
  }

  bool _filled(TextEditingController controller) =>
      controller.text.trim().isNotEmpty;

  void onTextIsNotEmpty(String? v) {
    final savedProfile = profileBox.get('currentProfile');
    final isUpdate = savedProfile != null;
    final passportDigits = _digits(passportNumberController.text);
    final homeDigits = _digits(homePhoneController.text);
    final birth = tryParseDate(dateOfBirthController.text);
    final issued = tryParseDate(dateIssueController.text);

    final currentPassport = _normalizePassport(buildPassportNumber());
    final savedPassport = _normalizePassport(savedProfile?.passportNumber);

    final hasChanges = nameController.text.trim() != (savedProfile?.firstName ?? '') ||
        lastNameController.text.trim() != (savedProfile?.lastName ?? '') ||
        surNameController.text.trim() != (savedProfile?.middleName ?? '') ||
        _displayDate(dateOfBirthController.text) != _displayDate(savedProfile?.birthDate) ||
        currentPassport != savedPassport ||
        _displayDate(dateIssueController.text) != _displayDate(savedProfile?.issuedDate) ||
        placeIssueController.text.trim() != (savedProfile?.issuedBy ?? '') ||
        citizenshipController.text.trim() != (savedProfile?.citizenship ?? '') ||
        (homeDigits.isNotEmpty &&
            homeDigits != (savedProfile?.homePhone?.toString() ?? '')) ||
        homeAddressController.text.trim() != (savedProfile?.homeAddress ?? '') ||
        pdfFile != null;

    final requiredFilled = _filled(nameController) &&
        _filled(lastNameController) &&
        _filled(dateOfBirthController) &&
        _filled(dateIssueController) &&
        _filled(placeIssueController) &&
        _filled(citizenshipController) &&
        _filled(homeAddressController) &&
        selectedRoman != null &&
        selectedCity != null &&
        RegExp(r'^\d{6}$').hasMatch(passportDigits);

    final homeOk = homeDigits.isEmpty || homeDigits.length == 8 || homeDigits.length == 9;
    final datesOk = birth != null && issued != null && issued.isAfter(birth);
    final fileOk = isUpdate || pdfFile != null;

    validationMessage = _validationMessage(
      passportDigits: passportDigits,
      homeDigits: homeDigits,
      birth: birth,
      issued: issued,
    );

    continueEnabled = !isUnderReview &&
        requiredFilled &&
        homeOk &&
        datesOk &&
        fileOk &&
        (!isUpdate || hasChanges);

    update();
  }

  String? _validationMessage({
    required String passportDigits,
    required String homeDigits,
    required DateTime? birth,
    required DateTime? issued,
  }) {
    if (passportDigits.isNotEmpty && !RegExp(r'^\d{6}$').hasMatch(passportDigits)) {
      return r'passport_digits';
    }
    if (homeDigits.isNotEmpty && homeDigits.length != 8 && homeDigits.length != 9) {
      return r'home_phone_invalid';
    }
    if (birth != null && issued != null && !issued.isAfter(birth)) {
      return r'issue_date_before_birth';
    }
    return null;
  }

  Future<ProfileModel> _getProfileModel() async {
    final middleName = capitalizeFirstLetter(surNameController.text.trim());
    return ProfileModel(
      firstName: capitalizeFirstLetter(nameController.text.trim()),
      lastName: capitalizeFirstLetter(lastNameController.text.trim()),
      middleName: middleName.isEmpty ? null : middleName,
      birthDate: _displayDate(dateOfBirthController.text),
      passportNumber: buildPassportNumber(),
      issuedDate: _displayDate(dateIssueController.text),
      issuedBy: placeIssueController.text.trim(),
      passportScan: await _parseImage(),
      citizenship: citizenshipController.text.trim(),
      homePhone: _homePhoneOrNull(),
      homeAddress: homeAddressController.text.trim(),
    );
  }

  Future<ProfileModel> _getUpdatedProfileModel() async {
    final savedProfile = profileBox.get('currentProfile');
    final middleName = capitalizeFirstLetter(surNameController.text.trim());
    final savedMiddle = savedProfile?.middleName ?? '';
    final newPassport = buildPassportNumber();
    final firstName = capitalizeFirstLetter(nameController.text.trim());
    final lastName = capitalizeFirstLetter(lastNameController.text.trim());

    return ProfileModel(
      firstName: firstName != (savedProfile?.firstName ?? '')
          ? firstName
          : null,
      lastName: lastName != (savedProfile?.lastName ?? '')
          ? lastName
          : null,
      middleName: middleName != savedMiddle ? middleName : null,
      birthDate: _displayDate(dateOfBirthController.text) !=
              _displayDate(savedProfile?.birthDate)
          ? _displayDate(dateOfBirthController.text)
          : null,
      passportNumber: _normalizePassport(newPassport) !=
              _normalizePassport(savedProfile?.passportNumber)
          ? newPassport
          : null,
      issuedDate: _displayDate(dateIssueController.text) !=
              _displayDate(savedProfile?.issuedDate)
          ? _displayDate(dateIssueController.text)
          : null,
      issuedBy: placeIssueController.text.trim() != (savedProfile?.issuedBy ?? '')
          ? placeIssueController.text.trim()
          : null,
      citizenship:
          citizenshipController.text.trim() != (savedProfile?.citizenship ?? '')
          ? citizenshipController.text.trim()
          : null,
      homePhone: _digits(homePhoneController.text) !=
              (savedProfile?.homePhone?.toString() ?? '')
          ? _homePhoneOrNull()
          : null,
      homeAddress:
          homeAddressController.text.trim() != (savedProfile?.homeAddress ?? '')
          ? homeAddressController.text.trim()
          : null,
      passportScan: pdfFile == null ? null : await _parseImage(),
    );
  }

  Future<void> createOrUpdateProfile() async {
    if (status == Status.loading || !continueEnabled || isUnderReview) return;

    try {
      status = Status.loading;
      update();

      final savedProfile = profileBox.get('currentProfile');
      final ProfileModel fromServer;

      if (savedProfile != null) {
        final updateMap = await (await _getUpdatedProfileModel()).toMap();
        updateMap.removeWhere((key, value) => value == null);
        if (updateMap.isEmpty) {
          status = Status.completed;
          update();
          return;
        }
        fromServer = await repository.createProfile(
          dio.FormData.fromMap(updateMap),
        );
      } else {
        final createMap = await (await _getProfileModel()).toMap();
        createMap.removeWhere((key, value) => value == null);
        fromServer = await repository.createProfile(
          dio.FormData.fromMap(createMap),
        );
      }

      final latestProfile = ProfileModel(
        firstName: fromServer.firstName ??
            capitalizeFirstLetter(nameController.text.trim()),
        lastName: fromServer.lastName ??
            capitalizeFirstLetter(lastNameController.text.trim()),
        middleName: fromServer.middleName ??
            capitalizeFirstLetter(surNameController.text.trim()),
        birthDate: fromServer.birthDate ?? _displayDate(dateOfBirthController.text),
        passportNumber: fromServer.passportNumber ?? buildPassportNumber(),
        issuedDate: fromServer.issuedDate ?? _displayDate(dateIssueController.text),
        issuedBy: fromServer.issuedBy ?? placeIssueController.text.trim(),
        citizenship: fromServer.citizenship ?? citizenshipController.text.trim(),
        homePhone: fromServer.homePhone ?? _homePhoneOrNull(),
        homeAddress: fromServer.homeAddress ?? homeAddressController.text.trim(),
        gender: fromServer.gender ?? savedProfile?.gender,
        getPassportScan: fromServer.getPassportScan ?? savedProfile?.getPassportScan,
        status: fromServer.status ?? 'pending',
        rejectedText: fromServer.status == 'rejected'
            ? fromServer.rejectedText
            : const [],
      );

      await profileBox.put('currentProfile', latestProfile);
      status = Status.completed;

      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.currentProfile = latestProfile;
        homeController.checkProfile();
        homeController.checkProfileStatus();
        await homeController.getUserProfileInfo();
      }

      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.updateCurrentIndex(NestedNavigationIds.home);
      }

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

  Future<void> pickPdf() async {
    const maxSizeInBytes = 2 * 1024 * 1024;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty || result.files.single.path == null) {
      return;
    }

    final file = File(result.files.single.path!);
    if (await file.length() > maxSizeInBytes) {
      ShowSnack.showSnack(r'file_size_limit'.tr, SnackType.error);
      return;
    }

    pdfFile = file;
    onTextIsNotEmpty(null);
  }

  Future<dio.MultipartFile?> _parseImage() async {
    if (pdfFile == null) return null;
    return dio.MultipartFile.fromFile(
      pdfFile!.path,
      filename: pdfFileName,
    );
  }

  void setDropdownCity(String? value) {
    selectedCity = value;
    onTextIsNotEmpty(null);
  }

  void setDropdownNumber(String? value) {
    selectedRoman = value;
    onTextIsNotEmpty(null);
  }

  @override
  void onClose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isIssue = controller == dateIssueController;
    final birth = tryParseDate(dateOfBirthController.text);

    var firstDate = DateTime(1900);
    if (isIssue && birth != null) {
      firstDate = birth.add(const Duration(days: 1));
    }
    if (firstDate.isAfter(today)) firstDate = today;

    var initialDate = tryParseDate(controller.text) ??
        (isIssue ? today : DateTime(1990, 1, 1));
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(today)) initialDate = today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: today,
    );

    if (picked != null) {
      controller.text = formatDate(picked);
      onTextIsNotEmpty(null);
    }
  }
}
