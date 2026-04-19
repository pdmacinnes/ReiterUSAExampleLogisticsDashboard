class CommodityPrice {
  final String name;
  final double pricePerLb;
  final double change;

  const CommodityPrice({
    required this.name,
    required this.pricePerLb,
    required this.change,
  });

  CommodityPrice copyWith({double? pricePerLb, double? change}) {
    return CommodityPrice(
      name: name,
      pricePerLb: pricePerLb ?? this.pricePerLb,
      change: change ?? this.change,
    );
  }
}
