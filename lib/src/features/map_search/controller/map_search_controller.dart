import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';

import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
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
          onTap: (){
            showModalBottomSheet(
                isScrollControlled: true,
                context: Get.context!,
                backgroundColor: AppColors.inputFillBackground,
                builder: (_){
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
                                  Text(r'bank'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                                  SizedBox(height: 22.h,),
                                  Row(
                                    children: [
                                      Text(r'Проспект Махтумкули 43. Ашхабад'.tr, style: TextStyle(color: AppColors.greyInactive, fontSize: 14.sp),),
                                    ],
                                  ),
                                  SizedBox(height: 22.h,),
                                  Row(
                                    children: [
                                      Text(r'Открыто'.tr, style: TextStyle(color: AppColors.green, fontSize: 14.sp),),
                                      SizedBox(width: 10.h,),
                                      Text(r'Закроется в 18:00'.tr, style: TextStyle(color: AppColors.greyInactive, fontSize: 14.sp),),
                                    ],
                                  ),
                                  SizedBox(height: 22.h,),
                                  Row(
                                    children: [
                                      Text(r'Телефон тех поддержки'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),),
                                      SizedBox(width: 10.h,),
                                      Text('+993 12 345678'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),),
                                    ],
                                  ),
                                  SizedBox(height: 22.h,),
                                  SizedBox(
                                      width: MediaQuery.of(Get.context!).size.width,
                                      child: ElevatedButtonWithState(
                                        isLoading: false,
                                        isError: false,
                                        onPressed: (){

                                        },
                                        child: Text(r'Позвонить'.tr, style: TextStyle(color: AppColors.white, fontSize: 14.sp),),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                });
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
