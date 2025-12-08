import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import '../../../utils/constants/app_assets.dart';

class ServiceItem {
  final String title;
  final String icon;

  ServiceItem(this.title, this.icon);

  Map<String, String> toMap() => {"title": title, "icon": icon};

  factory ServiceItem.fromMap(Map data) =>
      ServiceItem(data["title"], data["icon"]);
}

class ServiceSettingsController extends GetxController {
  late Box _box;

  /// All available services
  final List<ServiceItem> allServices = [
    ServiceItem(r'TM CELL', AppAssets.tmCell),
    ServiceItem(r'CDMA', AppAssets.astu),
    ServiceItem(r'IP TV', AppAssets.astu),
    ServiceItem(r'home_phone', AppAssets.astu),
    ServiceItem(r'Aştu internet', AppAssets.astu),
    ServiceItem(r'Telekom internet', AppAssets.telecom),
    ServiceItem(r'Belet', AppAssets.beletIcon),
    ServiceItem(r'state_traffic_safety_inspectorate', AppAssets.policeCar),
  ];

  /// Services shown as available
  final List<ServiceItem> services = [];

  /// Selected services (max 4)
  final List<ServiceItem> selected = [];

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('fastOperations');
    _loadSavedData();
  }

  // ---------------------------------------------------------------------------
  // LOADING DATA
  // ---------------------------------------------------------------------------

  void _loadSavedData() {
    final saved = _box.get('selected', defaultValue: <dynamic>[]);

    // Clear current
    selected.clear();
    services.clear();

    // Copy all initial items into a new list
    final fullList = List<ServiceItem>.from(allServices);

    // Load saved selected items
    final savedItems =
    saved.map<ServiceItem>((e) => ServiceItem.fromMap(e)).toList();

    selected.addAll(savedItems);

    // Remove selected from full list → remaining items are unselected
    for (final item in savedItems) {
      fullList.removeWhere((x) => x.title == item.title);
    }

    services.addAll(fullList);

    update();
  }

  // ---------------------------------------------------------------------------
  // SAVE DATA TO HIVE
  // ---------------------------------------------------------------------------

  void saveData() {
    _box.put('selected', selected.map((e) => e.toMap()).toList());
    Get.toNamed(DashboardScreen.route);
  }

  // ---------------------------------------------------------------------------
  // ADD SELECTED
  // ---------------------------------------------------------------------------

  void addSelectedService(ServiceItem item) {
    if (selected.length >= 4) return;

    services.remove(item);
    selected.add(item);
    update();
  }

  // ---------------------------------------------------------------------------
  // REMOVE SELECTED
  // ---------------------------------------------------------------------------

  void removeSelectedService(ServiceItem item) {
    selected.remove(item);
    services.add(item);
    update();
  }

  // ---------------------------------------------------------------------------
  // REORDER SELECTED
  // ---------------------------------------------------------------------------

  void changeItemPositions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    final item = selected.removeAt(oldIndex);
    selected.insert(newIndex, item);
    update();
  }
}
