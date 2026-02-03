import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import '../../../utils/constants/app_assets.dart';

class ServiceItem {
  final String title;
  final String icon;

  ServiceItem(this.title, this.icon);

  Map<String, String> toMap() => {
    "title": title,
    "icon": icon,
  };

  factory ServiceItem.fromMap(Map data) {
    return ServiceItem(
      data["title"] ?? "",
      data["icon"] ?? "",
    );
  }
}

class ServiceSettingsController extends GetxController {
  late Box _box;

  final List<ServiceItem> allServices = [
    ServiceItem(r'TM CELL', AppAssets.tmCell),
    ServiceItem(r'CDMA', AppAssets.astu),
    ServiceItem(r'IP TV', AppAssets.astu),
    ServiceItem(r'home_phone', AppAssets.astu),
    ServiceItem(r'astu_internet', AppAssets.astu),
    ServiceItem(r'telecom_internet', AppAssets.telecom),
    ServiceItem(r'Belet', AppAssets.beletIcon),
    ServiceItem(r'state_traffic_safety_inspectorate', AppAssets.policeCar),
    ServiceItem(r'ÄlemTv', AppAssets.alemTv),
  ];

  final List<ServiceItem> services = [];
  final List<ServiceItem> selected = [];
  bool hasChanges = false;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('fastOperations');
    _loadSavedData();
  }

  // ---------------------------------------------------------------------------
  // LOAD SAVED DATA
  // ---------------------------------------------------------------------------

  void _loadSavedData() {
    final saved = _box.get('selected', defaultValue: <dynamic>[]);

    selected.clear();
    services.clear();

    final fullList = List<ServiceItem>.from(allServices);
    final savedItems = saved.map<ServiceItem>((e) => ServiceItem.fromMap(e)).toList();

    selected.addAll(savedItems);

    for (final item in savedItems) {
      fullList.removeWhere((x) => x.title == item.title);
    }

    services.addAll(fullList);

    hasChanges = false;
    update();
  }
  
  /// Public method to reload data from Hive - useful after clearing Hive
  void reloadFromHive() {
    selected.clear();
    services.clear();
    services.addAll(List<ServiceItem>.from(allServices));
    update();
  }

  // ---------------------------------------------------------------------------
  // SAVE
  // ---------------------------------------------------------------------------

  void saveData() {
    final listToSave = selected.map((e) => e.toMap()).toList();
    _box.put('selected', listToSave);
    Get.toNamed(DashboardScreen.route);
  }

  // ---------------------------------------------------------------------------
  // ADD SELECTED
  // ---------------------------------------------------------------------------

  void addSelectedService(ServiceItem item) {
    if (selected.length >= 4) return;

    services.remove(item);
    selected.add(item);

    hasChanges = true;
    update();
  }


  // ---------------------------------------------------------------------------
  // REMOVE SELECTED
  // ---------------------------------------------------------------------------

  void removeSelectedService(ServiceItem item) {
    selected.remove(item);
    services.add(item);

    hasChanges = true;
    update();
  }


  // ---------------------------------------------------------------------------
  // REORDER
  // ---------------------------------------------------------------------------

  void changeItemPositions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    final item = selected.removeAt(oldIndex);
    selected.insert(newIndex, item);

    hasChanges = true;
    update();
  }

}
