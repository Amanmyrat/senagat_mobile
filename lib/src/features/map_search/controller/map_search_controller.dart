import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';

import '../model/location_model.dart';

class MapSearchController extends GetxController with StateControlMixin {
  // private storage + public getter (as you requested)
  final List<LocationModel> _locations = [];
  List<LocationModel> get locations => _locations;

  // active tab
  LocationType selected = LocationType.atm;

  // search functionality
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  
  // getter for search text to trigger UI updates
  String get searchText => searchController.text;
  bool get hasSearchText => searchController.text.isNotEmpty;

  // Flutter Map controller
  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    
    // Listen to search text changes
    searchController.addListener(() {
      update(); // Update UI when search text changes
    });

    // seed (replace with REST later)
    _locations.addAll([
      LocationModel(
        id: 1,
        type: LocationType.atm,
        name: "Bevis Bass",
        address: "Tempor consequatur ",
        lat: 37.910114,
        lng: 58.397884,
      ),
      LocationModel(
        id: 2,
        type: LocationType.atm,
        name: "Ai for disabled",
        address: "Tempor consequatur ",
        lat: 37.923704,
        lng: 58.380968,
      ),
      LocationModel(
        id: 3,
        type: LocationType.branch,
        name: "Mobile app dev",
        address: "1111111111111111",
        lat: 37.907508,
        lng: 58.370909,
      ),
    ]);
  }

  // Initialize map - called after map is ready
  void initializeMap() {
    // Move to initial position
    mapController.move(
      LatLng(37.910114, 58.397884),
      12.0,
    );
  }

  void choose(LocationType t) {
    if (selected == t) return;
    selected = t;
    update(); // This will trigger UI rebuild with new markers
    
    // Fit the new markers in view after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      fitMarkersInView();
    });
  }
  
  void clearSearch() {
    searchController.clear();
    // update() will be called automatically by the listener
  }
  
  void unfocusSearch() {
    searchFocusNode.unfocus();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    mapController.dispose();
    super.onClose();
  }

  // Get visible locations based on selected type
  List<LocationModel> get visibleLocations =>
      _locations.where((e) => e.type == selected).toList();

  // Get markers for flutter_map
  List<Marker> get markers {
    return visibleLocations.map((loc) {
      final iconPath = (loc.type == LocationType.atm)
          ? AppAssets.mapPinGreenIcon
          : AppAssets.mapPinBlackIcon;

      return Marker(
        point: LatLng(loc.lat, loc.lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            Get.snackbar(
              loc.name, 
              loc.address,
              duration: const Duration(seconds: 2),
            );
          },
          child: Image.asset(
            iconPath,
            width: 40,
            height: 40,
          ),
        ),
      );
    }).toList();
  }

  // Move map to fit all visible markers
  void fitMarkersInView() {
    if (visibleLocations.isEmpty) return;
    
    double minLat = visibleLocations.first.lat;
    double maxLat = visibleLocations.first.lat;
    double minLng = visibleLocations.first.lng;
    double maxLng = visibleLocations.first.lng;

    for (final loc in visibleLocations) {
      if (loc.lat < minLat) minLat = loc.lat;
      if (loc.lat > maxLat) maxLat = loc.lat;
      if (loc.lng < minLng) minLng = loc.lng;
      if (loc.lng > maxLng) maxLng = loc.lng;
    }

    final center = LatLng(
      (minLat + maxLat) / 2,
      (minLng + maxLng) / 2,
    );

    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    final span = latSpan > lngSpan ? latSpan : lngSpan;
    final zoom = span < 0.01 ? 14.5 : span < 0.03 ? 13.0 : 12.0;

    mapController.move(center, zoom);
  }

  
}
