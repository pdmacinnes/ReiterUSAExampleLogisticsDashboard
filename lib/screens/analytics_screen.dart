import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/daily_volume.dart';
import '../models/route_model.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/chart_type_selector.dart';

enum RouteMetric { gallons, completionRate }

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _AnalyticsKpiRow(),
          SizedBox(height: 16),
          _RoutePerformanceChart(),
          SizedBox(height: 16),
          _MonthOverMonthChart(),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _DayOfWeekChart()),
              SizedBox(width: 16),
              Expanded(flex: 2, child: _CompletionRateByRoute()),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AnalyticsKpiRow extends StatelessWidget {
  const _AnalyticsKpiRow();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final routes = p.routes.where((r) => r.completedStops > 0).toList();
    final avgGalPerStop = routes.isEmpty
        ? 0.0
        : routes.fold<double>(0, (s, r) => s + r.gallonsCollected) /
            routes.fold<int>(0, (s, r) => s + r.completedStops);
    final bestRoute = routes.isEmpty
        ? null
        : routes.reduce((a, b) =>
            a.gallonsCollected > b.gallonsCollected ? a : b);
    final completionRate = p.allPickups.isEmpty
        ? 0.0
        : p.completedPickups / p.totalPickups * 100;
    final volumes = p.dailyVolumes;
    final weekdayAvg = _weekdayAverage(volumes);

    return Row(
      children: [
        _AKpiCard(
          label: 'AVG GALLONS / STOP',
          value: avgGalPerStop.toStringAsFixed(1),
          unit: 'gal',
          icon: Icons.speed_rounded,
          color: AppTheme.accent,
        ),
        const SizedBox(width: 12),
        _AKpiCard(
          label: 'BEST ROUTE TODAY',
          value: bestRoute == null
              ? '—'
              : bestRoute.gallonsCollected.toStringAsFixed(0),
          unit: bestRoute == null ? '' : 'gal',
          sub: bestRoute?.name.split('—').last.trim(),
          icon: Icons.emoji_events_rounded,
          color: AppTheme.warning,
        ),
        const SizedBox(width: 12),
        _AKpiCard(
          label: 'COMPLETION RATE',
          value: completionRate.toStringAsFixed(1),
          unit: '%',
          icon: Icons.check_circle_rounded,
          color: AppTheme.success,
        ),
        const SizedBox(width: 12),
        _AKpiCard(
          label: 'WEEKDAY AVG VOLUME',
          value: NumberFormat('#,###').format(weekdayAvg),
          unit: 'gal',
          icon: Icons.calendar_today_rounded,
          color: AppTheme.info,
        ),
      ],
    );
  }

  int _weekdayAverage(List<DailyVolume> volumes) {
    final weekdays = volumes
        .where((v) =>
            v.date.weekday != DateTime.saturday &&
            v.date.weekday != DateTime.sunday)
        .toList();
    if (weekdays.isEmpty) return 0;
    return weekdays.fold(0, (s, v) => s + v.gallons) ~/ weekdays.length;
  }
}

class _AKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String? sub;
  final IconData icon;
  final Color color;

  const _AKpiCard({
    required this.label,
    required this.value,
    required this.unit,
    this.sub,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTheme.kpiLabel
                          .copyWith(fontSize: 10, letterSpacing: 0.6)),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(value,
                          style: AppTheme.kpiValue.copyWith(fontSize: 24)),
                      const SizedBox(width: 3),
                      Text(unit,
                          style: AppTheme.bodySmall.copyWith(fontSize: 12)),
                    ],
                  ),
                  if (sub != null)
                    Text(sub!,
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Route Performance — horizontal progress bars (gallons or completion %)
// ---------------------------------------------------------------------------
class _RoutePerformanceChart extends StatefulWidget {
  const _RoutePerformanceChart();

  @override
  State<_RoutePerformanceChart> createState() =>
      _RoutePerformanceChartState();
}

class _RoutePerformanceChartState extends State<_RoutePerformanceChart> {
  RouteMetric _metric = RouteMetric.gallons;

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<DashboardProvider>().routes;
    final sorted = [...routes]..sort((a, b) => _metric == RouteMetric.gallons
        ? b.gallonsCollected.compareTo(a.gallonsCollected)
        : b.progress.compareTo(a.progress));
    final maxVal = _metric == RouteMetric.gallons
        ? sorted
            .map((r) => r.gallonsCollected)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    return DashboardCard(
      title: 'Route Performance',
      trailing: ChartTypeSelector<RouteMetric>(
        options: const [
          (RouteMetric.gallons, 'Gallons', Icons.local_gas_station_rounded),
          (RouteMetric.completionRate, 'Completion %',
              Icons.check_circle_outline_rounded),
        ],
        selected: _metric,
        onSelect: (m) => setState(() => _metric = m),
      ),
      child: Column(
        children: sorted.map((r) {
          final val = _metric == RouteMetric.gallons
              ? r.gallonsCollected
              : r.progress * 100;
          final frac = maxVal > 0 ? val / maxVal : 0.0;
          final label = _metric == RouteMetric.gallons
              ? '${val.toStringAsFixed(0)} gal'
              : '${val.toStringAsFixed(0)}%';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 170,
                  child: Text(
                    r.name.split('—').last.trim(),
                    style: AppTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: frac.clamp(0.0, 1.0),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: r.driverStatus.color.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 60,
                  child: Text(
                    label,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month-over-Month Comparison
// ---------------------------------------------------------------------------
class _MonthOverMonthChart extends StatelessWidget {
  const _MonthOverMonthChart();

  @override
  Widget build(BuildContext context) {
    final volumes = context.watch<DashboardProvider>().dailyVolumes;

    final marchData = <int, int>{};
    final aprilData = <int, int>{};
    for (final v in volumes) {
      if (v.date.month == 3) marchData[v.date.day] = v.gallons;
      if (v.date.month == 4) aprilData[v.date.day] = v.gallons;
    }

    final marchSpots = marchData.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
    final aprilSpots = aprilData.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final allY = [
      ...marchSpots.map((s) => s.y),
      ...aprilSpots.map((s) => s.y),
    ];
    if (allY.isEmpty) return const SizedBox();
    final maxY = allY.reduce((a, b) => a > b ? a : b) * 1.2;

    final marchTotal = marchData.values.fold(0, (s, v) => s + v);
    final aprilTotal = aprilData.values.fold(0, (s, v) => s + v);
    final diff = aprilTotal - marchTotal;
    final diffColor = diff >= 0 ? AppTheme.success : AppTheme.error;

    return DashboardCard(
      title: 'Month-over-Month Volume',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MomLegend(color: AppTheme.info, label: 'March'),
          const SizedBox(width: 12),
          _MomLegend(color: AppTheme.accent, label: 'April'),
          const SizedBox(width: 12),
          Text(
            '${diff >= 0 ? '+' : ''}${NumberFormat('#,###').format(diff)} gal vs March',
            style: AppTheme.labelMedium.copyWith(
                color: diffColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 500,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: AppTheme.divider, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: 5,
                  getTitlesWidget: (v, _) {
                    final d = v.toInt();
                    if (d % 5 != 0) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Day $d',
                        style: AppTheme.bodySmall.copyWith(fontSize: 9),
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
                  getTitlesWidget: (v, _) {
                    if (v == 0) return const SizedBox();
                    return Text(
                      '${(v / 1000).toStringAsFixed(1)}k',
                      style: AppTheme.bodySmall.copyWith(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: marchSpots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: AppTheme.info,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.info.withOpacity(0.12),
                      AppTheme.info.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              LineChartBarData(
                spots: aprilSpots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: AppTheme.accent,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.accent.withOpacity(0.12),
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
                  final month = s.barIndex == 0 ? 'March' : 'April';
                  final color = s.barIndex == 0 ? AppTheme.info : AppTheme.accent;
                  return LineTooltipItem(
                    '$month Day ${s.x.toInt()}\n',
                    AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                    children: [
                      TextSpan(
                        text: '${NumberFormat('#,###').format(s.y.toInt())} gal',
                        style: AppTheme.bodyMedium.copyWith(
                            color: color, fontWeight: FontWeight.w700),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MomLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _MomLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTheme.bodySmall.copyWith(fontSize: 11)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Volume by Day of Week
// ---------------------------------------------------------------------------
enum DowChartType { bar, line }

class _DayOfWeekChart extends StatefulWidget {
  const _DayOfWeekChart();

  @override
  State<_DayOfWeekChart> createState() => _DayOfWeekChartState();
}

class _DayOfWeekChartState extends State<_DayOfWeekChart> {
  DowChartType _type = DowChartType.bar;

  @override
  Widget build(BuildContext context) {
    final volumes = context.watch<DashboardProvider>().dailyVolumes;

    // Average gallons by day of week (1=Mon ... 7=Sun)
    final Map<int, List<int>> byDay = {};
    for (final v in volumes) {
      byDay.putIfAbsent(v.date.weekday, () => []).add(v.gallons);
    }
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final avgs = List.generate(7, (i) {
      final day = i + 1;
      final vals = byDay[day] ?? [];
      if (vals.isEmpty) return 0.0;
      return vals.fold(0, (s, v) => s + v) / vals.length;
    });
    final maxAvg = avgs.reduce((a, b) => a > b ? a : b);

    return DashboardCard(
      title: 'Avg Volume by Day of Week',
      trailing: ChartTypeSelector<DowChartType>(
        options: const [
          (DowChartType.bar, 'Bar', Icons.bar_chart_rounded),
          (DowChartType.line, 'Line', Icons.show_chart_rounded),
        ],
        selected: _type,
        onSelect: (t) => setState(() => _type = t),
      ),
      child: SizedBox(
        height: 220,
        child: _type == DowChartType.bar
            ? BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAvg * 1.2,
                  barGroups: List.generate(7, (i) {
                    final isWeekend = i >= 5;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: avgs[i],
                          color: isWeekend
                              ? AppTheme.info.withOpacity(0.4)
                              : AppTheme.accent,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 26,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i > 6) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[i],
                                style: AppTheme.bodySmall
                                    .copyWith(fontSize: 11)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: 500,
                        getTitlesWidget: (v, _) {
                          if (v == 0) return const SizedBox();
                          return Text(
                            '${(v / 1000).toStringAsFixed(1)}k',
                            style:
                                AppTheme.bodySmall.copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppTheme.divider, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              )
            : LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxAvg * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppTheme.divider, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 26,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i > 6) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[i],
                                style: AppTheme.bodySmall
                                    .copyWith(fontSize: 11)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: 500,
                        getTitlesWidget: (v, _) {
                          if (v == 0) return const SizedBox();
                          return Text(
                            '${(v / 1000).toStringAsFixed(1)}k',
                            style:
                                AppTheme.bodySmall.copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                          7, (i) => FlSpot(i.toDouble(), avgs[i])),
                      isCurved: true,
                      color: AppTheme.accent,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.accent,
                          strokeWidth: 0,
                          strokeColor: Colors.transparent,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.accent.withOpacity(0.15),
                            AppTheme.accent.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Completion rate by route — simple horizontal bars
// ---------------------------------------------------------------------------
class _CompletionRateByRoute extends StatelessWidget {
  const _CompletionRateByRoute();

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<DashboardProvider>().routes;
    final sorted = [...routes]
      ..sort((a, b) => b.progress.compareTo(a.progress));

    return DashboardCard(
      title: 'Stop Completion Rate',
      child: Column(
        children: sorted.map((r) {
          final pct = (r.progress * 100).toStringAsFixed(0);
          final color = r.progress >= 0.8
              ? AppTheme.success
              : r.progress >= 0.5
                  ? AppTheme.warning
                  : r.progress == 0
                      ? AppTheme.textSecondary
                      : AppTheme.error;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.name.split('—').last.trim(),
                      style: AppTheme.bodySmall,
                    ),
                    Text(
                      '$pct%',
                      style: AppTheme.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: r.progress,
                    minHeight: 6,
                    backgroundColor: AppTheme.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
