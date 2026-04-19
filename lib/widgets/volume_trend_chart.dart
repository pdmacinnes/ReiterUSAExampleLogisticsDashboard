import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';
import 'chart_type_selector.dart';

enum VolumeChartType { bar, line }

class VolumeTrendChart extends StatefulWidget {
  const VolumeTrendChart({super.key});

  @override
  State<VolumeTrendChart> createState() => _VolumeTrendChartState();
}

class _VolumeTrendChartState extends State<VolumeTrendChart> {
  VolumeChartType _chartType = VolumeChartType.bar;

  @override
  Widget build(BuildContext context) {
    final volumes = context.watch<DashboardProvider>().dailyVolumes;
    if (volumes.isEmpty) return const SizedBox();

    final maxGallons =
        volumes.map((v) => v.gallons).reduce((a, b) => a > b ? a : b);
    final totalMtd = volumes.fold<int>(0, (sum, v) => sum + v.gallons);

    return DashboardCard(
      title: '28-Day Collection Volume',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MTD: ${NumberFormat('#,###').format(totalMtd)} gal',
            style: AppTheme.labelMedium.copyWith(
              color: AppTheme.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          ChartTypeSelector<VolumeChartType>(
            options: const [
              (VolumeChartType.bar, 'Bar', Icons.bar_chart_rounded),
              (VolumeChartType.line, 'Line', Icons.show_chart_rounded),
            ],
            selected: _chartType,
            onSelect: (t) => setState(() => _chartType = t),
          ),
        ],
      ),
      child: SizedBox(
        height: 220,
        child: _chartType == VolumeChartType.bar
            ? _BarView(volumes: volumes, maxGallons: maxGallons)
            : _LineView(volumes: volumes, maxGallons: maxGallons),
      ),
    );
  }
}

class _BarView extends StatelessWidget {
  final List volumes;
  final int maxGallons;

  const _BarView({required this.volumes, required this.maxGallons});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxGallons * 1.18).toDouble(),
        barGroups: List.generate(volumes.length, (i) {
          final v = volumes[i];
          final isToday = i == volumes.length - 1;
          final isWeekend = v.date.weekday == DateTime.saturday ||
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(3)),
              ),
            ],
          );
        }),
        titlesData: _titlesData(volumes),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        barTouchData: _barTooltip(volumes),
      ),
    );
  }
}

class _LineView extends StatelessWidget {
  final List volumes;
  final int maxGallons;

  const _LineView({required this.volumes, required this.maxGallons});

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      volumes.length,
      (i) => FlSpot(i.toDouble(), volumes[i].gallons.toDouble()),
    );

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: (maxGallons * 1.18).toDouble(),
        gridData: _gridData(),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(volumes),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppTheme.accent,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, i) {
                final isToday = i == volumes.length - 1;
                return FlDotCirclePainter(
                  radius: isToday ? 5 : 0,
                  color: AppTheme.accent,
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.accent.withOpacity(0.18),
                  AppTheme.accent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppTheme.surfaceElevated,
            getTooltipItems: (spots) => spots.map((s) {
              final v = volumes[s.spotIndex];
              return LineTooltipItem(
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
            }).toList(),
          ),
        ),
      ),
    );
  }
}

FlTitlesData _titlesData(List volumes) => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 26,
          getTitlesWidget: (value, meta) {
            final idx = value.toInt();
            if (idx < 0 || idx >= volumes.length) return const SizedBox();
            final isToday = idx == volumes.length - 1;
            final showLabel = idx % 7 == 0 || isToday;
            if (!showLabel) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                isToday ? 'Today' : DateFormat('M/d').format(volumes[idx].date),
                style: TextStyle(
                  color: isToday ? AppTheme.accent : AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight:
                      isToday ? FontWeight.w700 : FontWeight.w400,
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
      topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

FlGridData _gridData() => FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 500,
      getDrawingHorizontalLine: (_) =>
          FlLine(color: AppTheme.divider, strokeWidth: 1),
    );

BarTouchData _barTooltip(List volumes) => BarTouchData(
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
    );
