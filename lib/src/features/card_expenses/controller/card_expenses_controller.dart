import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../../../utils/api_error_handler.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../pay/model/paymet_history_model.dart';

enum PaymentStatus { all, failed, approved }

class CardExpensesController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  final PaymentRepository repository;

  CardExpensesController(this.repository);

  /// DATA
  List<PaymentHistoryModel> history = [];
  List<PaymentHistoryModel> filteredHistory = [];

  late TabController tabController;
  int selectedTabIndex = 0;
  Set<String> selectedTypes = {};


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


  final List<MapEntry<String, PaymentStatus>> statusTabs = [
    MapEntry('all', PaymentStatus.all),
    MapEntry('failed', PaymentStatus.failed),
    MapEntry('payment_approved', PaymentStatus.approved),
  ];

  @override
  void onInit() {
    _loadHistory();
    tabController = TabController(
      length: statusTabs.length,
      vsync: this,
    );

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        final status =
            statusTabs[tabController.index].value;
        setStatusFilter(status);
      }
    });

    super.onInit();
  }

  void toggleType(String type) {
    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }
    update();
  }
  void clearTypes() {
    selectedTypes.clear();
    applyFilters();
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

      final typeMatch = selectedTypes.isEmpty
          ? true
          : selectedTypes.contains(item.type);

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
      case 'confirmed':
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
    switch (type) {
      case 'mobile':
        return AppAssets.deviceMobileIcon;
      case 'charity':
        return AppAssets.foundation;
      case 'belet':
        return AppAssets.beletIcon;
      default:
        return AppAssets.deviceMobileIcon;
    }
  }
}

