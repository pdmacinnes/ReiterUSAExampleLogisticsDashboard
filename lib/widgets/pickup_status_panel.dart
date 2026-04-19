import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/pickup.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';
import 'chart_type_selector.dart';

enum PickupViewType { table, donut }

class PickupStatusPanel extends StatefulWidget {
  const PickupStatusPanel({super.key});

  @override
  State<PickupStatusPanel> createState() => _PickupStatusPanelState();
}

class _PickupStatusPanelState extends State<PickupStatusPanel> {
  PickupViewType _viewType = PickupViewType.table;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final allPickups = provider.allPickups;

    return DashboardCard(
      title: 'Pickup Status',
      padding: EdgeInsets.zero,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_viewType == PickupViewType.table)
            _FilterRow(activeFilter: provider.activeFilter),
          const SizedBox(width: 8),
          ChartTypeSelector<PickupViewType>(
            options: const [
              (PickupViewType.table, 'Table', Icons.table_rows_rounded),
              (PickupViewType.donut, 'Donut', Icons.donut_large_rounded),
            ],
            selected: _viewType,
            onSelect: (t) => setState(() => _viewType = t),
          ),
        ],
      ),
      child: _viewType == PickupViewType.table
          ? _TableView(provider: provider)
          : _DonutView(pickups: allPickups),
    );
  }
}

// ---------------------------------------------------------------------------
// Table view
// ---------------------------------------------------------------------------
class _TableView extends StatelessWidget {
  final DashboardProvider provider;

  const _TableView({required this.provider});

  @override
  Widget build(BuildContext context) {
    final pickups = provider.filteredPickups;
    return Column(
      children: [
        _TableHeader(),
        SizedBox(
          height: 370,
          child: pickups.isEmpty
              ? Center(
                  child: Text('No pickups match filter',
                      style: AppTheme.bodySmall))
              : ListView.builder(
                  itemCount: pickups.length,
                  itemBuilder: (ctx, i) =>
                      _PickupRow(pickup: pickups[i], index: i),
                ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  final PickupStatus? activeFilter;

  const _FilterRow({required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DashboardProvider>();
    const filters = [
      (null, 'All'),
      (PickupStatus.completed, 'Done'),
      (PickupStatus.inProgress, 'Active'),
      (PickupStatus.scheduled, 'Scheduled'),
      (PickupStatus.missed, 'Missed'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: filters.map((f) {
        final isActive = f.$1 == activeFilter;
        return GestureDetector(
          onTap: () => provider.setFilter(f.$1),
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? (f.$1?.color ?? AppTheme.accent).withOpacity(0.2)
                  : AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? (f.$1?.color ?? AppTheme.accent)
                    : AppTheme.divider,
              ),
            ),
            child: Text(
              f.$2,
              style: TextStyle(
                color: isActive
                    ? (f.$1?.color ?? AppTheme.accent)
                    : AppTheme.textSecondary,
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: AppTheme.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          SizedBox(width: 90, child: _HeaderCell('STATUS')),
          Expanded(flex: 3, child: _HeaderCell('LOCATION')),
          Expanded(flex: 2, child: _HeaderCell('CITY')),
          SizedBox(width: 70, child: _HeaderCell('TIME')),
          SizedBox(width: 70, child: _HeaderCell('GALLONS')),
          Expanded(flex: 2, child: _HeaderCell('DRIVER')),
          Expanded(flex: 2, child: _HeaderCell('ROUTE')),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.kpiLabel.copyWith(fontSize: 10, letterSpacing: 0.8),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _PickupRow extends StatelessWidget {
  final Pickup pickup;
  final int index;

  const _PickupRow({required this.pickup, required this.index});

  @override
  Widget build(BuildContext context) {
    final timeStr = _fmt(pickup.scheduledTime);
    final gallonsStr = pickup.volumeGallons != null
        ? pickup.volumeGallons!.toStringAsFixed(1)
        : '—';

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: index.isEven ? AppTheme.surface : AppTheme.surfaceElevated,
        border:
            Border(bottom: BorderSide(color: AppTheme.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(width: 90, child: _StatusBadge(status: pickup.status)),
          Expanded(
            flex: 3,
            child: Text(pickup.locationName,
                style: AppTheme.bodyMedium, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text(pickup.city,
                style: AppTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
              width: 70,
              child: Text(timeStr, style: AppTheme.bodySmall)),
          SizedBox(
            width: 70,
            child: Text(
              gallonsStr,
              style: AppTheme.bodySmall.copyWith(
                color: pickup.volumeGallons != null
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontWeight: pickup.volumeGallons != null
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(pickup.driverName,
                style: AppTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pickup.routeName.replaceAll('Route ', 'Rt.'),
              style: AppTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'am' : 'pm';
    return '$h:$m $period';
  }
}

class _StatusBadge extends StatelessWidget {
  final PickupStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.bgColor,
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

// ---------------------------------------------------------------------------
// Donut view
// ---------------------------------------------------------------------------
class _DonutView extends StatelessWidget {
  final List<Pickup> pickups;

  const _DonutView({required this.pickups});

  @override
  Widget build(BuildContext context) {
    final counts = {
      for (final s in PickupStatus.values)
        s: pickups.where((p) => p.status == s).length,
    };
    final total = pickups.length;

    final sections = PickupStatus.values
        .where((s) => (counts[s] ?? 0) > 0)
        .map((s) {
          final count = counts[s]!;
          final pct = (count / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            value: count.toDouble(),
            color: s.color,
            title: '$count\n$pct%',
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
            radius: 70,
          );
        })
        .toList();

    return SizedBox(
      height: 406,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 55,
                sectionsSpace: 3,
                pieTouchData: PieTouchData(enabled: true),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...PickupStatus.values.map((s) {
                final count = counts[s] ?? 0;
                final pct =
                    total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.label, style: AppTheme.bodySmall),
                          Text(
                            '$count pickups ($pct%)',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pickups Today',
                        style: AppTheme.kpiLabel.copyWith(fontSize: 10)),
                    Text(
                      '$total',
                      style: AppTheme.kpiValue.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
