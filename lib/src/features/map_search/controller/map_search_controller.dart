import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../model/location_model.dart';
import '../repository/location_repository.dart';

class MapSearchController extends GetxController {
  final LocationRepository repository;
  MapSearchController(this.repository);

  /// STATE
  Status status = Status.loading;

  /// MAP
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  LatLng? _queuedCenter;
  double? _queuedZoom;

  double? lat;
  double? lng;

  /// DATA
  final List<LocationModel> _locations = [];
  List<LocationModel> get locations => _locations;

  LocationType selected = LocationType.atm;

  /// SEARCH
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  /// MAP CREATED
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    if (_queuedCenter != null && _queuedZoom != null) {
      _mapController!.moveCamera(
        CameraUpdate.newLatLngZoom(_queuedCenter!, _queuedZoom!),
      );
      _queuedCenter = null;
      _queuedZoom = null;
    }
  }

  /// INIT MAP POSITION
  void initializeMap() {
    if (lat == null || lng == null) return;

    final center = LatLng(lat!, lng!);
    const zoom = 13.0;

    if (!_isMapReady) {
      _queuedCenter = center;
      _queuedZoom = zoom;
      return;
    }

    _mapController!.moveCamera(
      CameraUpdate.newLatLngZoom(center, zoom),
    );
  }

  /// MARKERS
  Set<Marker> get markers {
    return visibleLocations.map((loc) {
      return Marker(
        markerId: MarkerId('${loc.lat}_${loc.lng}'),
        position: LatLng(loc.lat, loc.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          loc.type == LocationType.atm
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueAzure,
        ),
        onTap: () => showBottomSheet(loc),
      );
    }).toSet();
  }

  /// FETCH LOCATIONS
  void getLocations() async {
    status = Status.loading;
    update();

    await repository.getLocations().then((value) {
      _locations.addAll(value);
      status = Status.completed;

      if (_locations.isNotEmpty) {
        lat = _locations.first.lat;
        lng = _locations.first.lng;
      }

      update();

      Future.delayed(const Duration(milliseconds: 300), () {
        initializeMap();
        fitMarkersInView();
      });
    }).catchError((e) {
      status = Status.error;
      update();
      ApiErrorHandler.handleApiError(e);
    });
  }

  /// FIT MARKERS
  void fitMarkersInView() {
    if (visibleLocations.isEmpty || !_isMapReady) return;

    double minLat = visibleLocations.first.lat;
    double maxLat = visibleLocations.first.lat;
    double minLng = visibleLocations.first.lng;
    double maxLng = visibleLocations.first.lng;

    for (final loc in visibleLocations) {
      minLat = minLat < loc.lat ? minLat : loc.lat;
      maxLat = maxLat > loc.lat ? maxLat : loc.lat;
      minLng = minLng < loc.lng ? minLng : loc.lng;
      maxLng = maxLng > loc.lng ? maxLng : loc.lng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  /// TAB SWITCH
  void choose(LocationType t) {
    if (selected == t) return;
    selected = t;
    update();
    Future.delayed(const Duration(milliseconds: 200), fitMarkersInView);
  }

  /// SEARCH
  void unfocusSearch() {
    searchFocusNode.unfocus();
  }

  /// VISIBLE LOCATIONS
  List<LocationModel> get visibleLocations =>
      _locations.where((e) => e.type == selected).toList();

  /// BOTTOM SHEET
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
  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
