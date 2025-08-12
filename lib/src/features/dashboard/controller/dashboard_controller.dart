import 'package:get/get.dart';
import '../utils/nested_nav_ids.dart';

class DashboardController extends GetxController {

  final RxInt _currentIndex = 0.obs;
  RxInt get currentIndexRx => _currentIndex; // for reactive use
  int get currentIndex => _currentIndex.value; // for simple read

  final RxBool _addProductEnabled = false.obs;
  bool get addProductEnabled => _addProductEnabled.value;

  String? phone;

  void updateCurrentIndex(int currentIndex) async {
    int keyIdForPosition = _getKeyIdForPosition(_currentIndex.value);
    if (_currentIndex.value == currentIndex) {
      Get.keys[keyIdForPosition]?.currentState!.popUntil((r) => r.isFirst);
    } else {
      _currentIndex.value = currentIndex;
    }
  }

  Future<bool> onWillPop() async {
    int keyIdForPosition = _getKeyIdForPosition(_currentIndex.value);
    if (keyIdForPosition != -1) {
      bool handled = await Get.keys[keyIdForPosition]!.currentState!.maybePop();
      if (handled) {
        return false;
      }
    }
    if (_currentIndex.value != 0) {
      _currentIndex.value = 0;
      return false;
    }
    return true;
  }


  @override
  void onInit() {
    super.onInit();
  }

  int _getKeyIdForPosition(int position) {
    switch (position) {
      case DashboardNavigationIndex.card:
        return NestedNavigationIds.card;
      case DashboardNavigationIndex.catalog:
        return NestedNavigationIds.catalog;
      case DashboardNavigationIndex.home:
        return NestedNavigationIds.home;
      case DashboardNavigationIndex.settings:
        return NestedNavigationIds.settings;
      default:
        return -1;
    }
  }
}
