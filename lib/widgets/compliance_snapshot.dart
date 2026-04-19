import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class ComplianceSnapshot extends StatelessWidget {
  const ComplianceSnapshot({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final progress = p.lcfsSubmitted / p.lcfsRequired;
    final totalGal = p.totalGallonsTrackedMtd;
    final totalLbs = totalGal * 7.5;
    final carbonCredits = totalLbs * 0.00000985;

    return DashboardCard(
      title: 'LCFS Compliance — April 2026',
      trailing: _ComplianceScore(progress: progress),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${p.lcfsSubmitted} / ${p.lcfsRequired} records submitted',
                      style: AppTheme.bodyMedium,
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: AppTheme.bodyMedium.copyWith(
                        color: _progressColor(progress),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: AppTheme.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _progressColor(progress),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${p.lcfsRequired - p.lcfsSubmitted} records pending submission before month-end',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          _MiniStat(
            label: 'TOTAL VOL. TRACKED',
            value: '${NumberFormat('#,###').format(totalGal.toInt())} gal',
            icon: Icons.water_drop_outlined,
            color: AppTheme.info,
          ),
          const SizedBox(width: 16),
          _MiniStat(
            label: 'EST. CARBON CREDITS',
            value: '${carbonCredits.toStringAsFixed(1)} MT CO₂e',
            icon: Icons.eco_outlined,
            color: AppTheme.success,
          ),
          const SizedBox(width: 16),
          _MiniStat(
            label: 'COMPLIANCE SCORE',
            value: '${(progress * 100).toStringAsFixed(0)}%',
            icon: Icons.verified_outlined,
            color: _progressColor(progress),
          ),
        ],
      ),
    );
  }

  Color _progressColor(double progress) {
    if (progress >= 0.90) return AppTheme.success;
    if (progress >= 0.70) return AppTheme.warning;
    return AppTheme.error;
  }
}

class _ComplianceScore extends StatelessWidget {
  final double progress;

  const _ComplianceScore({required this.progress});

  @override
  Widget build(BuildContext context) {
    final color = progress >= 0.90
        ? AppTheme.success
        : progress >= 0.70
            ? AppTheme.warning
            : AppTheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            progress >= 0.90 ? 'Compliant' : 'Action Required',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(label, style: AppTheme.kpiLabel.copyWith(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
