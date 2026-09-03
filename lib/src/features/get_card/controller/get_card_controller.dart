import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/get_card/models/card_type_model.dart';
import 'package:senagat_mobile/src/features/get_card/repository/card_repository.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../get_card_details/presentation/get_card_details_screen.dart';

class GetCardController extends GetxController
    with StateControlMixin, GetSingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedTabIndex = 0;
  CardRepository repository;
  final _cards = <CardTypeModel>[];

  List<CardTypeModel> get cards => _cards;

  List<CardTypeModel> get individualCards =>
      _cards.where((c) => c.category == 'individual').toList();

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
          tabController = TabController(
            length: _cards.where((c) => c.category == 'individual').length,
            vsync: this,
          );
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
          ApiErrorHandler.handleApiError(e);
        });
  }

  @override
  void onInit() {
    super.onInit();
    getCards();
  }

  void onTap() {
    final selected = individualCards[selectedTabIndex];
    Get.toNamed(
      GetCardDetailsScreen.route,
      arguments: {
        'selectedCardTitle': selected.title ?? '',
        'selectedCardImage': selected.imageUrl,
        'selectedCardId': selected.id ?? selectedTabIndex + 1,
        'sum': selected.price.toString(),
        'deliveryPrice': selected.deliveryPrice.toString(),
      },
    );
  }

  String get currentTabText =>
      individualCards.isNotEmpty
          ? individualCards[selectedTabIndex].title ?? ''
          : '';
}
