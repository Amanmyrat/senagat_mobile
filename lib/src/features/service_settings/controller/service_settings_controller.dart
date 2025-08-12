import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../core/control_state_variable_mixin.dart';

class ServiceSettingsController extends GetxController with StateControlMixin {
  final List<String> selectedServiceTitle = [];
  final List<String> selectedServiceIcons = [];

  final List<String> serviceIcons = [
    AppAssets.deviceMobileIcon,
    AppAssets.globeIcon,
    AppAssets.flameIcon,
    AppAssets.dropIcon,
    AppAssets.stickIcon,
    AppAssets.lightbulbIcon,
    AppAssets.buildingApartmentIcon,
  ];

  final List<String> serviceTitle = [
    r'Altyn Asyr'.tr,
    r'Net и Tv'.tr,
    r'Газ'.tr,
    r'Вода'.tr,
    r'ГИБДД'.tr,
    r'Свет'.tr,
    r'Комуналка'.tr,
  ];

  late Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('fast_operations');
    _loadSavedData();
  }

  void saveData() {
    _box.put('selected_titles', selectedServiceTitle);
    _box.put('selected_icons', selectedServiceIcons);
    Get.toNamed(DashboardScreen.route,);
  }

  void _loadSavedData() {
    final savedTitles = _box.get('selected_titles', defaultValue: <String>[]);
    final savedIcons = _box.get('selected_icons', defaultValue: <String>[]);

    selectedServiceTitle.clear();
    selectedServiceIcons.clear();
    selectedServiceTitle.addAll(savedTitles);
    selectedServiceIcons.addAll(savedIcons);

    // Remove already selected from available lists
    for (int i = 0; i < savedTitles.length; i++) {
      serviceTitle.remove(savedTitles[i]);
      serviceIcons.remove(savedIcons[i]);
    }

    update();
  }

  void addSelectedService(String selectedTitle, String selectedIcon) {
    if (selectedServiceTitle.length < 4) {
      serviceTitle.remove(selectedTitle);
      serviceIcons.remove(selectedIcon);

      selectedServiceTitle.add(selectedTitle);
      selectedServiceIcons.add(selectedIcon);
    }
    update();
  }

  void removeSelectedService(String selectedTitle, String selectedIcon) {
    selectedServiceTitle.remove(selectedTitle);
    selectedServiceIcons.remove(selectedIcon);

    serviceTitle.add(selectedTitle);
    serviceIcons.add(selectedIcon);
    update();
  }

  void changeItemPositions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final titleItem = selectedServiceTitle.removeAt(oldIndex);
    final iconItem = selectedServiceIcons.removeAt(oldIndex);
    selectedServiceTitle.insert(newIndex, titleItem);
    selectedServiceIcons.insert(newIndex, iconItem);
    update();
  }
}
