import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationController extends GetxController with GetSingleTickerProviderStateMixin {

  bool isLongTap = false;
  bool isNotificationEmpty = false;

  List listAll = List.generate(5, (i) => i);
  List listManager1 = List.generate(3, (i) => i);
  List listManager2 = List.generate(2, (i) => i);

  List<int> selectedItems = [];

  late TabController tabController;

  void onLongTap() {
    isLongTap = !isLongTap;
    update();
  }

  void onItemSelect(int id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }

    if (selectedItems.isEmpty) {
      isLongTap = false;
    }
    update();
  }

  void selectAll() {
    final current = _currentList();

    if (selectedItems.length == current.length) {
      selectedItems.clear();
      isLongTap = false;
    }
    else {
      selectedItems = List.from(current);
      isLongTap = true;
    }

    update();
  }

  List _currentList() {
    final index = tabController.index;
    if (index == 0) return listAll;
    if (index == 1) return listManager1;
    return listManager2;
  }

  void deleteSelected() {
    final current = _currentList();
    current.removeWhere((e) => selectedItems.contains(e));
    selectedItems.clear();
    isLongTap = false;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      update();
    });
    super.onInit();
  }
}

