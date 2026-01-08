import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/globals.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
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
          if (c.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GestureDetector(
            onTap: c.unfocusSearch,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                /// MAP
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(c.lat ?? 0, c.lng ?? 0),
                      zoom: 12,
                    ),
                    onMapCreated: c.onMapCreated,
                    markers: c.markers,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (_) => c.unfocusSearch(),
                  ),
                ),

                /// TOP BAR
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20.w,
                  right: 12.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.greyInactive,
                              width: 1.w,
                            ),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.arrowLeftIcon,
                            width: 20.w,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildUnifiedTabs(c),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnifiedTabs(MapSearchController c) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.green, width: 2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabButton(
            title: r'atm'.tr,
            selected: c.selected == LocationType.atm,
            isLeft: true,
            onTap: () => c.choose(LocationType.atm),
          ),
          _tabButton(
            title: r'branch'.tr,
            selected: c.selected == LocationType.branch,
            isLeft: false,
            onTap: () => c.choose(LocationType.branch),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String title,
    required bool selected,
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2D2D2D) : AppColors.green,
          borderRadius: selected
              ? BorderRadius.circular(8.r)
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
            color: AppColors.white,
            fontSize: 14.sp,
            fontFamily: AppFonts.primaryFont,
          ),
        ),
      ),
    );
  }
}
