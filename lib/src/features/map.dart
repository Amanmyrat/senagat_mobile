import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const route = r'/map';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// class _MapScreenState extends State<MapScreen> {
//   late MapboxMap _mapboxMap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mapbox Map')),
//       body: MapWidget(
//         styleUri: "mapbox://styles/mapbox/streets-v12",
//
//         onMapCreated: (mapboxMap) {
//           _mapboxMap = mapboxMap;
//         },
//       ),
//     );
//   }
//
// }

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  // Center on Ashgabat, Turkmenistan
  static const CameraPosition _kAshgabat = CameraPosition(
    target: LatLng(37.9601, 58.3261), // Ashgabat city center
    zoom: 14.0,
  );

  // Optional: Second camera target
  static const CameraPosition _kPlace2 = CameraPosition(
    target: LatLng(37.9485, 58.3850), // Example: Monument Arch of Neutrality
    zoom: 17.0,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("marker1"),
      position: LatLng(37.9601, 58.3261), // City Center
      infoWindow: InfoWindow(title: "Ashgabat City Center"),
    ),
    Marker(
      markerId: MarkerId("marker2"),
      position: LatLng(37.9485, 58.3850), // Monument of Neutrality example
      infoWindow: InfoWindow(title: "Monument of Neutrality"),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid, // 2D map
        markers: _markers,
        initialCameraPosition: _kAshgabat,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToSecondPlace,
        label: const Text('Go to Monument'),
        icon: const Icon(Icons.place),
      ),
    );
  }

  Future<void> _goToSecondPlace() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_kPlace2),
    );
  }
}
