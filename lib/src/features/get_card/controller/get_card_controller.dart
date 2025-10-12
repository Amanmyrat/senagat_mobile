import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/get_card/models/card_type_model.dart';
import 'package:senagat_mobile/src/features/get_card/repository/card_repository.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../get_card_details/presentation/get_card_details_screen.dart';

class GetCardController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedTabIndex = 0;
  CardRepository repository;
  final _cards = <CardTypeModel>[];

  List<CardTypeModel> get cards => _cards;

  GetCardController(this.repository);

  final List<String> tabLabels = [
    r'salary',
    r'deposit',
    r'family',
    r'overdraft',
  ];

  void getCards() async {
    status = Status.loading;
    update();
    await repository
        .getCardTypes()
        .then((value) {
          _cards.addAll(value);
          tabController = TabController(length: _cards.length, vsync: this);
          tabController.addListener(() {
            selectedTabIndex = tabController.index;
            update();
          });
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

  @override
  void onInit() {
    super.onInit();
    getCards();

  }

  void onTap() {
    Get.toNamed(
      GetCardDetailsScreen.route,
      arguments: {'selectedCardTitle': currentTabText, 'selectedCardImage': cards[selectedTabIndex].image, 'selectedCardId': selectedTabIndex + 1, 'sum': cards[selectedTabIndex].price},
    );
  }

  String get currentTabText => cards.isNotEmpty
      ? cards[selectedTabIndex].title ?? ''
      : '';
}
