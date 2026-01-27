import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../../../utils/api_error_handler.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../pay/model/paymet_history_model.dart';

enum PaymentStatus { all, pending, failed, approved }

class CardExpensesController extends GetxController
    with StateControlMixin {
  final PaymentRepository repository;

  CardExpensesController(this.repository);

  /// DATA
  List<PaymentHistoryModel> history = [];
  List<PaymentHistoryModel> filteredHistory = [];

  /// FILTER STATE
  PaymentStatus selectedStatus = PaymentStatus.all;
  String? selectedType = 'all';

  /// YOUR TYPES
  final List<String> paymentsIcons = [
    AppAssets.tmCell,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.telecom,
    AppAssets.beletIcon,
    AppAssets.policeCar,
    AppAssets.alemTv,
  ];



  final List<String> paymentsTitle = [
    'TM CELL',
    'CDMA',
    'IP TV',
    'home_phone',
    'astu_internet',
    'telecom_internet',
    'belet',
    'state_traffic_safety_inspectorate',
    'ÄlemTv',
  ];


  final List<String> statuses = [
    'all',
    'pending',
    'failed',
    'payment_approved',
    'notConfirmed',
  ];


  @override
  void onInit() {
    _loadHistory();
    super.onInit();
  }

  /// LOAD DATA
  Future<void> _loadHistory() async {
    status = Status.loading;
    update();

    try {
      history = await repository.getPaymentHistory();
      filteredHistory = List.from(history);
      status = Status.completed;
      update();
    } catch (e) {
      status = Status.error;
      update();
      ApiErrorHandler.handleApiError(e);
    }
  }

  /// APPLY FILTERS
  void applyFilters() {
    filteredHistory = history.where((item) {
      final statusMatch = selectedStatus == PaymentStatus.all
          ? true
          : item.status == selectedStatus.name;

      final typeMatch = selectedType == 'all'
          ? true
          : item.type == selectedType;

      return statusMatch && typeMatch;
    }).toList();

    update();
  }

  /// SETTERS
  void setStatusFilter(PaymentStatus status) {
    selectedStatus = status;
    applyFilters();
  }

  void setTypeFilter(String? type) {
    selectedType = type;
    applyFilters();
  }

  /// RESET
  void resetFilters() {
    selectedStatus = PaymentStatus.all;
    selectedType = null;
    filteredHistory = List.from(history);
    update();
  }

  Color checkPaymentsStatus(int index) {
    if (filteredHistory.isEmpty || index >= filteredHistory.length) {
      return AppColors.greyInactive;
    }

    final status = filteredHistory[index].status;

    switch (status) {
      case 'approved':
        return AppColors.green;
      case 'pending':
        return AppColors.orange;
      case 'failed':
        return AppColors.redDark;
      default:
        return AppColors.greyInactive;
    }
  }


  String iconByType(String type) {
    if (paymentsTitle.contains(type)) {
      return paymentsIcons[paymentsTitle.indexOf(type)];
    }
    return AppAssets.deviceMobileIcon;
  }
}

