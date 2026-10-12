
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_state.dart';

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  static const Color primaryColor = Color(0xFF123B66);
  static const Color backgroundColor = Color(0xFFF5F7FA);

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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Unable to Load Incidents',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Traffic information is temporarily unavailable. '
                      'Please try again later.',
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

            // Incident list
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.incidents.length,
              itemBuilder: (context, index) {
                final incident = state.incidents[index];

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
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
                    ),
                  ),
                );
              },
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

