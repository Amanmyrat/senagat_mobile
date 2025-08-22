import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

import '../controller/map_search_controller.dart';
import '../model/location_model.dart';

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
      body: SafeArea(
        child: GetBuilder<MapSearchController>(
          init: MapSearchController(),
          builder: (c) {
            return Stack(
              children: [
                // The map
                YandexMap(onMapCreated: c.onMapCreated),

                // Search bar row (visual)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _iconCircle(
                        context,
                        Icons.arrow_back,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBFD7C5), width: 1),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search, size: 18),
                              SizedBox(width: 8),
                              Text('ул. Шевченко', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs (ATMs / Branches)
                Positioned(
                  top: 70,
                  left: 16,
                  child: Row(
                    children: [
                      _tabButton(
                        title: 'Банкоматы',
                        selected: c.selected == LocationType.atm,
                        onTap: () => c.choose(LocationType.atm),
                      ),
                      const SizedBox(width: 8),
                      _tabButton(
                        title: 'Офис',
                        selected: c.selected == LocationType.branch,
                        onTap: () => c.choose(LocationType.branch),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
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

  Widget _tabButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D7A58) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF3D7A58)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF3D7A58),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
