import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/home/widgets/commute_picker_sheet.dart';
import 'package:route_88/features/home/widgets/commute_summary_card.dart';
import 'package:route_88/features/home/widgets/map_filters_sheet.dart';
import 'package:route_88/features/home/widgets/map_marker_builder.dart';
import 'package:route_88/features/route88/bloc/construction/construction_bloc.dart';
import 'package:route_88/features/route88/bloc/construction/construction_state.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_bloc.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_state.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/bloc/routing_state.dart';
import 'package:route_88/features/routing/models/commute_check_result.dart';
import 'package:route_88/core/settings/app_settings.dart';
class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.latitude,
    this.longitude,
    this.showIncidentMarker = false,
    this.searchRadiusMiles = 50,
    this.searchCenterLatitude = 39.9612,
    this.searchCenterLongitude = -83.0019,
    this.onLocationRefreshRequested,
  });

  final double? latitude;
  final double? longitude;
  final bool showIncidentMarker;
  final double searchRadiusMiles;
  final double searchCenterLatitude;
  final double searchCenterLongitude;
  final VoidCallback? onLocationRefreshRequested;

  @override
  State<MapPage> createState() => _MapPageState();
}

  class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  bool get showIncidents => AppSettings.instance.showIncidents;
  bool get showSlowdowns => AppSettings.instance.showSlowdowns;
  bool get showConstruction => AppSettings.instance.showConstruction;

  @override
  void initState() {
    super.initState();
    AppSettings.instance.addListener(_updateSettings);
  }

  void _updateSettings() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppSettings.instance.removeListener(_updateSettings);
    _mapController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchCenterLatitude != widget.searchCenterLatitude ||
        oldWidget.searchCenterLongitude != widget.searchCenterLongitude) {
      _mapController.move(
        LatLng(widget.searchCenterLatitude, widget.searchCenterLongitude),
        _mapController.camera.zoom,
      );
    }
  }

  ({
    List<Marker> markers,
    List<Polyline> polylines,
    LatLng center,
    double zoom,
  }) _resolveMapElements({
    required CommuteCheckResult? commuteResult,
    required IncidentsState incidentState,
    required ConstructionState constructionState,
    required SlowdownsState slowdownState,
  }) {
    final markers = <Marker>[];
    final polylines = <Polyline>[];
    final LatLng center;
    final double zoom;

    if (commuteResult != null) {
      final routeCoords = commuteResult.route.coordinates;
      final routePoints =
          routeCoords.map((c) => LatLng(c.lat, c.lng)).toList();

      if (routePoints.isNotEmpty) {
        polylines
          ..add(
            Polyline(
              points: routePoints,
              color: MapTheme.routeBorder,
              strokeWidth: 7,
            ),
          )
          ..add(
            Polyline(
              points: routePoints,
              color: MapTheme.route,
              strokeWidth: 5,
            ),
          );

        markers
          ..add(
            MapMarkerBuilder.routeEndpoint(
              point: routePoints.first,
              isStart: true,
            ),
          )
          ..add(
            MapMarkerBuilder.routeEndpoint(
              point: routePoints.last,
              isStart: false,
            ),
          )
          ..addAll(
            commuteResult.hazards
                .map((h) => MapMarkerBuilder.fromRouteHazard(context, h))
                .whereType<Marker>(),
          );

        center = routePoints[routePoints.length ~/ 2];
        zoom = 8.5;
      } else {
        center = LatLng(
          widget.searchCenterLatitude,
          widget.searchCenterLongitude,
        );
        zoom = 9.2;
      }
    } else if (widget.showIncidentMarker &&
        widget.latitude != null &&
        widget.longitude != null &&
        MapMarkerBuilder.hasValidCoordinates(
          widget.latitude!,
          widget.longitude!,
        )) {
      center = LatLng(widget.latitude!, widget.longitude!);
      zoom = 14;
      markers.add(
        Marker(
          point: center,
          width: 48,
          height: 48,
          child: const Icon(
            Icons.location_on,
            color: MapTheme.incident,
            size: 42,
          ),
        ),
      );
    } else {
      center = LatLng(
        widget.searchCenterLatitude,
        widget.searchCenterLongitude,
      );
      zoom = 9.2;

      if (showIncidents && incidentState is IncidentsLoaded) {
        markers.addAll(
          incidentState.incidents
              .map((i) => MapMarkerBuilder.fromIncident(context, i))
              .whereType<Marker>(),
        );
      }

      if (showSlowdowns && slowdownState is SlowdownsLoaded) {
        markers.addAll(
          slowdownState.slowdowns
              .map((s) => MapMarkerBuilder.fromSlowdown(context, s))
              .whereType<Marker>(),
        );
      }

      if (showConstruction && constructionState is ConstructionLoaded) {
        markers.addAll(
          constructionState.construction
              .map((c) => MapMarkerBuilder.fromConstruction(context, c))
              .whereType<Marker>(),
        );
      }

      markers.add(MapMarkerBuilder.userLocation(center));
    }

    return (
      markers: markers,
      polylines: polylines,
      center: center,
      zoom: zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routingState = context.watch<RoutingBloc>().state;
    final incidentState = context.watch<IncidentsBloc>().state;
    final constructionState = context.watch<ConstructionBloc>().state;
    final slowdownState = context.watch<SlowdownsBloc>().state;

    final commuteResult = routingState is CommuteCheckLoaded
        ? routingState.commuteResult
        : null;
    final isCommuteActive = commuteResult != null;

    final mapData = _resolveMapElements(
      commuteResult: commuteResult,
      incidentState: incidentState,
      constructionState: constructionState,
      slowdownState: slowdownState,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: mapData.center,
            initialZoom: mapData.zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.verygoodcore.route_88.dev',
            ),
            if (!widget.showIncidentMarker && !isCommuteActive)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(
                      widget.searchCenterLatitude,
                      widget.searchCenterLongitude,
                    ),
                    radius: widget.searchRadiusMiles * 1609.344,
                    useRadiusInMeter: true,
                    color: MapTheme.primary.withValues(alpha: 0.12),
                    borderColor: MapTheme.primary,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            if (mapData.polylines.isNotEmpty)
              PolylineLayer(polylines: mapData.polylines),
            MarkerLayer(markers: mapData.markers),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),

        // Commute active summary card
        if (isCommuteActive)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: SafeArea(
              child: CommuteSummaryCard(result: commuteResult),
            ),
          ),

        // Loading pill indicator
        if (routingState is CommuteCheckLoading)
          Positioned(
            top: 20,
            left: 32,
            right: 32,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: MapTheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Checking 500m corridor hazards...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Commute action button on bottom left
        Positioned(
          bottom: 24,
          left: 16,
          child: SafeArea(
            child: FloatingActionButton.extended(
              heroTag: 'commute_picker',
              backgroundColor: MapTheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.alt_route),
              label: Text(isCommuteActive ? 'Switch Route' : 'Commute'),
              onPressed: () => CommutePickerSheet.show(
                context,
                currentLatitude: widget.searchCenterLatitude,
                currentLongitude: widget.searchCenterLongitude,
              ),
            ),
          ),
        ),

        // Map utility buttons on bottom right
        Positioned(
          bottom: 24,
          right: 16,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'my_location',
                  backgroundColor: MapTheme.background,
                  foregroundColor: MapTheme.primary,
                  tooltip: 'My Location',
                  onPressed: () {
                    widget.onLocationRefreshRequested?.call();
                    _mapController.move(
                      LatLng(
                        widget.searchCenterLatitude,
                        widget.searchCenterLongitude,
                      ),
                      11.5,
                    );
                  },
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: 'map_filters',
                  backgroundColor: MapTheme.background,
                  foregroundColor: MapTheme.primary,
                  tooltip: 'Map filters',
                  onPressed: () {
                    MapFiltersSheet.show(
                      context,
                      showIncidents: showIncidents,
                      showSlowdowns: showSlowdowns,
                      showConstruction: showConstruction,
                      onChanged: ({
                        required showConstruction,
                        required showIncidents,
                        required showSlowdowns,
                      }) {
                          AppSettings.instance.setShowIncidents(showIncidents);
                          AppSettings.instance.setShowSlowdowns(showSlowdowns);
                          AppSettings.instance.setShowConstruction(showConstruction);
                        
                      },
                    );
                  },
                  child: const Icon(Icons.tune),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
