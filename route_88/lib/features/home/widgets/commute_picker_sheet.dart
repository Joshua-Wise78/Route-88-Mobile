import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/home/widgets/place_search_input.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/bloc/routing_event.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

/// Modal bottom sheet for custom 2-point route hazard clearance queries
/// and preset corridors.
class CommutePickerSheet extends StatefulWidget {
  const CommutePickerSheet({
    this.currentLatitude,
    this.currentLongitude,
    super.key,
  });

  static const List<
      ({
        String name,
        Coordinate start,
        Coordinate end,
        String subtitle,
      })> presets = [
    (
      name: 'Columbus ➔ Cincinnati (I-71 S)',
      start: Coordinate(lat: 39.9612, lng: -83.0019),
      end: Coordinate(lat: 39.1031, lng: -84.5120),
      subtitle: 'Via I-71 South • ~108 miles • 500m buffer',
    ),
    (
      name: 'Cincinnati ➔ Columbus (I-71 N)',
      start: Coordinate(lat: 39.1031, lng: -84.5120),
      end: Coordinate(lat: 39.9612, lng: -83.0019),
      subtitle: 'Via I-71 North • ~108 miles • 500m buffer',
    ),
    (
      name: 'Columbus ➔ Cleveland (I-71 N)',
      start: Coordinate(lat: 39.9612, lng: -83.0019),
      end: Coordinate(lat: 41.4993, lng: -81.6944),
      subtitle: 'Via I-71 North • ~142 miles • 500m buffer',
    ),
    (
      name: 'Dayton ➔ Columbus (I-70 E)',
      start: Coordinate(lat: 39.7589, lng: -84.1916),
      end: Coordinate(lat: 39.9612, lng: -83.0019),
      subtitle: 'Via I-70 East • ~72 miles • 500m buffer',
    ),
    (
      name: 'Akron ➔ Cleveland (I-77 N)',
      start: Coordinate(lat: 41.0814, lng: -81.5190),
      end: Coordinate(lat: 41.4993, lng: -81.6944),
      subtitle: 'Via I-77 North • ~39 miles • 500m buffer',
    ),
  ];

  static void show(
    BuildContext context, {
    double? currentLatitude,
    double? currentLongitude,
  }) {
    final routingBloc = context.read<RoutingBloc>();
    final routingRepository = context.read<RoutingRepository>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: MapTheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: routingRepository),
          ],
          child: BlocProvider.value(
            value: routingBloc,
            child: CommutePickerSheet(
              currentLatitude: currentLatitude,
              currentLongitude: currentLongitude,
            ),
          ),
        ),
      ),
    );
  }

  final double? currentLatitude;
  final double? currentLongitude;

  @override
  State<CommutePickerSheet> createState() => _CommutePickerSheetState();
}

class _CommutePickerSheetState extends State<CommutePickerSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  Coordinate? _startCoordinate;
  Coordinate? _endCoordinate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _useCurrentLocationAsStart() {
    if (widget.currentLatitude != null && widget.currentLongitude != null) {
      setState(() {
        _startCoordinate = Coordinate(
          lat: widget.currentLatitude!,
          lng: widget.currentLongitude!,
        );
        _startController.text = 'My Current Location';
      });
    }
  }

  void _swapLocations() {
    setState(() {
      final tempText = _startController.text;
      _startController.text = _endController.text;
      _endController.text = tempText;

      final tempCoord = _startCoordinate;
      _startCoordinate = _endCoordinate;
      _endCoordinate = tempCoord;
    });
  }

  void _submitCustomRoute() {
    final start = _startCoordinate;
    final end = _endCoordinate;
    if (start == null || end == null) return;

    Navigator.pop(context);
    context.read<RoutingBloc>().add(
          CommuteCheckRequested(
            start: start,
            end: end,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final routingRepo = context.read<RoutingRepository>();
    final canSubmit = _startCoordinate != null && _endCoordinate != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Check Route Hazards',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MapTheme.primary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MapTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '500m buffer',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MapTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Detect incidents, slowdowns, and construction within '
                '500 meters of your driving path.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: MapTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.route, size: 18),
                      text: 'Custom Route',
                    ),
                    Tab(
                      icon: Icon(Icons.alt_route, size: 18),
                      text: 'Corridors',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 380,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Custom 2-point Route Input
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'START LOCATION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (widget.currentLatitude != null &&
                                  widget.currentLongitude != null)
                                InkWell(
                                  onTap: _useCurrentLocationAsStart,
                                  borderRadius: BorderRadius.circular(8),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          size: 14,
                                          color: MapTheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Use Current Location',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: MapTheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          PlaceSearchInput(
                            routingRepository: routingRepo,
                            controller: _startController,
                            hintText: 'Search city, street, or address...',
                            prefixIcon: Icons.trip_origin,
                            iconColor: MapTheme.success,
                            onPlaceSelected: (place) {
                              setState(
                                () => _startCoordinate = place.coordinate,
                              );
                            },
                            onCleared: () {
                              setState(() => _startCoordinate = null);
                            },
                          ),
                          Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.swap_vert,
                                color: MapTheme.primary,
                              ),
                              tooltip: 'Swap start and destination',
                              onPressed: _swapLocations,
                            ),
                          ),
                          const Text(
                            'DESTINATION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          PlaceSearchInput(
                            routingRepository: routingRepo,
                            controller: _endController,
                            hintText: 'Search destination address...',
                            prefixIcon: Icons.location_on,
                            iconColor: MapTheme.incident,
                            onPlaceSelected: (place) {
                              setState(() => _endCoordinate = place.coordinate);
                            },
                            onCleared: () {
                              setState(() => _endCoordinate = null);
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canSubmit
                                    ? MapTheme.primary
                                    : Colors.grey.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: canSubmit ? 2 : 0,
                              ),
                              icon: const Icon(Icons.shield_outlined),
                              label: const Text(
                                'Check Route Hazards',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: canSubmit ? _submitCustomRoute : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              canSubmit
                                  ? 'Ready to analyze hazards along your route.'
                                  : 'Select both a start and destination '
                                      'location.',
                              style: TextStyle(
                                fontSize: 12,
                                color: canSubmit
                                    ? Colors.black54
                                    : Colors.red.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Ohio Highway Corridors Presets
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: CommutePickerSheet.presets.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final r = CommutePickerSheet.presets[index];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MapTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.alt_route,
                              color: MapTheme.primary,
                            ),
                          ),
                          title: Text(
                            r.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MapTheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            r.subtitle,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 20),
                          onTap: () {
                            Navigator.pop(context);
                            context.read<RoutingBloc>().add(
                                  CommuteCheckRequested(
                                    start: r.start,
                                    end: r.end,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
