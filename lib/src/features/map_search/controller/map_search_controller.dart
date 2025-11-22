import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/map_search/repository/location_repository.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../model/location_model.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../utils/services/error_utils.dart';

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

  late double? lat;
  late double lng;

  // Flutter Map controller
  final MapController mapController = MapController();

  // Map readiness & queued camera move
  bool _isMapReady = false;
  LatLng? _queuedCenter;
  double? _queuedZoom;

  LocationRepository repository;

  MapSearchController(this.repository);

  @override
  void onInit() {
    super.onInit();

    // Listen to search text changes
    searchController.addListener(() {
      update(); // Update UI when search text changes
    });

    getLocations();
  }

  void getLocations() async {
    status = Status.loading;
    update();
    await repository
        .getLocations()
        .then((value) {
          _locations.addAll(value);

          status = Status.completed;

          if (_locations.isNotEmpty) {
            lat = _locations.first.lat;
            lng = _locations.first.lng;
            initializeMap();
          }
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();

          final errorText = ErrorUtils.extractErrorText(e);
          ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

          debugPrint(e.toString());
        });
  }

  // To be called by the view from FlutterMap.onMapReady
  void onMapReady() {
    _isMapReady = true;
    if (_queuedCenter != null && _queuedZoom != null) {
      mapController.move(_queuedCenter!, _queuedZoom!);
      _queuedCenter = null;
      _queuedZoom = null;
    }
  }

  // Initialize/center map; queues the move if map isn't ready yet
  void initializeMap() {
    final targetCenter = LatLng(lat ?? 0, lng);
    const targetZoom = 13.0;

    if (!_isMapReady) {
      _queuedCenter = targetCenter;
      _queuedZoom = targetZoom;
      return;
    }

    mapController.move(targetCenter, targetZoom);
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
            showModalBottomSheet(
              isScrollControlled: true,
              context: Get.context!,
              backgroundColor: AppColors.inputFillBackground,
              builder: (_) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(Get.context!).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                        horizontal: 20.w,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loc.type.name.tr,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 22.h),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  loc.address.tr,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14.sp,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),

                          if (loc.workingHours != null &&
                              loc.workingHours!.isNotEmpty)
                            ...loc.workingHours!.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  children: [
                                    Text(
                                      item.day ?? '',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      '${item.from} - ${item.to}',
                                      style: TextStyle(
                                        color: AppColors.greyInactive,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              Text(
                                r'technical_support_num'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                loc.phoneNumber.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWithState(
                              isLoading: false,
                              isError: false,
                              onPressed: () {
                                // handle call logic here
                              },
                              child: Text(
                                r'call'.tr,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Image.asset(iconPath, width: 40, height: 40),
        ),
      );
    }).toList();
  }

  // Move map to fit all visible markers
  void fitMarkersInView() {
    if (visibleLocations.isEmpty) return;

    // If map isn't ready yet, compute and queue the move for later
    if (!_isMapReady) {
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

      final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

      final latSpan = (maxLat - minLat).abs();
      final lngSpan = (maxLng - minLng).abs();
      final span = latSpan > lngSpan ? latSpan : lngSpan;
      final zoom = span < 0.01
          ? 14.5
          : span < 0.03
          ? 13.0
          : 12.0;

      _queuedCenter = center;
      _queuedZoom = zoom;
      return;
    }

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

    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    final span = latSpan > lngSpan ? latSpan : lngSpan;
    final zoom = span < 0.01
        ? 14.5
        : span < 0.03
        ? 13.0
        : 12.0;

    mapController.move(center, zoom);
  }
}
