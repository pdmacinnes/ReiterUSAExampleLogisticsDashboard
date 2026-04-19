import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/commodity_price.dart';
import '../theme/app_theme.dart';

class CommodityTicker extends StatelessWidget {
  const CommodityTicker({super.key});

  @override
  Widget build(BuildContext context) {
    final prices = context.watch<DashboardProvider>().commodityPrices;

    return Container(
      color: AppTheme.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            'COMMODITY PRICES',
            style: AppTheme.kpiLabel.copyWith(
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 20),
          ...prices.map((p) => _PriceChip(price: p)),
          const Spacer(),
          Text(
            'Live — updates every 4s',
            style: AppTheme.bodySmall.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final CommodityPrice price;

  const _PriceChip({required this.price});

  @override
  Widget build(BuildContext context) {
    final isUp = price.change >= 0;
    final changeColor = isUp ? AppTheme.success : AppTheme.error;

    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            price.name,
            style: AppTheme.labelMedium.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(width: 6),
          Text(
            '\$${price.pricePerLb.toStringAsFixed(3)}/lb',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 16,
            color: changeColor,
          ),
          Text(
            price.change.abs().toStringAsFixed(3),
            style: AppTheme.bodySmall.copyWith(
              color: changeColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
