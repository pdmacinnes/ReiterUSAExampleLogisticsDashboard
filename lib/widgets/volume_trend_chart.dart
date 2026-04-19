import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import '../utils/forecast.dart';
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
  int _days = 28;

  @override
  Widget build(BuildContext context) {
    final allVolumes = context.watch<DashboardProvider>().dailyVolumes;
    if (allVolumes.isEmpty) return const SizedBox();

    final volumes = allVolumes.length > _days
        ? allVolumes.sublist(allVolumes.length - _days)
        : allVolumes;

    final maxGallons =
        volumes.map((v) => v.gallons).reduce((a, b) => a > b ? a : b);
    final totalMtd = allVolumes.fold<int>(0, (sum, v) => sum + v.gallons);

    final forecastSpots = _chartType == VolumeChartType.line
        ? _remapForecast(
            computeForecast(allVolumes), allVolumes.length, volumes.length)
        : <FlSpot>[];

    return DashboardCard(
      title: '${_days}-Day Collection Volume',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...[7, 14, 28, 56].map((d) => _RangePill(
                days: d,
                selected: _days == d,
                onTap: () => setState(() => _days = d),
              )),
          const SizedBox(width: 8),
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
            : _LineView(
                volumes: volumes,
                maxGallons: maxGallons,
                forecastSpots: forecastSpots,
              ),
      ),
    );
  }

  List<FlSpot> _remapForecast(
      List<FlSpot> raw, int totalLen, int displayLen) {
    final offset = totalLen - displayLen;
    return raw.map((s) => FlSpot(s.x - offset, s.y)).toList();
  }
}

class _RangePill extends StatelessWidget {
  final int days;
  final bool selected;
  final VoidCallback onTap;

  const _RangePill(
      {required this.days, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withOpacity(0.2)
              : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.divider,
          ),
        ),
        child: Text(
          '${days}d',
          style: TextStyle(
            color: selected ? AppTheme.accent : AppTheme.textSecondary,
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
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
                width: volumes.length <= 14 ? 14 : volumes.length <= 28 ? 9 : 5,
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
  final List<FlSpot> forecastSpots;

  const _LineView({
    required this.volumes,
    required this.maxGallons,
    required this.forecastSpots,
  });

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      volumes.length,
      (i) => FlSpot(i.toDouble(), volumes[i].gallons.toDouble()),
    );

    final allY = [...spots.map((s) => s.y), ...forecastSpots.map((s) => s.y)];
    final maxY = allY.isEmpty ? maxGallons * 1.18 : allY.reduce((a, b) => a > b ? a : b) * 1.18;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
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
          if (forecastSpots.isNotEmpty)
            LineChartBarData(
              spots: [spots.last, ...forecastSpots],
              isCurved: false,
              color: AppTheme.accent.withOpacity(0.55),
              barWidth: 1.5,
              dashArray: [5, 4],
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: AppTheme.accent.withOpacity(0.55),
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                ),
              ),
              belowBarData: BarAreaData(show: false),
            ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppTheme.surfaceElevated,
            getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
              if (s.barIndex == 1) {
                return LineTooltipItem(
                  'Forecast\n',
                  AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                  children: [
                    TextSpan(
                      text: '${NumberFormat('#,###').format(s.y.toInt())} gal',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.accent.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }
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
            final interval = volumes.length <= 14 ? 3 : volumes.length <= 28 ? 7 : 14;
            final showLabel = idx % interval == 0 || isToday;
            if (!showLabel) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                isToday ? 'Today' : DateFormat('M/d').format(volumes[idx].date),
                style: TextStyle(
                  color: isToday ? AppTheme.accent : AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
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
