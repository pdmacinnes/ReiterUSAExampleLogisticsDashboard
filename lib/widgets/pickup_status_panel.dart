import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/pickup.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class PickupStatusPanel extends StatelessWidget {
  const PickupStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final pickups = provider.filteredPickups;
    final active = provider.activeFilter;

    return DashboardCard(
      title: 'Pickup Status',
      padding: EdgeInsets.zero,
      trailing: _FilterRow(activeFilter: active),
      child: Column(
        children: [
          _TableHeader(),
          SizedBox(
            height: 370,
            child: pickups.isEmpty
                ? Center(
                    child: Text(
                      'No pickups match filter',
                      style: AppTheme.bodySmall,
                    ),
                  )
                : ListView.builder(
                    itemCount: pickups.length,
                    itemBuilder: (ctx, i) =>
                        _PickupRow(pickup: pickups[i], index: i),
                  ),
          ),
        ],
      ),
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
      (PickupStatus.completed, 'Completed'),
      (PickupStatus.inProgress, 'In Progress'),
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
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              style: AppTheme.bodySmall.copyWith(
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
    final timeStr = DateFormat('h:mm a').format(pickup.scheduledTime);
    final gallonsStr = pickup.volumeGallons != null
        ? pickup.volumeGallons!.toStringAsFixed(1)
        : '—';
    final isEven = index.isEven;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isEven ? AppTheme.surface : AppTheme.surfaceElevated,
        border: Border(
          bottom: BorderSide(color: AppTheme.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: _StatusBadge(status: pickup.status),
          ),
          Expanded(
            flex: 3,
            child: Text(
              pickup.locationName,
              style: AppTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pickup.city,
              style: AppTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(timeStr, style: AppTheme.bodySmall),
          ),
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
            child: Text(
              pickup.driverName,
              style: AppTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
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
          color: status.color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
