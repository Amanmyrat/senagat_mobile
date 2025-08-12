import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../../utils/constants/app_assets.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../model/card_model.dart';

class AddCardController extends GetxController with StateControlMixin {
  late final PageController pageController;
  late final TextEditingController cardNumberController;
  late final TextEditingController nameController;
  late final TextEditingController termController;

  bool continueEnabled = false;
  bool check = false;

  int selectedDesign = 0;

  List<AssetImage> cardDesigns = [
    AssetImage(AppAssets.cardImage),
    AssetImage(AppAssets.cardImage),
    AssetImage(AppAssets.cardImage),
    AssetImage(AppAssets.cardImage),
  ];

  late final cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'\d')},
  );

  late final termFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'\d')},
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

    pageController.addListener(() {
      selectedDesign = pageController.page?.round() ?? 0;
    });

    super.onInit();
  }

  void onCardTextChanged(String val) {
    continueEnabled = val.length >= 19 &&
        nameController.text.isNotEmpty &&
        termController.text.isNotEmpty;
    update();
  }

  void onTermTextChanged(String val) {
    continueEnabled = cardNumberController.text.length >= 19 &&
        nameController.text.isNotEmpty &&
        val.length >= 5;
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
      name: nameController.text,
      expiryDate: termController.text,
      designIndex: selectedDesign,
    );
    await box.put('card',card);
  }

  void _navigateToNextScreen() {
    try {
      Get.toNamed(DashboardScreen.route,);
    } catch (e) {
      status = Status.error;
      debugPrint('Error navigating to next screen: $e');
    }
  }

  void startBankVerification() {
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
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

  @override
  void dispose() {
    cardNumberController.dispose();
    nameController.dispose();
    pageController.dispose();
    termController.dispose();
    super.dispose();
  }
}
