import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/route_model.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class RouteStatusCards extends StatelessWidget {
  const RouteStatusCards({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<DashboardProvider>().routes;

    return DashboardCard(
      title: 'Route Status',
      padding: EdgeInsets.zero,
      trailing: _Legend(),
      child: SizedBox(
        height: 430,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: routes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) => _RouteCard(route: routes[i]),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: DriverStatus.values.map((s) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: s.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(s.label, style: AppTheme.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final RouteModel route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final progress = route.progress;
    final progressPct = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  route.name,
                  style: AppTheme.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(status: route.driverStatus),
            ],
          ),
          const SizedBox(height: 4),
          Text(route.driverName, style: AppTheme.bodySmall),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(
                label: 'Stops',
                value: '${route.completedStops}/${route.totalStops}',
              ),
              _Stat(
                label: 'Collected',
                value:
                    '${route.gallonsCollected.toStringAsFixed(0)} gal',
              ),
              _Stat(
                label: 'Progress',
                value: '$progressPct%',
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                route.driverStatus == DriverStatus.offDuty
                    ? AppTheme.textSecondary
                    : route.driverStatus.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DriverStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: status.color.withOpacity(0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.kpiLabel.copyWith(fontSize: 10)),
        Text(value,
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
