import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/kpi_bar.dart';
import '../widgets/commodity_ticker.dart';
import '../widgets/pickup_status_panel.dart';
import '../widgets/volume_trend_chart.dart';
import '../widgets/route_status_cards.dart';
import '../widgets/open_trades_table.dart';
import '../widgets/compliance_snapshot.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoaded = context.watch<DashboardProvider>().isLoaded;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _AppHeader(),
          const CommodityTicker(),
          Expanded(
            child: isLoaded
                ? const _DashboardBody()
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accent,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REITER USA',
                style: AppTheme.kpiLabel.copyWith(
                  color: AppTheme.accent,
                  letterSpacing: 2.0,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Logistics Operations Dashboard',
                style: AppTheme.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          _DateBadge(),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppTheme.success.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Text(
        'Sunday, April 19, 2026',
        style: AppTheme.bodySmall.copyWith(color: AppTheme.textPrimary),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const KpiBar(),
              const SizedBox(height: 16),
              if (isWide) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Expanded(flex: 3, child: PickupStatusPanel()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: RouteStatusCards()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Expanded(flex: 3, child: VolumeTrendChart()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: OpenTradesTable()),
                    ],
                  ),
                ),
              ] else ...[
                const PickupStatusPanel(),
                const SizedBox(height: 16),
                const RouteStatusCards(),
                const SizedBox(height: 16),
                const VolumeTrendChart(),
                const SizedBox(height: 16),
                const OpenTradesTable(),
              ],
              const SizedBox(height: 16),
              const ComplianceSnapshot(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
