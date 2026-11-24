import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/home/widgets/event_details_sheet.dart';
import 'package:route_88/features/route88/models/construction.dart';
import 'package:route_88/features/route88/models/incident.dart';
import 'package:route_88/features/route88/models/slowdowns.dart';
import 'package:route_88/features/routing/models/route_hazard.dart';

abstract final class MapMarkerBuilder {
  static bool hasValidCoordinates(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        !(latitude == 0 && longitude == 0);
  }

  static Marker buildEventMarker(
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
    String? extraInfo,
  }) {
    return Marker(
      point: point,
      width: 48,
      height: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          EventDetailsSheet.show(
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
            extraInfo: extraInfo,
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

  static Marker? fromIncident(BuildContext context, Incident incident) {
    if (!hasValidCoordinates(incident.latitude, incident.longitude)) {
      return null;
    }
    return buildEventMarker(
      context,
      point: LatLng(incident.latitude, incident.longitude),
      title: incident.routeName ?? incident.category ?? 'Traffic Incident',
      description: incident.description ?? 'No description available.',
      markerColor: MapTheme.incident,
      eventIcon: Icons.warning_amber_rounded,
      location: incident.location,
      direction: incident.direction,
    );
  }

  static Marker? fromSlowdown(BuildContext context, Slowdown slowdown) {
    if (!hasValidCoordinates(slowdown.latitude, slowdown.longitude)) {
      return null;
    }
    return buildEventMarker(
      context,
      point: LatLng(slowdown.latitude, slowdown.longitude),
      title: slowdown.category ?? 'Traffic Slowdown',
      description: slowdown.description ?? 'Expect delays.',
      markerColor: MapTheme.slowdown,
      eventIcon: Icons.speed,
      location: slowdown.location,
      direction: slowdown.direction,
    );
  }

  static Marker? fromConstruction(
    BuildContext context,
    Construction construction,
  ) {
    if (!hasValidCoordinates(
      construction.latitude,
      construction.longitude,
    )) {
      return null;
    }
    return buildEventMarker(
      context,
      point: LatLng(construction.latitude, construction.longitude),
      title: construction.routeName ?? 'Road Construction',
      description: construction.description ??
          construction.workZone?.description ??
          'No description available.',
      markerColor: MapTheme.construction,
      eventIcon: Icons.construction,
      location: construction.location,
      direction: construction.direction,
      status: construction.status,
      startDate: construction.startDate,
      endDate: construction.endDate,
    );
  }

  static Marker? fromRouteHazard(BuildContext context, RouteHazard hazard) {
    if (!hasValidCoordinates(hazard.latitude, hazard.longitude)) {
      return null;
    }

    final Color color;
    final IconData icon;

    if (hazard.isIncident) {
      color = MapTheme.incident;
      icon = Icons.warning_amber_rounded;
    } else if (hazard.isSlowdown) {
      color = MapTheme.slowdown;
      icon = Icons.speed;
    } else {
      color = MapTheme.construction;
      icon = Icons.construction;
    }

    final dist = hazard.distanceFromRouteMiles.toStringAsFixed(2);
    final marker = hazard.mileMarkerOnRoute.toStringAsFixed(1);
    final status = hazard.isRoadClosed
        ? 'Road Closed'
        : 'Severity: ${hazard.severity.toUpperCase()}';

    return buildEventMarker(
      context,
      point: LatLng(hazard.latitude, hazard.longitude),
      title: hazard.title,
      description: hazard.description,
      markerColor: color,
      eventIcon: icon,
      location: hazard.location,
      direction: hazard.direction,
      status: status,
      extraInfo: 'Mile $marker • $dist mi off route',
    );
  }

  static Marker userLocation(LatLng point) {
    return Marker(
      point: point,
      width: 22,
      height: 22,
      child: Container(
        decoration: BoxDecoration(
          color: MapTheme.route,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  static Marker routeEndpoint({
    required LatLng point,
    required bool isStart,
  }) {
    return Marker(
      point: point,
      width: 36,
      height: 36,
      child: Icon(
        isStart ? Icons.play_circle_fill : Icons.flag_circle,
        color: isStart ? MapTheme.success : MapTheme.incident,
        size: 32,
      ),
    );
  }
}
