import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import 'package:senagat_mobile/src/features/inquiries/repository/inquiries_repository.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';
import 'package:senagat_mobile/src/widgets/text_input_masks.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../loan/models/location_model.dart';
import '../../loan/repository/location_repository.dart';
import '../models/inquiries_order_model.dart';

class InquiriesController extends PaymentController{
  InquiriesController(super.repository, this.inquiriesRepository, this.locRepository, this.key);

  late final TextEditingController addressController;

  InquiriesRepository inquiriesRepository;
  LocationRepository locRepository;
  final GlobalKey<FormState> key;
  final _inquiries = <InquiriesModel>[];

  late int inquiriesId;
  late double inquiriesPrice;


  late bool requiredPayment = false;

  List<InquiriesModel> get inquiries => _inquiries;

  final List<LocationModel> _branches = [];
  List<LocationModel> get branches => _branches;

  String? selectedDropdownType;
  int? selectedDropdownBranch;
  bool _continueEnabled = false;

  @override
  bool get continueEnabled => _continueEnabled;

  @override
  set continueEnabled(bool value) {
    _continueEnabled = value;
  }
  bool isDropdownSelected = false;

  final dateOfBirthFormatter = CustomMaskFormatter(
    mask: '##-##-####', prefix: '',
  );

  List<String> textFieldTitle = [
    r'name',
    r'last_name',
    r'surname',
    r'date_birth',
    r'passport_number',
    r'date_issue',
  ];

  final Map<int, String> typeSelection = {
    1: r'obtain_certificate',
    2: r'letter_stating_that_there_is_no_debt',
    3: r'about_the_wage_situation',
    4: r'certificate_of_loan_balance',
  };

  @override
  void onInit() {
    super.onInit();
    isInquiries = true;
    addressController = TextEditingController();
    getInquiries();
    getBranches();
  }

  void onInformationNotEmpty(v) {
    if (requiredPayment) {
      if (addressController.text.isNotEmpty && selectedDropdownBranch != null && selectedCard !=null) {
        continueEnabled = true;
        update();
      } else {
        continueEnabled = false;
        update();
      }
    } else if (addressController.text.isNotEmpty && selectedDropdownBranch != null) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  void setDropdownType(String? value) {
    selectedDropdownType = value;
    isDropdownSelected = true;
    update();
  }

  Future<InquiriesOrderModel> _getInquiriesOrderModel() async {
    getInquiriesId();
      return InquiriesOrderModel(
        typeId: inquiriesId,
        homeAddress: addressController.text,
        bankBranch: selectedDropdownBranch,
        requiredPayment: requiredPayment,
      );
  }

  @override
  Future<void> onTap() async {
    if (continueEnabled) {
      status = Status.loading;
      update();
      final inquiriesOrderModel = await _getInquiriesOrderModel();
      await inquiriesRepository
          .createInquiresOrder(data: inquiriesOrderModel.toMap())
          .then((value) {
            status = Status.completed;
            update();
            getInquiriesPrice();

            Get.toNamed(
              PaymentVerificationScreen.route,
              arguments: {
                'isInquiries': true,
                'isFoundation': false,
                'serviceName': r'get_inquiries',
                'createdAt': value.createdAt,
                'sum': inquiriesPrice.toString(),
                'paymentUrl': value.paymentUrl,
                'requiredPayment':  requiredPayment,
                'selectedCard':  selectedCard,
              },
            );
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
          });
    }
  }

  void getInquiries() async {
    status = Status.loading;
    update();
    await inquiriesRepository
        .getInquiriesTypes()
        .then((value) {
          status = Status.completed;
          update();
          _inquiries.addAll(value);
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        });
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
          debugPrint(e.toString());
        });
  }

  getInquiriesId() {
    final selectedType = selectedDropdownType;

    final selectedInquiry = _inquiries.firstWhere(
      (inquiry) => inquiry.title == selectedType,
      orElse: () => InquiriesModel(id: -1, title: ''),
    );

    inquiriesId = selectedInquiry.id!;
  }

  getInquiriesPrice() {
    final selectedType = selectedDropdownType;

    final selectedInquiry = _inquiries.firstWhere(
      (inquiry) => inquiry.title == selectedType,
      orElse: () => InquiriesModel(id: -1, title: ''),
    );

    inquiriesPrice = selectedInquiry.price!;
  }

  void setDropdownBranch(int? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty(value);
    update();
  }
}
