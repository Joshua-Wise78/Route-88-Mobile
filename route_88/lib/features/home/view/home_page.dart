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
import 'package:route_88/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Hardcoded Columbus, OH coordinates for testing data fetching
    const testLat = 39.9612;
    const testLon = -83.0019;
    const testRadius = 50.0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeAppBarTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Traffic Data Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the buttons to fetch data for Columbus, OH',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Incidents Section
            ElevatedButton(
              onPressed: () => context.read<IncidentsBloc>().add(
                const IncidentsRequested(
                  latitude: testLat,
                  longitude: testLon,
                  radiusMiles: testRadius,
                ),
              ),
              child: const Text('Fetch Incidents'),
            ),
            BlocBuilder<IncidentsBloc, IncidentsState>(
              builder: (context, state) {
                if (state is IncidentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IncidentsLoaded) {
                  return Text('Loaded ${state.incidents.length} Incidents');
                } else if (state is IncidentsError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('No data fetched yet.');
              },
            ),
            const Divider(height: 48),

            // Construction Section
            ElevatedButton(
              onPressed: () => context.read<ConstructionBloc>().add(
                const ConstructionRequested(
                  latitude: testLat,
                  longitude: testLon,
                  radiusMiles: testRadius,
                ),
              ),
              child: const Text('Fetch Construction'),
            ),
            BlocBuilder<ConstructionBloc, ConstructionState>(
              builder: (context, state) {
                if (state is ConstructionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConstructionLoaded) {
                  return Text(
                    'Loaded ${state.construction.length} Construction Zones',
                  );
                } else if (state is ConstructionError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('No data fetched yet.');
              },
            ),
            const Divider(height: 48),

            // Slowdowns Section
            ElevatedButton(
              onPressed: () => context.read<SlowdownsBloc>().add(
                const SlowdownsRequested(
                  latitude: testLat,
                  longitude: testLon,
                  radiusMiles: testRadius,
                ),
              ),
              child: const Text('Fetch Slowdowns'),
            ),
            BlocBuilder<SlowdownsBloc, SlowdownsState>(
              builder: (context, state) {
                if (state is SlowdownsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SlowdownsLoaded) {
                  return Text('Loaded ${state.slowdowns.length} Slowdowns');
                } else if (state is SlowdownsError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('No data fetched yet.');
              },
            ),
          ],
        ),
      ),
    );
  }
}
