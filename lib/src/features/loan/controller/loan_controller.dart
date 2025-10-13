import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_branch_info_model.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_work_info_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';

class LoanController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  late final TextEditingController patentNumController;
  late final TextEditingController workAddressController;
  late final TextEditingController registerNumController;

  late final TextEditingController workplaceController;
  late final TextEditingController positionAtWorkController;
  late final TextEditingController managerWorkAddressController;
  late final TextEditingController wagesController;
  late final TextEditingController phoneController;

  String? selectedDropdownCity;
  String? selectedDropdownBank;
  bool continueEnabled = false;
  bool check = false;
  int pageIndex = 1;

  CreditRepository repository;

  late TabController tabController;
  int selectedTabIndex = 0;

  final List<String> citySelection = ["Option 1", "Option 2", "Option 3"];

  final List<String> bankSelection = ["Option 1", "Option 2", "Option 3"];

  late List<TextEditingController> controllers;

  LoanController(this.repository);

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
    phoneController = TextEditingController();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex = tabController.index;
      update();
    });
  }

  void onInformationNotEmpty(String? v) {
    if (selectedTabIndex == 1) {
      if (phoneController.text.length >= 8 &&
          workplaceController.text.isNotEmpty &&
          positionAtWorkController.text.isNotEmpty &&
          managerWorkAddressController.text.isNotEmpty &&
          wagesController.text.isNotEmpty) {
        continueEnabled = true;
        update();
      } else {
        continueEnabled = false;
        update();
      }
    } else if (selectedTabIndex == 0) {
      if (patentNumController.text.isNotEmpty &&
          registerNumController.text.isNotEmpty &&
          workAddressController.text.isNotEmpty) {
        continueEnabled = true;
        update();
      } else {
        continueEnabled = false;
        update();
      }
    }
  }

  void setDropdownCity(String? value) {
    selectedDropdownCity = value;
    if (selectedDropdownBank!.isNotEmpty) {
      continueEnabled = true;
    }
    update();
  }

  Future<void> onTap() async {
    if (pageIndex == 1 && continueEnabled) {
      status = Status.loading;
      update();

      final creditWorkInfoModel = selectedTabIndex == 0
          ? await _getCreditWorkInfoModelForEntrepreneur()
          : await _getCreditWorkInfoModelForManager();

      await repository
          .submitWorkInfo(data: creditWorkInfoModel.toMap())
          .then((value) {
            status = Status.completed;
            update();
            pageIndex = 2;
            continueEnabled = false;
          })
          .catchError((e) {
            status = Status.error;
            update();
            ShowSnack.showSnack(r'error'.tr, SnackType.error);

            debugPrint(e.toString());
          });

      update();
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

  Future<CreditWorkInfoModel> _getCreditWorkInfoModelForManager() async {
    return CreditWorkInfoModel(
      role: 'manager',
      managerWorkAddress: managerWorkAddressController.text,
      workplace: workplaceController.text,
      position: positionAtWorkController.text,
      phoneNumber: phoneController.text,
      salary: wagesController.text,
    );
  }

  Future<CreditWorkInfoModel> _getCreditWorkInfoModelForEntrepreneur() async {
    return CreditWorkInfoModel(
      role: 'entrepreneur',
      patentNumber: patentNumController.text,
      registrationNumber: registerNumController.text,
      workAddress: workAddressController.text,
    );
  }

  Future<CreditBranchInfoModel> _getCreditBranchInfoModel() async {
    return CreditBranchInfoModel(
      country: selectedDropdownCity,
      bankName: selectedDropdownBank,
    );
  }

  Future<void> startBankVerification() async {
    check = true;
    status = Status.loading;
    update();

    final creditBranchInfoModel = await _getCreditBranchInfoModel();

    await repository
        .submitBranchInfo(data: creditBranchInfoModel.toMap())
        .then((value) {
          status = Status.completed;
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ShowSnack.showSnack(r'error'.tr, SnackType.error);

          debugPrint(e.toString());
        });
  }

  void setDropdownBank(String? value) {
    selectedDropdownBank = value;
    if (selectedDropdownCity!.isNotEmpty) {
      continueEnabled = true;
    }
    update();
  }

}
