
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferences belong to this device, not to the Route-88 server.
class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  static const defaultServerUrl =
      'https://wise-server.tail904182.ts.net:8443';

  SharedPreferences? _preferences;
  bool showIncidents = true;
  bool showConstruction = true;
  bool showSlowdowns = true;
  double searchRadius = 50;
  String serverUrl = defaultServerUrl;

  /// Load preferences before any API requests are made.
  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    final prefs = _preferences!;

    showIncidents = prefs.getBool('showIncidents') ?? true;
    showConstruction = prefs.getBool('showConstruction') ?? true;
    showSlowdowns = prefs.getBool('showSlowdowns') ?? true;

    final savedRadius = prefs.getDouble('searchRadius') ?? 50;
    searchRadius = savedRadius.clamp(10.0, 100.0).toDouble();

    final savedServer = prefs.getString('serverUrl');
    if (savedServer != null) {
      try {
        serverUrl = normalizeServerUrl(savedServer);
      } on FormatException {
        serverUrl = defaultServerUrl;
      }
    }

    notifyListeners();
  }

  static String normalizeServerUrl(String input) {
    var value = input.trim().replaceAll(RegExp(r'/+$'), '');

    if (value.endsWith('/api/mobile')) {
      value = value.substring(
        0,
        value.length - '/api/mobile'.length,
      );
    }

    final uri = Uri.tryParse(value);

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const FormatException(
        'Enter a valid http:// or https:// server URL',
      );
    }

    return value;
  }

  String get mobileApiUrl => '$serverUrl/api/mobile';

  Future<void> setServerUrl(String value) async {
    final normalized = normalizeServerUrl(value);

    if (serverUrl == normalized) return;

    await _preferences?.setString('serverUrl', normalized);
    serverUrl = normalized;
    notifyListeners();
  }

  Future<void> setSearchRadius(double value) async {
    final radius = value.clamp(10.0, 100.0).toDouble();

    if (searchRadius == radius) return;

    searchRadius = radius;
    notifyListeners();
    await _preferences?.setDouble('searchRadius', radius);
  }

  Future<void> setShowIncidents(bool value) async {
    showIncidents = value;
    notifyListeners();
    await _preferences?.setBool('showIncidents', value);
  }

  Future<void> setShowConstruction(bool value) async {
    showConstruction = value;
    notifyListeners();
    await _preferences?.setBool('showConstruction', value);
  }

  Future<void> setShowSlowdowns(bool value) async {
    showSlowdowns = value;
    notifyListeners();
    await _preferences?.setBool('showSlowdowns', value);
  }
}
