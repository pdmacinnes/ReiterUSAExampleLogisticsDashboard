import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/alert_model.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class AlertsPanel extends StatelessWidget {
  const AlertsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<DashboardProvider>().alerts;

    return DashboardCard(
      title: 'Active Alerts',
      trailing: alerts.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.error.withOpacity(0.4)),
              ),
              child: Text(
                '${alerts.length}',
                style: TextStyle(
                    color: AppTheme.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
      child: alerts.isEmpty
          ? _EmptyState()
          : Column(
              children: alerts
                  .map((a) => _AlertRow(alert: a))
                  .toList(),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: AppTheme.success, size: 18),
          const SizedBox(width: 8),
          Text('All systems normal — no active alerts',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.success)),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final AlertItem alert;

  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.type.color;
    final timeStr = DateFormat('h:mm a').format(alert.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Icon(alert.type.icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(alert.detail,
                      style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              timeStr,
              style: AppTheme.bodySmall.copyWith(
                  fontSize: 10, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
