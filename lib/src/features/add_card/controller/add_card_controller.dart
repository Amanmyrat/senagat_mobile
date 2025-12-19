import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/model/bank_model.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../model/card_model.dart';

class AddCardController extends GetxController with StateControlMixin {
  late final PageController pageController;
  late final TextEditingController cardNumberController;
  late final TextEditingController nameController;
  late final TextEditingController termController;
  late final TextEditingController cvcController;

  bool continueEnabled = false;
  bool check = false;

  String cardName = '';

  int selectedDesign = 0;
  BankModel? selectedDropdownBank;


  List<String> cardDesigns = [
      AppAssets.cardImage,
      AppAssets.cardImage2,
      AppAssets.cardImage3,
      AppAssets.cardImage4,
  ];

  List<String> cardDesigns2 = [
    AppAssets.salaryCard,
    AppAssets.salaryCard,
    AppAssets.goyumCard,
    AppAssets.familyCard,
  ];

  List<BankModel> bankList = [
    BankModel(
      name: r'altyn_asyr',
      bankName: r'altyn_asyr',
    ),
    BankModel(
      name: r'senagat_bank',
      bankName: r'senagat',
    ),
    BankModel(
      name: r'rysgal_bank',
      bankName: r'rysgal',
    ),
  ];

  int? senagatIndex;

  final Map<String, int> prefixToIndex = {
    '993470': 0,
    '993407': 0,
    '993420': 0,
    '993402': 0,
    '993471': 0,
    '993421': 0,
    '993472': 0,
    '993473': 1,
    '993474': 2,
    '993475': 3,
  };


  late final cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'\d')},
  );

  late final termFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
    type: MaskAutoCompletionType.lazy,
  );


  String get maskedCardNumber {
    String numbers = cardNumberController.text.replaceAll(' ', '');
    String mask = "xxxx xxxx xxxx xxxx";

    for (int i = 0; i < numbers.length && i < 16; i++) {
      mask = mask.replaceFirst('x', numbers[i]);
    }

    return mask;
  }

  @override
  void onInit() {
    pageController = PageController();
    cardNumberController = TextEditingController();
    nameController = TextEditingController();
    termController = TextEditingController();
    cvcController = TextEditingController();

    pageController.addListener(() {
      selectedDesign = pageController.page?.round() ?? 0;
    });

    super.onInit();
  }


  void onTextChanged(String val) {
    continueEnabled = cardNumberController.text.length >= 19 &&
        nameController.text.isNotEmpty &&
        isValidExpiry(termController.text) &&
        cvcController.text.length >=3;

    if (termController.text.length >= 2) {
      final month = int.tryParse(termController.text.substring(0, 2)) ?? 0;

      if (month > 12) {
        termController.text = '12/${termController.text.substring(3)}';
        termController.selection = TextSelection.fromPosition(
          TextPosition(offset: termController.text.length),
        );
      }
    }

    updateCardDesignByPrefix();

    update();
  }

  void setDropdownBank(BankModel? value) {
    selectedDropdownBank = value;
    update();
  }

  void onClearTextField(TextEditingController textController) {
    textController.clear();
    update();
  }

  Future<void> saveCard() async {
    final box = Hive.box<CardModel>('cardsBox');
    final card = CardModel(
      cardNumber: cardNumberController.text,
      name: nameController.text.toUpperCase(),
      expiryDate: termController.text,
      cardDesign: senagatIndex != null
          ? cardDesigns2[senagatIndex!]
          : cardDesigns[selectedDesign],
      nickName: senagatIndex != null ? '' : r'other_bank'.tr,
    );
    await box.add(card);
  }

  void _navigateToNextScreen() {
    try {
      Get.toNamed(DashboardScreen.route);
      cardNumberController.clear();
      nameController.clear();
      termController.clear();
      cvcController.clear();
      continueEnabled = false;
    } catch (e) {
      status = Status.error;
    }
  }

  bool isValidExpiry(String value) {
    if (value.length != 5) return false;
    if (!value.contains('/')) return false;

    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year  = int.tryParse(parts[1]) ?? 0;

    if (month < 1 || month > 12) return false;
    if (year < 0 || year > 99) return false;

    return true;
  }


  void updateCardDesignByPrefix() {
    final cardNumber = cardNumberController.text.replaceAll(' ', '');
    final prefix6 = cardNumber.length >= 6 ? cardNumber.substring(0, 6) : '';
    senagatIndex = prefixToIndex[prefix6];

    if (senagatIndex != null) {
      selectedDesign = senagatIndex!;
    }

    if(cardNumberController.text.length >= 19 && senagatIndex ==null){
      cardName = 'other_bank';
    }else{
      cardName = '';
    }
    update();
  }

  void startBankVerification() {
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 2),(){
      status = Status.completed;
      update();

    });

    Future.delayed(const Duration(seconds: 4), () async {
      await saveCard();
      check = false;
      update();
      _navigateToNextScreen();
    });
  }

  void deleteAddController(){
    Get.delete<AddCardController>();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    nameController.dispose();
    pageController.dispose();
    termController.dispose();
    super.dispose();
  }


  @override
  void onClose() {
    cardNumberController.clear();
    nameController.clear();
    termController.clear();
    cvcController.clear();
    super.onClose();
  }
}
