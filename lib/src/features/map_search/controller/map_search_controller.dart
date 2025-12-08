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
import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../model/location_model.dart';
import '../../../utils/api_error_handler.dart';

class MapSearchController extends GetxController with StateControlMixin {
  /// ---------------------------------------
  /// LOCATIONS
  /// ---------------------------------------
  final List<LocationModel> _locations = [];
  List<LocationModel> get locations => _locations;

  LocationRepository repository;
  MapSearchController(this.repository);

  /// Active tab
  LocationType selected = LocationType.atm;

  /// Search
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  String get searchText => searchController.text;
  bool get hasSearchText => searchController.text.isNotEmpty;

  /// Map values
  double? lat;
  double? lng;

  final MapController mapController = MapController();

  bool _isMapReady = false;
  LatLng? _queuedCenter;
  double? _queuedZoom;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      update();
    });

    getLocations();
  }

  /// ---------------------------------------
  /// FETCH LOCATIONS
  /// ---------------------------------------
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
          }
          print(
            "VISIBLE ${selected.name}: "
            "${visibleLocations.length}",
          );

          update();

          // wait map load
          Future.delayed(const Duration(milliseconds: 300), () {
            initializeMap();
            fitMarkersInView();
          });
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        });
  }

  /// ---------------------------------------
  /// MAP READY
  /// ---------------------------------------
  void onMapReady() {
    _isMapReady = true;

    if (_queuedCenter != null && _queuedZoom != null) {
      mapController.move(_queuedCenter!, _queuedZoom!);
      _queuedCenter = null;
      _queuedZoom = null;
    }
  }

  /// ---------------------------------------
  /// INIT MAP
  /// ---------------------------------------
  void initializeMap() {
    if (lat == null || lng == null) return;

    final center = LatLng(lat!, lng!);
    const zoom = 13.0;

    if (!_isMapReady) {
      _queuedCenter = center;
      _queuedZoom = zoom;
      return;
    }

    mapController.move(center, zoom);
  }

  /// ---------------------------------------
  /// CHOOSE ATM / BRANCH TAB
  /// ---------------------------------------
  void choose(LocationType t) {
    if (selected == t) return;

    selected = t;
    update();

    Future.delayed(const Duration(milliseconds: 200), () {
      fitMarkersInView();
    });
  }

  /// ---------------------------------------
  /// SEARCH
  /// ---------------------------------------
  void clearSearch() {
    searchController.clear();
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

  /// ---------------------------------------
  /// MARKERS
  /// ---------------------------------------
  List<LocationModel> get visibleLocations =>
      _locations.where((e) => e.type == selected).toList();

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
            showBottomSheet(loc);
          },
          child: Image.asset(iconPath, width: 40, height: 40),
        ),
      );
    }).toList();
  }

  /// ---------------------------------------
  /// BOTTOM SHEET
  /// ---------------------------------------
  void showBottomSheet(LocationModel loc) {
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
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loc.type.name.tr,
                    style: TextStyle(color: AppColors.black, fontSize: 24.sp),
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
                  if (loc.workingHours != null && loc.workingHours!.isNotEmpty)
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
                      onPressed: () {},
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
  }

  /// ---------------------------------------
  /// FIT ALL MARKERS
  /// ---------------------------------------
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

    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    final span = latSpan > lngSpan ? latSpan : lngSpan;

    final zoom = span < 0.01
        ? 14.5
        : span < 0.03
        ? 13.0
        : 12.0;

    if (!_isMapReady) {
      _queuedCenter = center;
      _queuedZoom = zoom;
      return;
    }

    mapController.move(center, zoom);
  }
}
