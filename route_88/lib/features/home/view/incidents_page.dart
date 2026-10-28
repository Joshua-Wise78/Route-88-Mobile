import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/features/home/view/map_page.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_event.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  static const Color primaryColor = Color(0xFF123B66);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  // Temporary Columbus coordinates, matching HomePage.
  static const double testLat = 39.9612;
  static const double testLon = -83.0019;
  static const double testRadius = 50;

  // Verify that coordinates are usable before opening the map.
  bool _hasValidCoordinates(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        !(latitude == 0 && longitude == 0);
  }

  // Open a map centered on the selected incident.
  void _viewIncidentOnMap(
    BuildContext context, {
    required double latitude,
    required double longitude,
    String? routeName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              routeName ?? 'Incident Location',
            ),
          ),
          body: MapPage(
            latitude: latitude,
            longitude: longitude,
            showIncidentMarker: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'TRAFFIC NEAR YOU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: BlocBuilder<IncidentsBloc, IncidentsState>(
        builder: (context, state) {
          // Loading state
          if (state is IncidentsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          // Error state
          if (state is IncidentsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to Load Incidents',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Traffic information is temporarily unavailable. '
                      'Please try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<IncidentsBloc>().add(
                          const IncidentsRequested(
                            latitude: testLat,
                            longitude: testLon,
                            radiusMiles: testRadius,
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Successfully loaded incidents
          if (state is IncidentsLoaded) {
            // No incidents available
            if (state.incidents.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Incidents Found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'There are currently no reported '
                        'incidents in this area.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Expandable incident list
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false,
              ),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.incidents.length,
                itemBuilder: (context, index) {
                  final incident = state.incidents[index];

                  final hasValidLocation = _hasValidCoordinates(
                    incident.latitude,
                    incident.longitude,
                  );

                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ExpansionTile(
                      key: PageStorageKey(
                        '${incident.id}-$index',
                      ),
                      leading: const Icon(
                        Icons.warning_amber_rounded,
                        color: primaryColor,
                        size: 32,
                      ),
                      title: Text(
                        incident.routeName ??
                            incident.category ??
                            'Traffic Incident',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          incident.description ??
                              incident.location ??
                              'No description available',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      iconColor: primaryColor,
                      collapsedIconColor: primaryColor,
                      childrenPadding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),

                        // Incident category
                        if (incident.category != null)
                          ListTile(
                            leading: const Icon(
                              Icons.info_outline,
                              color: primaryColor,
                            ),
                            title: const Text('Incident Type'),
                            subtitle: Text(incident.category!),
                          ),

                        // Incident location
                        if (incident.location != null)
                          ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: primaryColor,
                            ),
                            title: const Text('Location'),
                            subtitle: Text(incident.location!),
                          ),

                        // Travel direction
                        if (incident.direction != null)
                          ListTile(
                            leading: const Icon(
                              Icons.signpost_outlined,
                              color: primaryColor,
                            ),
                            title: const Text('Direction'),
                            subtitle: Text(incident.direction!),
                          ),

                        // Road status
                        if (incident.roadStatus != null)
                          ListTile(
                            leading: const Icon(
                              Icons.block_outlined,
                              color: primaryColor,
                            ),
                            title: const Text('Road Status'),
                            subtitle: Text(incident.roadStatus!),
                          ),

                        const SizedBox(height: 12),

                        // View selected incident on the map
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: hasValidLocation
                                ? () {
                                    _viewIncidentOnMap(
                                      context,
                                      latitude: incident.latitude,
                                      longitude: incident.longitude,
                                      routeName: incident.routeName,
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('View on Map'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        // Explain why map navigation is unavailable.
                        if (!hasValidLocation)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Location coordinates are unavailable '
                              'for this incident.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          // Initial state
          return const Center(
            child: Text(
              'Waiting for traffic information...',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          );
        },
      ),
    );
  }
}
