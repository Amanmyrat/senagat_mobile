import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';

// MapKit imports (note the aliases)
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as ymk;   // Map, CameraPosition, Point, etc.
import 'package:yandex_maps_mapkit_lite/image.dart' as yimg;   // ImageProvider.fromImageProvider

import '../model/location_model.dart';

class MapSearchController extends GetxController with StateControlMixin {
  // private storage + public getter (as you requested)
  final List<LocationModel> _locations = [];
  List<LocationModel> get locations => _locations;

  // active tab
  LocationType selected = LocationType.atm;

  ymk.MapWindow? _mapWindow;

  @override
  void onInit() {
    super.onInit();

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

  // from screen
  void onMapCreated(ymk.MapWindow mapWindow) {
    _mapWindow = mapWindow;
    _render();
  }

  void choose(LocationType t) {
    if (selected == t) return;
    selected = t;
    _render();
    update();
  }

  List<LocationModel> get _visible =>
      _locations.where((e) => e.type == selected).toList();

  void _render() {
    final map = _mapWindow?.map;
    if (map == null) return;

    map.mapObjects.clear();

    for (final loc in _visible) {
      final pinPath = (loc.type == LocationType.atm)
          ? AppAssets.mapPinGreenIcon
          : AppAssets.mapPinBlackIcon;

      // NOTE: import from yandex_maps_mapkit_lite/image.dart
      final icon = yimg.ImageProvider.fromImageProvider(AssetImage(pinPath));

      final placemark = map.mapObjects.addPlacemark()
        ..geometry = ymk.Point(latitude: loc.lat, longitude: loc.lng)
        ..setIcon(icon);

      placemark.addTapListener(_PlacemarkTap((_) {
        Get.snackbar(loc.name, loc.address,
            duration: const Duration(seconds: 2));
        return true;
      }));
    }

    if (_visible.isNotEmpty) {
      _moveToBounds(_visible);
    }
  }

  void _moveToBounds(List<LocationModel> items) {
    final map = _mapWindow?.map;
    if (map == null) return;

    double minLat = items.first.lat, maxLat = items.first.lat;
    double minLng = items.first.lng, maxLng = items.first.lng;

    for (final e in items) {
      if (e.lat < minLat) minLat = e.lat;
      if (e.lat > maxLat) maxLat = e.lat;
      if (e.lng < minLng) minLng = e.lng;
      if (e.lng > maxLng) maxLng = e.lng;
    }

    final center = ymk.Point(
      latitude: (minLat + maxLat) / 2,
      longitude: (minLng + maxLng) / 2,
    );

    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    final span = latSpan > lngSpan ? latSpan : lngSpan;
    final zoom = span < 0.01 ? 14.5 : span < 0.03 ? 13 : 12;

    map.move(ymk.CameraPosition(center, zoom: zoom.toDouble(), azimuth: 0, tilt: 0));
  }
}

class _PlacemarkTap implements ymk.MapObjectTapListener {
  final bool Function(ymk.Point) onTap;
  _PlacemarkTap(this.onTap);
  @override
  bool onMapObjectTap(ymk.MapObject mapObject, ymk.Point point) => onTap(point);
}
