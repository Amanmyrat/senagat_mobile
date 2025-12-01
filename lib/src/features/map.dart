import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const route = r'/map';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMap _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapbox Map')),
      body: MapWidget(
        styleUri: "mapbox://styles/mapbox/streets-v12",

        onMapCreated: (mapboxMap) {
          _mapboxMap = mapboxMap;
        },
      ),
    );
  }

}
