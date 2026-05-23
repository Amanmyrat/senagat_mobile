import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../../../utils/api_error_handler.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../pay/model/paymet_history_model.dart';

enum PaymentStatus { all, failed, confirmed }

class PaymentHistoryController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  final PaymentRepository repository;

  PaymentHistoryController(this.repository);

  /// DATA
  List<PaymentHistoryModel> history = [];
  List<PaymentHistoryModel> filteredHistory = [];

  late TabController tabController;
  int selectedTabIndex = 0;

  /// FILTER STATE
  PaymentStatus selectedStatus = PaymentStatus.all;
  Set<String> selectedTypes = {};

  /// PAYMENT ICONS
  final List<String> paymentsIcons = [
    AppAssets.foundation,
    AppAssets.tmCell,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.telecom,
    AppAssets.beletIcon,
    AppAssets.alemTv,
  ];

  /// REAL BACKEND TYPES
  /// Use these values for filtering.
  final List<String> paymentsTypes = [
    'charity',
    'tmcell',
    'cdma',
    'astu iptv',
    'astu phone',
    'astu internet',
    'telecom',
    'belet',
    'alem_tv',
  ];

  /// DISPLAY TITLES
  /// Use these values only for UI text.
  final List<String> paymentsTitle = [
    'charity',
    'tmcell',
    'cdma',
    'astu iptv',
    'astu phone',
    'astu internet',
    'telecom',
    'belet',
    'ÄlemTv',
  ];

  final List<MapEntry<String, PaymentStatus>> statusTabs = [
    MapEntry('all', PaymentStatus.all),
    MapEntry('payment_approved', PaymentStatus.confirmed),
    MapEntry('failed', PaymentStatus.failed),
  ];

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: statusTabs.length,
      vsync: this,
    );

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        final status = statusTabs[tabController.index].value;
        setStatusFilter(status);
      }
    });

    _loadHistory();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

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

  /// SELECT ONE TYPE
  void selectSingleType(String type) {
    selectedTypes.clear();

    if (type != 'all') {
      selectedTypes.add(type);
    }

    applyFilters();
  }

  /// CLEAR TYPE FILTERS
  void clearTypes() {
    selectedTypes.clear();
    applyFilters();
    Get.back();
  }

  /// SET STATUS FILTER
  void setStatusFilter(PaymentStatus status) {
    selectedStatus = status;
    applyFilters();
  }

  /// APPLY FILTERS
  void applyFilters() {
    filteredHistory = history.where((item) {
      final statusMatch = selectedStatus == PaymentStatus.all
          ? true
          : item.status == selectedStatus.name;

      final typeMatch = selectedTypes.isEmpty
          ? true
          : selectedTypes.contains(item.type) ||
          _alemTvTypeMatch(item.type);

      return statusMatch && typeMatch;
    }).toList();

    update();
  }

  /// ÄlemTv backend compatibility
  /// Use this only if backend can return both alem_tv and alem_iptv.
  bool _alemTvTypeMatch(String? itemType) {
    if (!selectedTypes.contains('alem_tv')) {
      return false;
    }

    return itemType == 'alem_tv' || itemType == 'alem_iptv';
  }

  /// RESET FILTERS
  void resetFilters() {
    selectedStatus = PaymentStatus.all;
    selectedTypes.clear();
    filteredHistory = List.from(history);
    tabController.index = 0;
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

  String historyPhoneByType(String type, String value) {
    switch (type) {
      case 'tmcell':
        return '+993$value';
      case 'charity':
        return '+993$value';
      case 'belet':
        return '+$value';
      case 'astu iptv':
        return '12$value';
      case 'astu phone':
        return '12$value';
      case 'cdma':
        return value;
      case 'astu internet':
        return '12$value';
      case 'telecom':
        return value;
      case 'alem_iptv':
        return value;
      case 'alem_tv':
        return value;
      default:
        return value;
    }
  }

  String iconByType(String type) {
    switch (type) {
      case 'tmcell':
        return AppAssets.tmCell;
      case 'charity':
        return AppAssets.foundation;
      case 'belet':
        return AppAssets.beletIcon;
      case 'astu iptv':
        return AppAssets.astu;
      case 'astu phone':
        return AppAssets.astu;
      case 'cdma':
        return AppAssets.astu;
      case 'astu internet':
        return AppAssets.astu;
      case 'telecom':
        return AppAssets.telecom;
      case 'alem_iptv':
        return AppAssets.alemTv;
      case 'alem_tv':
        return AppAssets.alemTv;
      default:
        return AppAssets.deviceMobileIcon;
    }
  }

  String historyTitleByType(String type) {
    switch (type) {
      case 'tmcell':
        return 'TM CELL';
      case 'charity':
        return 'charity'.tr;
      case 'belet':
        return 'belet'.tr;
      case 'astu iptv':
        return 'IP TV';
      case 'astu phone':
        return 'astu_phone'.tr;
      case 'cdma':
        return 'CDMA';
      case 'astu internet':
        return 'astu_internet'.tr;
      case 'telecom':
        return 'telecom_internet'.tr;
      case 'alem_iptv':
        return 'ÄlemTv'.tr;
      case 'alem_tv':
        return 'ÄlemTv'.tr;
      default:
        return type;
    }
  }
}