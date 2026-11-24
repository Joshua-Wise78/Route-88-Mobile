import 'dart:async';

import 'package:flutter/material.dart';
import 'package:route_88/features/home/utils/map_theme.dart';

class MapFiltersSheet extends StatefulWidget {
  const MapFiltersSheet({
    required this.showIncidents,
    required this.showSlowdowns,
    required this.showConstruction,
    required this.onChanged,
    super.key,
  });

  final bool showIncidents;
  final bool showSlowdowns;
  final bool showConstruction;
  final void Function({
    required bool showIncidents,
    required bool showSlowdowns,
    required bool showConstruction,
  }) onChanged;

  static void show(
    BuildContext context, {
    required bool showIncidents,
    required bool showSlowdowns,
    required bool showConstruction,
    required void Function({
      required bool showIncidents,
      required bool showSlowdowns,
      required bool showConstruction,
    }) onChanged,
  }) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        backgroundColor: MapTheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => MapFiltersSheet(
          showIncidents: showIncidents,
          showSlowdowns: showSlowdowns,
          showConstruction: showConstruction,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  State<MapFiltersSheet> createState() => _MapFiltersSheetState();
}

class _MapFiltersSheetState extends State<MapFiltersSheet> {
  late bool _showIncidents;
  late bool _showSlowdowns;
  late bool _showConstruction;

  @override
  void initState() {
    super.initState();
    _showIncidents = widget.showIncidents;
    _showSlowdowns = widget.showSlowdowns;
    _showConstruction = widget.showConstruction;
  }

  void _notify() {
    widget.onChanged(
      showIncidents: _showIncidents,
      showSlowdowns: _showSlowdowns,
      showConstruction: _showConstruction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Filters',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MapTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose which traffic events appear on your map.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Incidents'),
              secondary: const Icon(
                Icons.warning_amber_rounded,
                color: MapTheme.incident,
              ),
              activeThumbColor: MapTheme.primary,
              value: _showIncidents,
              onChanged: (val) {
                setState(() => _showIncidents = val);
                _notify();
              },
            ),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Slowdowns'),
              secondary: const Icon(
                Icons.speed,
                color: MapTheme.slowdown,
              ),
              activeThumbColor: MapTheme.primary,
              value: _showSlowdowns,
              onChanged: (val) {
                setState(() => _showSlowdowns = val);
                _notify();
              },
            ),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Construction'),
              secondary: const Icon(
                Icons.construction,
                color: MapTheme.construction,
              ),
              activeThumbColor: MapTheme.primary,
              value: _showConstruction,
              onChanged: (val) {
                setState(() => _showConstruction = val);
                _notify();
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showIncidents = true;
                    _showSlowdowns = true;
                    _showConstruction = true;
                  });
                  _notify();
                },
                child: const Text('Reset Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
