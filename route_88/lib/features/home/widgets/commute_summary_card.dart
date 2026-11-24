import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/bloc/routing_event.dart';
import 'package:route_88/features/routing/models/commute_check_result.dart';

class CommuteSummaryCard extends StatelessWidget {
  const CommuteSummaryCard({
    required this.result,
    super.key,
  });

  final CommuteCheckResult result;

  Widget _buildHazardChip({
    required int count,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: count > 0 ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              count > 0 ? color.withValues(alpha: 0.3) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: count > 0 ? color : Colors.grey.shade500,
          ),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: count > 0 ? color : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isClear = result.isClear;
    final Color statusColor;
    final IconData statusIcon;
    final String statusLabel;

    if (isClear) {
      statusColor = MapTheme.success;
      statusIcon = Icons.check_circle_outline;
      statusLabel = 'All Clear';
    } else if (result.status == 'minor_delays') {
      statusColor = MapTheme.slowdown;
      statusIcon = Icons.info_outline;
      statusLabel = 'Minor Delays';
    } else {
      statusColor = MapTheme.incident;
      statusIcon = Icons.warning_amber_rounded;
      statusLabel = 'Hazards on Route';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '500m buffer',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context
                        .read<RoutingBloc>()
                        .add(const ClearCommuteRequested());
                  },
                  child:
                      const Icon(Icons.close, size: 20, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  result.route.formattedDistance,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MapTheme.primary,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: Colors.black45)),
                const SizedBox(width: 6),
                Text(
                  result.route.formattedDuration,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MapTheme.primary,
                  ),
                ),
              ],
            ),
            if (result.summary.message.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                result.summary.message,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildHazardChip(
                  count: result.summary.incidentsCount,
                  label: 'Incidents',
                  color: MapTheme.incident,
                  icon: Icons.warning_amber_rounded,
                ),
                _buildHazardChip(
                  count: result.summary.slowdownsCount,
                  label: 'Slowdowns',
                  color: MapTheme.slowdown,
                  icon: Icons.speed,
                ),
                _buildHazardChip(
                  count: result.summary.constructionCount,
                  label: 'Work Zones',
                  color: MapTheme.construction,
                  icon: Icons.construction,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
