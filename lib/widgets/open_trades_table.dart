import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/trade.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class OpenTradesTable extends StatelessWidget {
  const OpenTradesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final trades = context.watch<DashboardProvider>().trades;
    final openCount =
        trades.where((t) => t.status == TradeStatus.open).length;

    return DashboardCard(
      title: 'Commodity Trades',
      padding: EdgeInsets.zero,
      trailing: Text(
        '$openCount open',
        style: AppTheme.labelMedium.copyWith(
          color: AppTheme.info,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Column(
        children: [
          _TradeHeader(),
          SizedBox(
            height: 230,
            child: ListView.builder(
              itemCount: trades.length,
              itemBuilder: (ctx, i) => _TradeRow(trade: trades[i], index: i),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      color: AppTheme.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: const [
          SizedBox(width: 90, child: _TH('TRADE ID')),
          SizedBox(width: 44, child: _TH('TYPE')),
          Expanded(flex: 2, child: _TH('COMMODITY')),
          Expanded(flex: 2, child: _TH('VOLUME')),
          SizedBox(width: 60, child: _TH('PRICE')),
          Expanded(flex: 3, child: _TH('COUNTERPARTY')),
          SizedBox(width: 72, child: _TH('STATUS')),
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

class _TradeRow extends StatelessWidget {
  final Trade trade;
  final int index;

  const _TradeRow({required this.trade, required this.index});

  @override
  Widget build(BuildContext context) {
    final lbsStr =
        '${NumberFormat('#,###').format(trade.volumeLbs)} lbs';
    final isEven = index.isEven;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
            child: Text(
              trade.id,
              style: AppTheme.bodySmall.copyWith(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: trade.type.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                trade.type.label,
                style: TextStyle(
                  color: trade.type.color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              trade.commodity.label,
              style: AppTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lbsStr,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '\$${trade.pricePerLb.toStringAsFixed(3)}',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.accent),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              trade.counterparty,
              style: AppTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 72,
            child: _StatusBadge(status: trade.status),
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
          color: status.color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
