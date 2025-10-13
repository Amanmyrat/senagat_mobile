import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/models/credit_details_model.dart';
import 'package:senagat_mobile/src/features/credit/models/credit_types_model.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../loan/presentation/loan_screen.dart';

class GetCreditController extends GetxController with StateControlMixin {
  double currentValue = 10000;

  late MoneyMaskedTextController sumController;

  late TextEditingController bidController;
  late TextEditingController paymentController;

  late TabController tabBarController;
  final _credits = <CreditTypeModel>[];

  late String creditAmount;
  late String creditInterest;

  late double amount;
  late double interest;

  late int creditId;
  late int term;
  late double monthlyPayment;

  List<CreditTypeModel> get credits => _credits;

  String? selectedDropdownValue;
  bool continueEnabled = false;

  CreditRepository repository;

  GetCreditController(this.repository);

  final List<String> dropdownItems = [
    r'credit_for_newlyweds',
    r'consumer_credit',
    r'student_loan',
  ];

  void setDropdownValue(String? value) {
    selectedDropdownValue = value;

    getCreditValues();

    onTextIsNotEmpty(value);
    update();
  }

  void onTextIsNotEmpty(String? v) {
    if (sumController.text.isNotEmpty &&
        bidController.text.isNotEmpty &&
        paymentController.text.isNotEmpty) {
      continueEnabled = true;
    } else {
      continueEnabled = false;
    }
    update();
  }

  void updateText(double value) {
    currentValue = value;
    sumController.updateValue(currentValue);
    update();
  }

  void getCredits() async {
    status = Status.loading;
    update();
    await repository
        .getCreditTypes()
        .then((value) {
          _credits.addAll(value);

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

  Future<CreditDetailsModel> _getCreditDetailsModel() async {
    return CreditDetailsModel(
      creditId: creditId,
      term: term,
      amount: currentValue.toInt(),
      monthlyPayment: monthlyPayment.toInt(),
    );
  }

  Future<void> onTap() async {
    if (continueEnabled) {
      status = Status.loading;
      update();
      final creditDetailsModel = await _getCreditDetailsModel();
      await repository
          .submitCreditDetails(data: creditDetailsModel.toMap())
          .then((value) {
            status = Status.completed;
            update();

            Get.toNamed(LoanScreen.route);
          })
          .catchError((e) {
            status = Status.error;
            update();
            ShowSnack.showSnack(r'error'.tr, SnackType.error);

            debugPrint(e.toString());
          });
    }
  }

  @override
  void onInit() {
    getCredits();
    sumController = MoneyMaskedTextController(
      decimalSeparator: '',
      thousandSeparator: ',',
      precision: 0,
    );
    sumController.updateValue(currentValue);

    bidController = TextEditingController();

    paymentController = TextEditingController();
    super.onInit();
  }

  getCreditValues() {
    final selectedCredit = _credits.firstWhereOrNull(
      (credit) => credit.name == selectedDropdownValue,
    );

    if (selectedCredit != null) {
      bidController.text = '${selectedCredit.term}%';
      paymentController.text =
          selectedCredit.amount?.replaceAll('.', ',') ?? '';
      creditAmount = selectedCredit.amount?.replaceAll('.', ',') ?? '';
      creditInterest = selectedCredit.interest?.replaceAll('.', ',') ?? '';

      amount = double.parse(creditAmount.replaceAll(',', ''));
      interest = double.parse(creditInterest.replaceAll(',', ''));

      creditId = selectedCredit.id ?? -1;
      term = selectedCredit.term ?? 0;
      monthlyPayment = double.parse(selectedCredit.amount!);
    } else {
      debugPrint('⚠️ Credit type not found for $selectedDropdownValue');
    }
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}
