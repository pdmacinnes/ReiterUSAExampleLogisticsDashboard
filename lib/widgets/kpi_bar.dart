import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';

class KpiBar extends StatelessWidget {
  const KpiBar({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final gallons = p.totalGallonsToday;
    final openLbs = p.openTradeVolumeLbs;

    return Row(
      children: [
        _KpiCard(
          label: 'GALLONS COLLECTED TODAY',
          value: '${gallons.toStringAsFixed(0)}',
          unit: 'gal',
          icon: Icons.local_gas_station_rounded,
          accentColor: AppTheme.accent,
        ),
        const SizedBox(width: 12),
        _KpiCard(
          label: 'PICKUPS COMPLETED',
          value: '${p.completedPickups}',
          unit: '/ ${p.totalPickups}',
          icon: Icons.check_circle_outline_rounded,
          accentColor: AppTheme.success,
        ),
        const SizedBox(width: 12),
        _KpiCard(
          label: 'ACTIVE DRIVERS',
          value: '${p.activeDrivers}',
          unit: '/ ${p.routes.length}',
          icon: Icons.local_shipping_rounded,
          accentColor: AppTheme.info,
        ),
        const SizedBox(width: 12),
        _KpiCard(
          label: 'OPEN TRADE VOLUME',
          value: '${(openLbs / 1000).toStringAsFixed(0)}k',
          unit: 'lbs',
          icon: Icons.swap_horiz_rounded,
          accentColor: AppTheme.warning,
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.kpiLabel),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(value, style: AppTheme.kpiValue),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: AppTheme.bodySmall.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
