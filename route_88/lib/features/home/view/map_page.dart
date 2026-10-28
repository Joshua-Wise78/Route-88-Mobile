import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({
    super.key,
    this.latitude,
    this.longitude,
    this.showIncidentMarker = false,
  });

  final double? latitude;
  final double? longitude;
  final bool showIncidentMarker;

  // Default map location: Columbus, Ohio.
  static const LatLng defaultCenter = LatLng(
    39.959977,
    -83.006381,
  );

  @override
  Widget build(BuildContext context) {
    // Use incident coordinates when provided.
    // Otherwise, use the default Columbus location.
    final center = latitude != null && longitude != null
        ? LatLng(latitude!, longitude!)
        : defaultCenter;

    final showMarker =
        showIncidentMarker && latitude != null && longitude != null;

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: showMarker ? 14.0 : 9.2,
      ),
      children: [
        // OpenStreetMap tiles
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.verygoodcore.route_88.dev',
        ),

        // Selected incident marker
        if (showMarker)
          MarkerLayer(
            markers: [
              Marker(
                point: center,
                width: 48,
                height: 48,
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFFC33C3C),
                  size: 42,
                ),
              ),
            ],
          ),

        // OpenStreetMap attribution
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
            ),
          ],
        ),
      ],
    );
  }
}
