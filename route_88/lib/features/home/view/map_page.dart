
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';
import 'package:route_88/features/route88/bloc/construction/construction_bloc.dart';
import 'package:route_88/features/route88/bloc/construction/construction_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.latitude,
    this.longitude,
    this.showIncidentMarker = false,
  });

  final double? latitude;
  final double? longitude;
  final bool showIncidentMarker;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const Color primaryColor = Color(0xFF123B66);
  static const Color incidentColor = Color(0xFFC33C3C);
  static const Color constructionColor = Color(0xFFE68A2E);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  static const LatLng defaultCenter = LatLng(
    39.7589,
    -84.1916,
  );

  // Map filter settings.
  bool showIncidents = true;
  bool showConstruction = true;

  bool _hasValidCoordinates(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        !(latitude == 0 && longitude == 0);
  }

  // Display the filter options.
  void _showMapFilters() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, updateSheet) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Map Filters',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Choose which traffic events appear on your map.',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Incidents'),
                      secondary: const Icon(
                        Icons.warning_amber_rounded,
                        color: incidentColor,
                      ),
                      activeColor: primaryColor,
                      value: showIncidents,
                      onChanged: (value) {
                        setState(() {
                          showIncidents = value;
                        });
                        updateSheet(() {});
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Construction'),
                      secondary: const Icon(
                        Icons.construction,
                        color: constructionColor,
                      ),
                      activeColor: primaryColor,
                      value: showConstruction,
                      onChanged: (value) {
                        setState(() {
                          showConstruction = value;
                        });
                        updateSheet(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            showIncidents = true;
                            showConstruction = true;
                          });
                          updateSheet(() {});
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEventDetails(
    BuildContext context, {
    required String title,
    required String description,
    required Color eventColor,
    required IconData eventIcon,
    String? location,
    String? direction,
    String? status,
    String? startDate,
    String? endDate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.sizeOf(sheetContext).height * 0.55,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        eventIcon,
                        color: eventColor,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  if (location != null ||
                      direction != null ||
                      status != null ||
                      startDate != null ||
                      endDate != null) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                  ],

                  if (location != null) ...[
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: location,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (direction != null) ...[
                    _buildDetailRow(
                      icon: Icons.signpost_outlined,
                      label: 'Direction',
                      value: direction,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (status != null && status.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.info_outline,
                      label: 'Status',
                      value: status,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (startDate != null &&
                      startDate.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.event,
                      label: 'Start Date',
                      value: startDate,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (endDate != null && endDate.isNotEmpty) ...[
                    _buildDetailRow(
                      icon: Icons.event_available,
                      label: 'End Date',
                      value: endDate,
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Marker _createMarker(
    BuildContext context, {
    required LatLng point,
    required String title,
    required String description,
    required Color markerColor,
    required IconData eventIcon,
    String? location,
    String? direction,
    String? status,
    String? startDate,
    String? endDate,
  }) {
    return Marker(
      point: point,
      width: 48,
      height: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _showEventDetails(
            context,
            title: title,
            description: description,
            eventColor: markerColor,
            eventIcon: eventIcon,
            location: location,
            direction: direction,
            status: status,
            startDate: startDate,
            endDate: endDate,
          );
        },
        child: Icon(
          Icons.location_on,
          color: markerColor,
          size: 42,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedIncident =
        widget.showIncidentMarker &&
        widget.latitude != null &&
        widget.longitude != null &&
        _hasValidCoordinates(
          widget.latitude!,
          widget.longitude!,
        );

    final center = hasSelectedIncident
        ? LatLng(widget.latitude!, widget.longitude!)
        : defaultCenter;

    return BlocBuilder<IncidentsBloc, IncidentsState>(
      builder: (context, incidentState) {
        return BlocBuilder<ConstructionBloc, ConstructionState>(
          builder: (context, constructionState) {
            final markers = <Marker>[];

            // Always show a specifically selected incident.
            if (hasSelectedIncident) {
              markers.add(
                Marker(
                  point: center,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_on,
                    color: incidentColor,
                    size: 42,
                  ),
                ),
              );
            } else {
              if (showIncidents && incidentState is IncidentsLoaded) {
                for (final incident in incidentState.incidents) {
                  if (!_hasValidCoordinates(
                    incident.latitude,
                    incident.longitude,
                  )) {
                    continue;
                  }

                  markers.add(
                    _createMarker(
                      context,
                      point: LatLng(
                        incident.latitude,
                        incident.longitude,
                      ),
                      title: incident.routeName ??
                          incident.category ??
                          'Traffic Incident',
                      description: incident.description ??
                          'No description available.',
                      markerColor: incidentColor,
                      eventIcon: Icons.warning_amber_rounded,
                      location: incident.location,
                      direction: incident.direction,
                    ),
                  );
                }
              }

              if (showConstruction &&
                  constructionState is ConstructionLoaded) {
                for (final construction
                    in constructionState.construction) {
                  if (!_hasValidCoordinates(
                    construction.latitude,
                    construction.longitude,
                  )) {
                    continue;
                  }

                  markers.add(
                    _createMarker(
                      context,
                      point: LatLng(
                        construction.latitude,
                        construction.longitude,
                      ),
                      title: construction.routeName ??
                          'Road Construction',
                      description: construction.description ??
                          construction.workZone?.description ??
                          'No description available.',
                      markerColor: constructionColor,
                      eventIcon: Icons.construction,
                      location: construction.location,
                      direction: construction.direction,
                      status: construction.status,
                      startDate: construction.startDate,
                      endDate: construction.endDate,
                    ),
                  );
                }
              }
            }

            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: hasSelectedIncident ? 14.0 : 9.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.verygoodcore.route_88.dev',
                    ),
                    MarkerLayer(markers: markers),
                    const RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),

                // Filter button above the map.
                if (!hasSelectedIncident)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: SafeArea(
                      child: FloatingActionButton.small(
                        heroTag: 'map_filters',
                        backgroundColor: backgroundColor,
                        foregroundColor: primaryColor,
                        tooltip: 'Map filters',
                        onPressed: _showMapFilters,
                        child: const Icon(Icons.tune),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}