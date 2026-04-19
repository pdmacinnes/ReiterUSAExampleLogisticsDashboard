import 'package:flutter/material.dart';

enum TradeType { buy, sell }

enum CommodityType { uco, yellowGrease, tallow }

enum TradeStatus { open, pendingSettlement, settled }

extension TradeTypeX on TradeType {
  String get label => this == TradeType.buy ? 'BUY' : 'SELL';
  Color get color =>
      this == TradeType.buy ? const Color(0xFF27AE60) : const Color(0xFFE8600A);
}

extension CommodityTypeX on CommodityType {
  String get label {
    switch (this) {
      case CommodityType.uco:
        return 'UCO';
      case CommodityType.yellowGrease:
        return 'Yellow Grease';
      case CommodityType.tallow:
        return 'Tallow';
    }
  }
}

extension TradeStatusX on TradeStatus {
  String get label {
    switch (this) {
      case TradeStatus.open:
        return 'Open';
      case TradeStatus.pendingSettlement:
        return 'Pending';
      case TradeStatus.settled:
        return 'Settled';
    }
  }

  Color get color {
    switch (this) {
      case TradeStatus.open:
        return const Color(0xFF3498DB);
      case TradeStatus.pendingSettlement:
        return const Color(0xFFF39C12);
      case TradeStatus.settled:
        return const Color(0xFF27AE60);
    }
  }
}

class Trade {
  final String id;
  final TradeType type;
  final CommodityType commodity;
  final int volumeLbs;
  final double pricePerLb;
  final String counterparty;
  final TradeStatus status;
  final DateTime tradeDate;

  const Trade({
    required this.id,
    required this.type,
    required this.commodity,
    required this.volumeLbs,
    required this.pricePerLb,
    required this.counterparty,
    required this.status,
    required this.tradeDate,
  });

  double get totalValue => volumeLbs * pricePerLb;
}
