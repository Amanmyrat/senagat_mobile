import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';
import 'package:senagat_mobile/src/features/loan/models/credit_order_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/services/error_utils.dart';
import '../../map_search/model/location_model.dart';
import '../../map_search/repository/location_repository.dart';

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

  CreditRepository repository;
  LocationRepository locRepository;

  final List<LocationModel> _branches = [];

  List<LocationModel> get branches => _branches;

  late TabController tabController;
  int selectedTabIndex = 0;

  late List<TextEditingController> controllers;

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
      update();
    });
    getBranches();

    creditId = Get.arguments['creditId'];
    term = Get.arguments['term'];
    amount = Get.arguments['amount'];
    monthlyPayment = Get.arguments['monthlyPayment'];
  }

  void onInformationNotEmpty(String? v) {
    if (selectedTabIndex == 1) {
      if (workplaceController.text.isNotEmpty &&
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

  Future<void> onTap() async {
    if (pageIndex == 1 && continueEnabled) {
      pageIndex = 2;
      continueEnabled = false;
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
          final errorText = ErrorUtils.extractErrorText(e);
          ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
          debugPrint(e.toString());
        });
  }

  Future<CreditOrderModel> _getCreditWorkInfoModelForManager() async {
    final int salary = int.parse(wagesController.text);
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

  Future<void> startBankVerification() async {
    check = true;
    status = Status.loading;
    update();

    final creditWorkInfoModel = selectedTabIndex == 0
        ? await _getCreditWorkInfoModelForEntrepreneur()
        : await _getCreditWorkInfoModelForManager();

    await repository
        .creditOrder(
          data: selectedTabIndex == 0
              ? creditWorkInfoModel.toMap()
              : creditWorkInfoModel.toMap2(),
        )
        .then((value) {
          status = Status.completed;
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          final errorText = ErrorUtils.extractErrorText(e);
          ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

          debugPrint(e.toString());
        });

    update();
  }


  void setDropdownBank(int? value) {
    selectedDropdownBank = value;
    continueEnabled = true;
    update();
  }
}
