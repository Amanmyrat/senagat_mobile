import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:senagat_mobile/src/core/globals.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../controller/map_search_controller.dart';
import '../model/location_model.dart';
import '../repository/location_repository.dart';

class MapSearchScreen extends StatefulWidget {
  static const route = r'/map/search';
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MapSearchController>(
        init: MapSearchController(
          LocationRepository(apiService: ApiServices.apiService),
        ),
        builder: (c) {
          return c.status == Status.loading
              ? Center(
            child: CircularProgressIndicator(color: AppColors.green),
          )
              : GestureDetector(
            onTap: () {
              // Remove focus when tapping outside
              c.unfocusSearch();
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
              // The map - takes full screen height
              Positioned.fill(
                child: FlutterMap(
                  mapController: c.mapController,
                  options: MapOptions(
                    initialCenter: LatLng(c.lat, c.lng),
                    initialZoom: 12.0,
                    onMapReady: () {
                      c.initializeMap();
                      c.fitMarkersInView();
                    },
                  ),
                  children: [
                    // Standard OpenStreetMap tiles
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.senagat_mobile',
                    ),
                    // Markers layer
                    MarkerLayer(
                      markers: c.markers,
                    ),
                  ],
                ),
              ),

              // Search bar row (visual) - positioned below status bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20.w,
                right: 12,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColors.greyInactive,
                                width: 1.w,
                                style: BorderStyle.solid,
                              ),
                          ),
                          child: SvgPicture.asset(AppAssets.arrowLeftIcon, width: 20.w, color: AppColors.grey,),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextFormField(
                          controller: c.searchController,
                          focusNode: c.searchFocusNode,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.primaryFont,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hintText: r'find_an_ATM'.tr,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.green,
                                width: 1.w,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 20.w,
                              minHeight: 20.h,
                            ),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                if (c.hasSearchText) {
                                  c.clearSearch();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: AppDimensions.paddingExtraLarge.w, right: AppDimensions.paddingMedium.w),
                                child: SvgPicture.asset(
                                  c.hasSearchText 
                                    ? AppAssets.deleteIcon 
                                    : AppAssets.searchIcon,
                                  width: 20.w,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.greyInactive,
                                width: 1.w,
                              ),
                            ),
                            counter: const SizedBox(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: AppDimensions.paddingLarge.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs (ATMs / Branches)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  left: 20.w,
                  child: _buildUnifiedTabs(c),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconCircle(BuildContext ctx, IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }

  Widget _buildUnifiedTabs(MapSearchController c) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.green,
          width: 2.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _unifiedTabButton(
            title: r'atm'.tr,
            selected: c.selected == LocationType.atm,
            onTap: () => c.choose(LocationType.atm),
            isLeft: true,
          ),
          _unifiedTabButton(
            title: r'branch'.tr,
            selected: c.selected == LocationType.branch,
            onTap: () => c.choose(LocationType.branch),
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _unifiedTabButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    // Selected = black background, Unselected = green background
    Color backgroundColor = selected ? const Color(0xFF2D2D2D) : AppColors.green;
    Color textColor = AppColors.white; // Always white text

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: selected 
            ? BorderRadius.circular(8.r) // Full radius when selected
            : BorderRadius.only(
                topLeft: isLeft ? Radius.circular(8.r) : Radius.zero,
                bottomLeft: isLeft ? Radius.circular(8.r) : Radius.zero,
                topRight: !isLeft ? Radius.circular(8.r) : Radius.zero,
                bottomRight: !isLeft ? Radius.circular(8.r) : Radius.zero,
              ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            fontFamily: AppFonts.primaryFont,
          ),
        ),
      ),
    );
  }
}
