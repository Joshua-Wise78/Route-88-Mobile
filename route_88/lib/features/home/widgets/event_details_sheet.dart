import 'dart:async';

import 'package:flutter/material.dart';
import 'package:route_88/features/home/utils/map_theme.dart';

class EventDetailsSheet extends StatelessWidget {
  const EventDetailsSheet({
    required this.title,
    required this.description,
    required this.eventColor,
    required this.eventIcon,
    super.key,
    this.location,
    this.direction,
    this.status,
    this.startDate,
    this.endDate,
    this.extraInfo,
  });

  final String title;
  final String description;
  final Color eventColor;
  final IconData eventIcon;
  final String? location;
  final String? direction;
  final String? status;
  final String? startDate;
  final String? endDate;
  final String? extraInfo;

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required Color eventColor,
    required IconData eventIcon,
    String? location,
    String? direction,
    String? status,
    String? startDate,
    String? endDate,
    String? extraInfo,
  }) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: MapTheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => EventDetailsSheet(
          title: title,
          description: description,
          eventColor: eventColor,
          eventIcon: eventIcon,
          location: location,
          direction: direction,
          status: status,
          startDate: startDate,
          endDate: endDate,
          extraInfo: extraInfo,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: MapTheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: MapTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(eventIcon, color: eventColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MapTheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              if (location != null ||
                  direction != null ||
                  status != null ||
                  startDate != null ||
                  endDate != null ||
                  extraInfo != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
              ],
              if (extraInfo != null)
                _buildDetailRow(
                  icon: Icons.timeline,
                  label: 'Commute Impact',
                  value: extraInfo!,
                ),
              if (location != null)
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: location!,
                ),
              if (direction != null)
                _buildDetailRow(
                  icon: Icons.signpost_outlined,
                  label: 'Direction',
                  value: direction!,
                ),
              if (status != null && status!.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.info_outline,
                  label: 'Status',
                  value: status!,
                ),
              if (startDate != null && startDate!.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.event,
                  label: 'Start Date',
                  value: startDate!,
                ),
              if (endDate != null && endDate!.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.event_available,
                  label: 'End Date',
                  value: endDate!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
