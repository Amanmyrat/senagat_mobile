import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_order_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/services/show_snack.dart';
import '../models/location_model.dart';
import '../repository/location_repository.dart';

class LoanController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  late final TextEditingController patentNumController;
  late final TextEditingController workAddressController;
  late final TextEditingController registerNumController;

  late final TextEditingController workplaceController;
  late final TextEditingController positionAtWorkController;
  late final TextEditingController managerWorkAddressController;
  late final TextEditingController wagesController;

  int? selectedDropdownBank;
  bool continueEnabled = false;
  bool check = false;
  int pageIndex = 1;

  late int creditId;
  late int term;
  late int amount;
  late double monthlyPayment;
  late String minMonthlyPayment;

  CreditRepository repository;
  LocationRepository locRepository;

  final List<LocationModel> _branches = [];

  List<LocationModel> get branches => _branches;

  late TabController tabController;
  int selectedTabIndex = 0;

  late List<TextEditingController> controllers;

  File? profitDocument;
  File? profitDocument2;
  File? workDocument;

  String? wagesError;

  LoanController(this.repository, this.locRepository);

  @override
  void onInit() {
    super.onInit();

    patentNumController = TextEditingController();
    workAddressController = TextEditingController();
    registerNumController = TextEditingController();

    workplaceController = TextEditingController();
    positionAtWorkController = TextEditingController();
    managerWorkAddressController = TextEditingController();
    wagesController = TextEditingController();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex = tabController.index;
      onInformationNotEmpty('v');
      update();

    });
    getBranches();

    creditId = Get.arguments['creditId'];
    term = Get.arguments['term'];
    amount = Get.arguments['amount'];
    monthlyPayment = Get.arguments['monthlyPayment'];
    minMonthlyPayment = Get.arguments['minMonthlyPayment'];
  }

  void onInformationNotEmpty(String? v) {
    if (selectedTabIndex == 1) {
      continueEnabled =
          workplaceController.text.isNotEmpty &&
              positionAtWorkController.text.isNotEmpty &&
              managerWorkAddressController.text.isNotEmpty &&
              wagesController.text.isNotEmpty &&
              profitDocument2 != null &&
              workDocument != null;

      update();

    } else if (selectedTabIndex == 0) {
      continueEnabled =
          patentNumController.text.isNotEmpty &&
              registerNumController.text.isNotEmpty &&
              workAddressController.text.isNotEmpty &&
              profitDocument != null;

      update();
    }
  }

  Future<void> onTap() async {
    if (pageIndex == 1 && continueEnabled) {
      if(selectedTabIndex == 1){
        double? wages = double.tryParse(
            wagesController.text.replaceAll(' ', '').replaceAll(',', '.')
        );
        double? minWages = double.tryParse(
            minMonthlyPayment.replaceAll(' ', '').replaceAll(',', '.')
        );

        if (wages! < minWages!) {
          continueEnabled = false;
          update();
         ShowSnack.showSnack('monthly_payment_min'.trParams({'sum': minMonthlyPayment}), SnackType.error);
        }else{
          pageIndex = 2;
          continueEnabled = false;
          update();
        }

      }else {
        pageIndex = 2;
        continueEnabled = false;
        update();
      }
    } else if (pageIndex == 2 && continueEnabled) {
      startBankVerification();
      update();
    }
  }

  void onBack() {
    if (pageIndex == 1) {
      Get.back();
      update();
    } else if (pageIndex == 2) {
      pageIndex = 1;
      continueEnabled = true;
      update();
    }
  }

  void getBranches() async {
    status = Status.loading;
    update();

    await locRepository
        .getBranches()
        .then((value) {
          _branches.addAll(value);
          status = Status.completed;
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
        });
  }

  Future<CreditOrderModel> _getCreditWorkInfoModelForManager() async {

    final int salary = int.parse(wagesController.text);
    // final salaryFile = await _parseImage(profitDocument!);
    // final profitFile = await _parseImage(workDocument!);

    return CreditOrderModel(
      creditId: creditId,
      term: term,
      amount: amount,
      monthlyPayment: monthlyPayment,
      role: 'manager',
      managerWorkAddress: managerWorkAddressController.text,
      workplace: workplaceController.text,
      position: positionAtWorkController.text,
      salary: salary,
      bankId: selectedDropdownBank,
      // profitDocument: salaryFile,
      // workDocument: profitFile,

    );
  }

  Future<CreditOrderModel> _getCreditWorkInfoModelForEntrepreneur() async {

    return CreditOrderModel(
      creditId: creditId,
      term: term,
      amount: amount,
      monthlyPayment: monthlyPayment,
      role: 'entrepreneur',
      patentNumber: patentNumController.text,
      registrationNumber: registerNumController.text,
      workAddress: workAddressController.text,
      bankId: selectedDropdownBank,
    );
  }

  // Future<void> startBankVerification() async {
  //   check = true;
  //   status = Status.loading;
  //   update();
  //
  //   try {
  //     final creditWorkInfoModel = selectedTabIndex == 0
  //         ? await _getCreditWorkInfoModelForEntrepreneur()
  //         : await _getCreditWorkInfoModelForManager();
  //
  //     final data = selectedTabIndex == 0
  //         ? creditWorkInfoModel.toMap()
  //         : creditWorkInfoModel.toMap2();
  //
  //     final formData = FormData(data);
  //
  //     await repository.creditOrder(data: formData);
  //
  //     status = Status.completed;
  //   } catch (e) {
  //     status = Status.error;
  //     ApiErrorHandler.handleApiError(e);
  //     debugPrint(e.toString());
  //   }
  //
  //   update();
  // }

  Future<void> startBankVerification() async {
    check = true;
    status = Status.loading;
    update();

    try {
      final model = selectedTabIndex == 0
          ? await _getCreditWorkInfoModelForEntrepreneur()
          : await _getCreditWorkInfoModelForManager();

      final map = selectedTabIndex == 0
          ? model.toMap()
          : model.toMap2();

      final formData = dio.FormData.fromMap({
        ...map,

        if (profitDocument != null)
          'profit_document': await dio.MultipartFile.fromFile(
            profitDocument!.path,
            filename: profitDocument!.path.split('/').last,
          ),

        if (workDocument != null)
          'work_document': await dio.MultipartFile.fromFile(
            workDocument!.path,
            filename: workDocument!.path.split('/').last,
          ),

        if (profitDocument2 != null)
          'profit_document': await dio.MultipartFile.fromFile(
            profitDocument2!.path,
            filename: profitDocument2!.path.split('/').last,
          ),
      });

      await repository.creditOrder(formData);

      status = Status.completed;
    } catch (e) {
      status = Status.error;
      ApiErrorHandler.handleApiError(e);
    }

    update();
  }
  // Future<void> pickPdf(bool isSalary) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null &&
  //       result.files.isNotEmpty &&
  //       result.files.single.path != null) {
  //
  //     final file = File(result.files.single.path!);
  //
  //     if (isSalary) {
  //       profitDocument = file;
  //     } else {
  //       workDocument = file;
  //     }
  //     onInformationNotEmpty(null);
  //     update();
  //   }
  // }
  //
  // Future<MultipartFile> _parseImage(File file) async {
  //   final bytes = await file.readAsBytes();
  //   final fileName = file.path.split('/').last;
  //
  //   return MultipartFile(
  //     bytes,
  //     filename: fileName,
  //   );
  // }

  Future<void> pickPdf(String type) async {
    const int maxSizeInBytes = 2 * 1024 * 1024;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {

      final file = File(result.files.single.path!);
      final fileSize = await file.length();

      if (fileSize > maxSizeInBytes) {
        ShowSnack.showSnack(r'file_size_limit'.tr, SnackType.error);
        return;
      }

      if (type == 'profit') {
        profitDocument = file;
      } else if(type == 'work') {
        workDocument = file;
      }else{
        profitDocument2 = file;
      }

      onInformationNotEmpty(null);
      update();
    }
  }

  void setDropdownBank(int? value) {
    selectedDropdownBank = value;
    continueEnabled = true;
    update();
  }
}
