
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/core/settings/app_settings.dart';
import 'package:route_88/core/utils/location_service.dart';
import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/home/view/incidents_page.dart';
import 'package:route_88/features/home/view/map_page.dart';
import 'package:route_88/features/home/view/settings_page.dart';
import 'package:route_88/features/route88/bloc/construction/construction_bloc.dart';
import 'package:route_88/features/route88/bloc/construction/construction_event.dart';
import 'package:route_88/features/route88/bloc/construction/construction_state.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_event.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_bloc.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_event.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_state.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double defaultLat = 39.9612;
  static const double defaultLon = -83.0019;
  
  double _lastRadius = AppSettings.instance.searchRadius;
  String _lastServer = AppSettings.instance.serverUrl;


  final LocationService _locationService = const LocationService();

  double _currentLat = defaultLat;
  double _currentLon = defaultLon;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    AppSettings.instance.addListener(_onSettingsChanged);
    _fetchTrafficData(_currentLat, _currentLon);
    unawaited(_resolveUserLocation());
  }


void _onSettingsChanged() {
  final settings = AppSettings.instance;

  if (_lastRadius != settings.searchRadius ||
      _lastServer != settings.serverUrl) {
    _lastRadius = settings.searchRadius;
    _lastServer = settings.serverUrl;

    _fetchTrafficData(_currentLat, _currentLon);
  }

  setState(() {});
}

@override
void dispose() {
  AppSettings.instance.removeListener(_onSettingsChanged);
  super.dispose();
}


  void _fetchTrafficData(double lat, double lon) {
    final searchRadius = AppSettings.instance.searchRadius;
    context.read<IncidentsBloc>().add(
      IncidentsRequested(
        latitude: lat,
        longitude: lon,
        radiusMiles: searchRadius,
      ),
    );

    context.read<ConstructionBloc>().add(
      ConstructionRequested(
        latitude: lat,
        longitude: lon,
        radiusMiles: searchRadius,
      ),
    );

    context.read<SlowdownsBloc>().add(
      SlowdownsRequested(
        latitude: lat,
        longitude: lon,
        radiusMiles: searchRadius,
      ),
    );
  }

  Future<void> _resolveUserLocation() async {
    setState(() => _isLocating = true);
    final coord = await _locationService.getCurrentLocation();
    if (coord != null && mounted) {
      setState(() {
        _currentLat = coord.lat;
        _currentLon = coord.lng;
        _isLocating = false;
      });
      _fetchTrafficData(_currentLat, _currentLon);
    } else if (mounted) {
      setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MapTheme.background,
      appBar: AppBar(
        backgroundColor: MapTheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'ROUTE 88',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFE1E6EB),
              child: MapPage(
                searchRadiusMiles: AppSettings.instance.searchRadius,
                searchCenterLatitude: _currentLat,
                searchCenterLongitude: _currentLon,
                onLocationRefreshRequested: _resolveUserLocation,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const IncidentsPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 32,
                        color: MapTheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLocating
                                  ? 'Locating your area...'
                                  : 'Traffic near you',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: MapTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            BlocBuilder<IncidentsBloc, IncidentsState>(
                              builder: (context, state) {
                                if (state is IncidentsLoading) {
                                  return const Text(
                                    'Checking incidents...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  );
                                }

                                if (state is IncidentsLoaded) {
                                  return Text(
                                    '${state.incidents.length} '
                                    'current incidents',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  );
                                }

                                if (state is IncidentsError) {
                                  return const Text(
                                    'Unable to load incidents',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  );
                                }

                                return const Text(
                                  'Loading traffic information...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            BlocBuilder<ConstructionBloc, ConstructionState>(
                              builder: (context, state) {
                                if (state is ConstructionLoaded) {
                                  return Text(
                                    '${state.construction.length} '
                                    'construction zones',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                            BlocBuilder<SlowdownsBloc, SlowdownsState>(
                              builder: (context, state) {
                                if (state is SlowdownsLoaded) {
                                  return Text(
                                    '${state.slowdowns.length} slowdowns',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: MapTheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const IncidentsPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SettingsPage(),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning_amber),
            label: 'Incidents',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
