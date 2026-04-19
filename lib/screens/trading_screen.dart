import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/trade.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/chart_type_selector.dart';

enum TradeBreakdownBy { commodity, status }

class TradingScreen extends StatelessWidget {
  const TradingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _TradingKpiRow(),
          SizedBox(height: 16),
          _NetPnLCard(),
          SizedBox(height: 16),
          _MarketPricesCard(),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _TradeBreakdownChart()),
              SizedBox(width: 16),
              Expanded(flex: 3, child: _FullTradeTable()),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TradingKpiRow extends StatelessWidget {
  const _TradingKpiRow();

  @override
  Widget build(BuildContext context) {
    final trades = context.watch<DashboardProvider>().trades;

    final openBuyLbs = trades
        .where((t) => t.type == TradeType.buy && t.status == TradeStatus.open)
        .fold(0, (s, t) => s + t.volumeLbs);
    final openSellLbs = trades
        .where((t) => t.type == TradeType.sell && t.status == TradeStatus.open)
        .fold(0, (s, t) => s + t.volumeLbs);
    final settledCount =
        trades.where((t) => t.status == TradeStatus.settled).length;
    final settledValue = trades
        .where((t) => t.status == TradeStatus.settled)
        .fold(0.0, (s, t) => s + t.totalValue);

    return Row(
      children: [
        _TKpi('OPEN BUY VOLUME',
            '${NumberFormat('#,###').format(openBuyLbs)} lbs',
            Icons.arrow_downward_rounded, AppTheme.success),
        const SizedBox(width: 12),
        _TKpi('OPEN SELL VOLUME',
            '${NumberFormat('#,###').format(openSellLbs)} lbs',
            Icons.arrow_upward_rounded, AppTheme.accent),
        const SizedBox(width: 12),
        _TKpi('SETTLED TRADES', '$settledCount trades',
            Icons.verified_rounded, AppTheme.info),
        const SizedBox(width: 12),
        _TKpi('SETTLED VALUE',
            '\$${NumberFormat('#,###').format(settledValue.toInt())}',
            Icons.attach_money_rounded, AppTheme.warning),
      ],
    );
  }
}

class _TKpi extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TKpi(this.label, this.value, this.icon, this.color);

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
              width: 42,
              height: 42,
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
                          .copyWith(fontSize: 10, letterSpacing: 0.5)),
                  const SizedBox(height: 3),
                  Text(value,
                      style: AppTheme.bodyMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
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
// Net P&L Card
// ---------------------------------------------------------------------------
class _NetPnLCard extends StatelessWidget {
  const _NetPnLCard();

  @override
  Widget build(BuildContext context) {
    final trades = context.watch<DashboardProvider>().trades;

    final settled = trades.where((t) => t.status == TradeStatus.settled).toList();
    final sellRevenue = settled
        .where((t) => t.type == TradeType.sell)
        .fold(0.0, (s, t) => s + t.totalValue);
    final buyCost = settled
        .where((t) => t.type == TradeType.buy)
        .fold(0.0, (s, t) => s + t.totalValue);
    final pnl = sellRevenue - buyCost;
    final margin = buyCost > 0 ? pnl / buyCost * 100 : 0.0;
    final isPositive = pnl >= 0;
    final pnlColor = isPositive ? AppTheme.success : AppTheme.error;

    return DashboardCard(
      title: 'Net P&L — Settled Trades',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: pnlColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: pnlColor.withOpacity(0.4)),
        ),
        child: Text(
          '${isPositive ? '+' : ''}${margin.toStringAsFixed(1)}% margin',
          style: TextStyle(
              color: pnlColor, fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
      child: Row(
        children: [
          _PnLStat(
            label: 'SELL REVENUE',
            value: '\$${NumberFormat('#,###').format(sellRevenue.toInt())}',
            color: AppTheme.accent,
            icon: Icons.arrow_upward_rounded,
          ),
          const SizedBox(width: 12),
          _PnLStat(
            label: 'BUY COST',
            value: '\$${NumberFormat('#,###').format(buyCost.toInt())}',
            color: AppTheme.info,
            icon: Icons.arrow_downward_rounded,
          ),
          const SizedBox(width: 12),
          _PnLStat(
            label: 'NET P&L',
            value:
                '${isPositive ? '+' : ''}\$${NumberFormat('#,###').format(pnl.toInt())}',
            color: pnlColor,
            icon: isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            large: true,
          ),
          const SizedBox(width: 12),
          _PnLStat(
            label: 'SETTLED TRADES',
            value: '${settled.length}',
            color: AppTheme.textSecondary,
            icon: Icons.receipt_long_rounded,
          ),
        ],
      ),
    );
  }
}

class _PnLStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool large;

  const _PnLStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: large ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: large ? color.withOpacity(0.08) : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: large ? color.withOpacity(0.3) : AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTheme.kpiLabel
                          .copyWith(fontSize: 9, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTheme.bodyMedium.copyWith(
                      fontSize: large ? 16 : 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
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

// ---------------------------------------------------------------------------
// Market Prices
// ---------------------------------------------------------------------------
class _MarketPricesCard extends StatelessWidget {
  const _MarketPricesCard();

  @override
  Widget build(BuildContext context) {
    final prices = context.watch<DashboardProvider>().commodityPrices;

    return DashboardCard(
      title: 'Current Market Prices',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.success.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.success.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  color: AppTheme.success, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text('Live',
                style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      child: Row(
        children: prices.map((p) {
          final isUp = p.change >= 0;
          final changeColor = isUp ? AppTheme.success : AppTheme.error;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: AppTheme.labelMedium),
                  const SizedBox(height: 8),
                  Text(
                    '\$${p.pricePerLb.toStringAsFixed(4)}/lb',
                    style: AppTheme.kpiValue.copyWith(
                        fontSize: 22, color: AppTheme.accent),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        size: 18,
                        color: changeColor,
                      ),
                      Text(
                        '\$${p.change.abs().toStringAsFixed(4)}',
                        style: TextStyle(
                            color: changeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trade breakdown pie chart
// ---------------------------------------------------------------------------
class _TradeBreakdownChart extends StatefulWidget {
  const _TradeBreakdownChart();

  @override
  State<_TradeBreakdownChart> createState() => _TradeBreakdownChartState();
}

class _TradeBreakdownChartState extends State<_TradeBreakdownChart> {
  TradeBreakdownBy _by = TradeBreakdownBy.commodity;

  @override
  Widget build(BuildContext context) {
    final trades = context.watch<DashboardProvider>().trades;

    final Map<String, int> groups = {};
    final Map<String, Color> colors = {};

    if (_by == TradeBreakdownBy.commodity) {
      for (final t in trades) {
        groups.update(t.commodity.label, (v) => v + t.volumeLbs,
            ifAbsent: () => t.volumeLbs);
      }
      colors[CommodityType.uco.label] = AppTheme.accent;
      colors[CommodityType.yellowGrease.label] = AppTheme.warning;
      colors[CommodityType.tallow.label] = AppTheme.info;
    } else {
      for (final t in trades) {
        groups.update(t.status.label, (v) => v + t.volumeLbs,
            ifAbsent: () => t.volumeLbs);
      }
      colors[TradeStatus.open.label] = AppTheme.info;
      colors[TradeStatus.pendingSettlement.label] = AppTheme.warning;
      colors[TradeStatus.settled.label] = AppTheme.success;
    }

    final total = groups.values.fold(0, (s, v) => s + v);
    final sections = groups.entries.map((e) {
      final color = colors[e.key] ?? AppTheme.textSecondary;
      final pct = (e.value / total * 100).toStringAsFixed(1);
      return PieChartSectionData(
        value: e.value.toDouble(),
        color: color,
        title: '$pct%',
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
        radius: 65,
      );
    }).toList();

    return DashboardCard(
      title: 'Volume Breakdown',
      trailing: ChartTypeSelector<TradeBreakdownBy>(
        options: const [
          (TradeBreakdownBy.commodity, 'Commodity',
              Icons.category_rounded),
          (TradeBreakdownBy.status, 'Status',
              Icons.pending_actions_rounded),
        ],
        selected: _by,
        onSelect: (b) => setState(() => _by = b),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...groups.entries.map((e) {
            final color = colors[e.key] ?? AppTheme.textSecondary;
            final pct = (e.value / total * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(e.key, style: AppTheme.bodySmall)),
                  Text(
                    '${NumberFormat('#,###').format(e.value)} lbs ($pct%)',
                    style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Full trade table
// ---------------------------------------------------------------------------
class _FullTradeTable extends StatelessWidget {
  const _FullTradeTable();

  @override
  Widget build(BuildContext context) {
    final trades = context.watch<DashboardProvider>().trades;

    return DashboardCard(
      title: 'All Trades — April 2026',
      padding: EdgeInsets.zero,
      trailing: Text(
        '${trades.length} total',
        style: AppTheme.labelMedium,
      ),
      child: Column(
        children: [
          _THeader(),
          ...trades.asMap().entries.map(
                (e) => _TRow(trade: e.value, index: e.key),
              ),
        ],
      ),
    );
  }
}

class _THeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      color: AppTheme.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: const [
          SizedBox(width: 96, child: _TH('TRADE ID')),
          SizedBox(width: 44, child: _TH('TYPE')),
          Expanded(flex: 2, child: _TH('COMMODITY')),
          Expanded(flex: 2, child: _TH('VOLUME')),
          SizedBox(width: 60, child: _TH('PRICE')),
          SizedBox(width: 80, child: _TH('VALUE')),
          Expanded(flex: 3, child: _TH('COUNTERPARTY')),
          SizedBox(width: 76, child: _TH('STATUS')),
          SizedBox(width: 72, child: _TH('DATE')),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;

  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.kpiLabel.copyWith(fontSize: 9, letterSpacing: 0.7),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TRow extends StatelessWidget {
  final Trade trade;
  final int index;

  const _TRow({required this.trade, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: index.isEven ? AppTheme.surface : AppTheme.surfaceElevated,
        border: Border(
            bottom: BorderSide(color: AppTheme.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              trade.id,
              style: AppTheme.bodySmall
                  .copyWith(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
          SizedBox(
            width: 44,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: trade.type.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                trade.type.label,
                style: TextStyle(
                    color: trade.type.color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(trade.commodity.label,
                style: AppTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${NumberFormat('#,###').format(trade.volumeLbs)} lbs',
              style: AppTheme.bodySmall
                  .copyWith(color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '\$${trade.pricePerLb.toStringAsFixed(3)}',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.accent),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '\$${NumberFormat('#,###').format(trade.totalValue.toInt())}',
              style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(trade.counterparty,
                style: AppTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 76,
            child: _StatusBadge(status: trade.status),
          ),
          SizedBox(
            width: 72,
            child: Text(
              '${trade.tradeDate.month}/${trade.tradeDate.day}/${trade.tradeDate.year}',
              style: AppTheme.bodySmall.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TradeStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
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
