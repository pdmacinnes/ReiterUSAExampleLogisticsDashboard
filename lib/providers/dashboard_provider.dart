import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/pickup.dart';
import '../models/route_model.dart';
import '../models/trade.dart';
import '../models/daily_volume.dart';
import '../models/commodity_price.dart';
import '../models/alert_model.dart';
import '../services/mock_data_service.dart';

class DashboardProvider extends ChangeNotifier {
  List<Pickup> _pickups = [];
  List<RouteModel> _routes = [];
  List<Trade> _trades = [];
  List<DailyVolume> _dailyVolumes = [];
  List<CommodityPrice> _commodityPrices = [];
  PickupStatus? _activeFilter;
  bool _isLoaded = false;

  Timer? _tickerTimer;
  final _rng = Random();

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  bool get isLoaded => _isLoaded;
  List<RouteModel> get routes => _routes;
  List<DailyVolume> get dailyVolumes => _dailyVolumes;
  List<Trade> get trades => _trades;
  List<CommodityPrice> get commodityPrices => _commodityPrices;
  PickupStatus? get activeFilter => _activeFilter;
  List<Pickup> get allPickups => _pickups;

  List<Pickup> get filteredPickups {
    if (_activeFilter == null) return _pickups;
    return _pickups.where((p) => p.status == _activeFilter).toList();
  }

  // KPI computed values
  double get totalGallonsToday => _pickups
      .where((p) => p.status == PickupStatus.completed)
      .fold(0.0, (sum, p) => sum + (p.volumeGallons ?? 0));

  int get completedPickups =>
      _pickups.where((p) => p.status == PickupStatus.completed).length;

  int get totalPickups => _pickups.length;

  int get activeDrivers =>
      _routes.where((r) => r.driverStatus != DriverStatus.offDuty).length;

  int get openTradeVolumeLbs => _trades
      .where((t) => t.status == TradeStatus.open)
      .fold(0, (sum, t) => sum + t.volumeLbs);

  // Compliance stats
  int get lcfsSubmitted => 89;
  int get lcfsRequired => 95;

  List<AlertItem> get alerts {
    final now = DateTime.now();
    final list = <AlertItem>[];

    for (final p in _pickups.where((p) => p.status == PickupStatus.missed)) {
      list.add(AlertItem(
        type: AlertType.urgent,
        title: 'Missed Pickup: ${p.locationName}',
        detail: '${p.city} — ${p.driverName}',
        timestamp: p.scheduledTime,
      ));
    }

    for (final r in _routes.where((r) => r.driverStatus == DriverStatus.onBreak)) {
      list.add(AlertItem(
        type: AlertType.warning,
        title: 'Driver On Break: ${r.driverName}',
        detail: r.name.split('—').last.trim(),
        timestamp: now.subtract(const Duration(minutes: 23)),
      ));
    }

    if (lcfsSubmitted < lcfsRequired) {
      list.add(AlertItem(
        type: AlertType.warning,
        title: 'LCFS Submissions Below Target',
        detail: '$lcfsSubmitted / $lcfsRequired records submitted this month',
        timestamp: now.subtract(const Duration(hours: 2)),
      ));
    }

    if (completedPickups >= 40) {
      list.add(AlertItem(
        type: AlertType.info,
        title: 'Collection Milestone Reached',
        detail: '$completedPickups pickups completed today',
        timestamp: now.subtract(const Duration(hours: 1)),
      ));
    }

    list.sort((a, b) => b.type.index.compareTo(a.type.index));
    return list;
  }
  double get totalGallonsTrackedMtd =>
      _dailyVolumes.fold(0.0, (sum, v) => sum + v.gallons);

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------
  void initialize() {
    _pickups = MockDataService.getPickups();
    _routes = MockDataService.getRoutes();
    _trades = MockDataService.getTrades();
    _dailyVolumes = MockDataService.getDailyVolumes();
    _commodityPrices = MockDataService.getCommodityPrices();
    _isLoaded = true;
    notifyListeners();

    _tickerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _driftPrices();
    });
  }

  void setFilter(PickupStatus? status) {
    _activeFilter = status;
    notifyListeners();
  }

  void _driftPrices() {
    _commodityPrices = _commodityPrices.map((p) {
      final drift = (_rng.nextDouble() - 0.5) * 0.004;
      final newPrice = (p.pricePerLb + drift).clamp(0.20, 0.90);
      return p.copyWith(pricePerLb: newPrice, change: drift);
    }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }
}
