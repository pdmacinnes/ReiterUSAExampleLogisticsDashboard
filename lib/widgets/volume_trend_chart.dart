import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class VolumeTrendChart extends StatelessWidget {
  const VolumeTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final volumes = context.watch<DashboardProvider>().dailyVolumes;
    if (volumes.isEmpty) return const SizedBox();

    final maxGallons =
        volumes.map((v) => v.gallons).reduce((a, b) => a > b ? a : b);
    final totalMtd =
        volumes.fold<int>(0, (sum, v) => sum + v.gallons);

    return DashboardCard(
      title: '28-Day Collection Volume',
      trailing: Text(
        'MTD: ${NumberFormat('#,###').format(totalMtd)} gal',
        style: AppTheme.labelMedium.copyWith(
          color: AppTheme.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (maxGallons * 1.18).toDouble(),
            barGroups: List.generate(volumes.length, (i) {
              final v = volumes[i];
              final isToday = i == volumes.length - 1;
              final isWeekend =
                  v.date.weekday == DateTime.saturday ||
                  v.date.weekday == DateTime.sunday;
              final color = isToday
                  ? AppTheme.accent
                  : isWeekend
                      ? AppTheme.info.withOpacity(0.35)
                      : AppTheme.info.withOpacity(0.65);
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: v.gallons.toDouble(),
                    color: color,
                    width: 9,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              );
            }),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= volumes.length) {
                      return const SizedBox();
                    }
                    final isToday = idx == volumes.length - 1;
                    final showLabel = idx % 7 == 0 || isToday;
                    if (!showLabel) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        isToday
                            ? 'Today'
                            : DateFormat('M/d').format(volumes[idx].date),
                        style: TextStyle(
                          color: isToday
                              ? AppTheme.accent
                              : AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: 500,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    return Text(
                      '${(value / 1000).toStringAsFixed(1)}k',
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 500,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppTheme.divider,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => AppTheme.surfaceElevated,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final v = volumes[groupIndex];
                  return BarTooltipItem(
                    '${DateFormat('MMM d').format(v.date)}\n',
                    AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                    children: [
                      TextSpan(
                        text: '${NumberFormat('#,###').format(v.gallons)} gal',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
