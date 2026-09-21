import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // Temporary Columbus, OH coordinates for testing.
  // These will eventually be replaced with the user's current location.
  static const double testLat = 39.9612;
  static const double testLon = -83.0019;
  static const double testRadius = 50;

  @override
  void initState() {
    super.initState();

    context.read<IncidentsBloc>().add(
      const IncidentsRequested(
        latitude: testLat,
        longitude: testLon,
        radiusMiles: testRadius,
      ),
    );

    context.read<ConstructionBloc>().add(
      const ConstructionRequested(
        latitude: testLat,
        longitude: testLon,
        radiusMiles: testRadius,
      ),
    );

    context.read<SlowdownsBloc>().add(
      const SlowdownsRequested(
        latitude: testLat,
        longitude: testLon,
        radiusMiles: testRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B66),
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
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 80,
                      color: Color(0xFF123B66),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Map Coming Soon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF123B66),
                      ),
                    ),
                  ],
                ),
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
                  // Navigation to the incidents page will be added later.
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
                        color: Color(0xFF123B66),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Traffic near you',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF123B66),
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
                        color: Color(0xFF123B66),
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
          // Navigation will be added later.
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

