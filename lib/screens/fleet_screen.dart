import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/route_model.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/map_widget.dart';

class FleetScreen extends StatelessWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<DashboardProvider>().routes;
    final active = routes.where((r) => r.driverStatus != DriverStatus.offDuty).length;
    final onRoute = routes.where((r) => r.driverStatus == DriverStatus.onRoute).length;
    final onBreak = routes.where((r) => r.driverStatus == DriverStatus.onBreak).length;
    final returning = routes.where((r) => r.driverStatus == DriverStatus.returning).length;
    final offDuty = routes.where((r) => r.driverStatus == DriverStatus.offDuty).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FleetStatusBar(
            active: active,
            onRoute: onRoute,
            onBreak: onBreak,
            returning: returning,
            offDuty: offDuty,
            total: routes.length,
          ),
          const SizedBox(height: 16),
          const MapWidget(),
          const SizedBox(height: 16),
          DashboardCard(
            title: 'Driver Status — All Routes',
            trailing: Text(
              '$active / ${routes.length} active',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 900
                    ? 3
                    : constraints.maxWidth >= 600
                        ? 2
                        : 1;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: routes.map((r) {
                    final cardWidth =
                        (constraints.maxWidth - (cols - 1) * 12) / cols;
                    return SizedBox(
                      width: cardWidth,
                      child: _DriverCard(route: r),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FleetStatusBar extends StatelessWidget {
  final int active, onRoute, onBreak, returning, offDuty, total;

  const _FleetStatusBar({
    required this.active,
    required this.onRoute,
    required this.onBreak,
    required this.returning,
    required this.offDuty,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FStat('TOTAL DRIVERS', '$total', Icons.people_rounded, AppTheme.textSecondary),
        const SizedBox(width: 12),
        _FStat('ON ROUTE', '$onRoute', Icons.local_shipping_rounded, DriverStatus.onRoute.color),
        const SizedBox(width: 12),
        _FStat('ON BREAK', '$onBreak', Icons.coffee_rounded, DriverStatus.onBreak.color),
        const SizedBox(width: 12),
        _FStat('RETURNING', '$returning', Icons.keyboard_return_rounded, DriverStatus.returning.color),
        const SizedBox(width: 12),
        _FStat('OFF DUTY', '$offDuty', Icons.do_not_disturb_rounded, DriverStatus.offDuty.color),
      ],
    );
  }
}

class _FStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _FStat(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTheme.kpiLabel.copyWith(
                        fontSize: 10, letterSpacing: 0.5)),
                Text(value,
                    style: AppTheme.kpiValue.copyWith(fontSize: 26)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final RouteModel route;

  const _DriverCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final progress = route.progress;
    final progressPct = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: route.driverStatus == DriverStatus.offDuty
              ? AppTheme.divider
              : route.driverStatus.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: route.driverStatus.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    route.driverName.split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(
                      color: route.driverStatus.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.driverName,
                      style: AppTheme.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      route.name.split('—').last.trim(),
                      style: AppTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _StatusChip(status: route.driverStatus),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DStat('Stops', '${route.completedStops}/${route.totalStops}'),
              _DStat(
                  'Gallons',
                  route.gallonsCollected > 0
                      ? '${route.gallonsCollected.toStringAsFixed(0)} gal'
                      : '—'),
              _DStat('Progress', '$progressPct%'),
              _DStat(
                'Efficiency',
                route.completedStops > 0
                    ? '${(route.gallonsCollected / route.completedStops).toStringAsFixed(1)} gal/stop'
                    : '—',
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            color: status.color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DStat extends StatelessWidget {
  final String label;
  final String value;

  const _DStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTheme.kpiLabel.copyWith(fontSize: 10)),
        Text(value,
            style:
                AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
