import 'package:get/get.dart';
import '../utils/nested_nav_ids.dart';

class DashboardController extends GetxController {

  final RxInt _currentIndex = 0.obs;
  RxInt get currentIndexRx => _currentIndex;
  int get currentIndex => _currentIndex.value;

  final RxBool _addProductEnabled = false.obs;
  bool get addProductEnabled => _addProductEnabled.value;

  String? phone;

  /// Resets dashboard tab selection and clears all nested navigator stacks.
  /// Useful after login/logout to avoid stale nested navigation state.
  void resetToHome() {
    // Pop all nested navigators to their first route (if mounted).
    for (final nestedId in <int>[
      NestedNavigationIds.home,
      NestedNavigationIds.catalog,
      NestedNavigationIds.card,
      NestedNavigationIds.settings,
    ]) {
      final state = Get.keys[nestedId]?.currentState;
      if (state != null) {
        state.popUntil((r) => r.isFirst);
      }
    }

    // Select home tab.
    _currentIndex.value = DashboardNavigationIndex.home;
  }

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
