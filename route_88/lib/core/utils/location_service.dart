import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:route_88/features/routing/models/coordinate.dart';

/// Helper service for resolving device GPS coordinates.
class LocationService {
  const LocationService();

  static const Coordinate defaultColumbus = Coordinate(
    lat: 39.9612,
    lng: -83.0019,
  );

  /// Requests permission and fetches the current device location.
  /// Returns `null` if location services are disabled, permissions are denied,
  /// or if resolution times out.
  Future<Coordinate?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );

        return Coordinate(
          lat: position.latitude,
          lng: position.longitude,
        );
      } on Exception catch (_) {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          return Coordinate(
            lat: lastKnown.latitude,
            lng: lastKnown.longitude,
          );
        }
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }
}
