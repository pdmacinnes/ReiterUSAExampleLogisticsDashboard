import '../models/pickup.dart';
import '../models/route_model.dart';
import '../models/trade.dart';
import '../models/daily_volume.dart';
import '../models/commodity_price.dart';

class MockDataService {
  static final DateTime _today = DateTime(2026, 4, 19);

  static DateTime _time(int hour, int minute) =>
      DateTime(_today.year, _today.month, _today.day, hour, minute);

  // ---------------------------------------------------------------------------
  // Routes — 12 total
  // ---------------------------------------------------------------------------
  static List<RouteModel> getRoutes() => [
        const RouteModel(
          id: 'r01',
          name: 'Route 1 — Downtown GJ',
          driverName: 'Marcus Webb',
          driverStatus: DriverStatus.onRoute,
          totalStops: 11,
          completedStops: 7,
          gallonsCollected: 218.5,
        ),
        const RouteModel(
          id: 'r02',
          name: 'Route 2 — North GJ',
          driverName: 'Tony Delgado',
          driverStatus: DriverStatus.onRoute,
          totalStops: 10,
          completedStops: 6,
          gallonsCollected: 195.0,
        ),
        const RouteModel(
          id: 'r03',
          name: 'Route 3 — East GJ / Clifton',
          driverName: 'Sarah Kim',
          driverStatus: DriverStatus.onBreak,
          totalStops: 11,
          completedStops: 7,
          gallonsCollected: 231.0,
        ),
        const RouteModel(
          id: 'r04',
          name: 'Route 4 — West GJ / Fruita',
          driverName: 'Jake Morrison',
          driverStatus: DriverStatus.onRoute,
          totalStops: 10,
          completedStops: 5,
          gallonsCollected: 162.0,
        ),
        const RouteModel(
          id: 'r05',
          name: 'Route 5 — Montrose',
          driverName: 'Carlos Rivera',
          driverStatus: DriverStatus.returning,
          totalStops: 10,
          completedStops: 8,
          gallonsCollected: 270.5,
        ),
        const RouteModel(
          id: 'r06',
          name: 'Route 6 — Delta',
          driverName: 'Amy Chen',
          driverStatus: DriverStatus.onRoute,
          totalStops: 9,
          completedStops: 5,
          gallonsCollected: 148.0,
        ),
        const RouteModel(
          id: 'r07',
          name: 'Route 7 — Glenwood Springs',
          driverName: 'Derek Thompson',
          driverStatus: DriverStatus.onRoute,
          totalStops: 11,
          completedStops: 6,
          gallonsCollected: 203.5,
        ),
        const RouteModel(
          id: 'r08',
          name: 'Route 8 — Rifle',
          driverName: 'Lisa Nakamura',
          driverStatus: DriverStatus.onBreak,
          totalStops: 10,
          completedStops: 6,
          gallonsCollected: 188.0,
        ),
        const RouteModel(
          id: 'r09',
          name: 'Route 9 — Moab, UT',
          driverName: 'Brandon Scott',
          driverStatus: DriverStatus.returning,
          totalStops: 9,
          completedStops: 7,
          gallonsCollected: 222.0,
        ),
        const RouteModel(
          id: 'r10',
          name: 'Route 10 — Grand Valley Loop',
          driverName: 'Rachel Flores',
          driverStatus: DriverStatus.onRoute,
          totalStops: 11,
          completedStops: 6,
          gallonsCollected: 185.5,
        ),
        const RouteModel(
          id: 'r11',
          name: 'Route 11 — I-70 Corridor',
          driverName: "Mike O'Brien",
          driverStatus: DriverStatus.offDuty,
          totalStops: 11,
          completedStops: 0,
          gallonsCollected: 0.0,
        ),
        const RouteModel(
          id: 'r12',
          name: 'Route 12 — CO Natl Monument',
          driverName: 'Danielle Park',
          driverStatus: DriverStatus.onRoute,
          totalStops: 11,
          completedStops: 7,
          gallonsCollected: 224.0,
        ),
      ];

  // ---------------------------------------------------------------------------
  // Pickups — 124 total across 12 routes
  // ---------------------------------------------------------------------------
  static List<Pickup> getPickups() {
    final List<Pickup> pickups = [];

    // --- Route 1: Downtown GJ — Marcus Webb ---
    // 7 completed, 2 in-progress, 1 scheduled, 1 missed
    final r1 = [
      ('Rockslide Restaurant & Brewery', 'Grand Junction', '401 Main St', 7, 0, PickupStatus.completed, 38.5),
      ('Bin 707 Foodbar', 'Grand Junction', '707 Main St', 7, 25, PickupStatus.completed, 22.0),
      ('Enzo\'s Italian Restaurant', 'Grand Junction', '336 Main St', 7, 55, PickupStatus.completed, 31.0),
      ('Suehiro Restaurant', 'Grand Junction', '251 Grand Ave', 8, 20, PickupStatus.completed, 18.5),
      ('Pablo\'s Pizza — Downtown', 'Grand Junction', '319 Main St', 8, 45, PickupStatus.completed, 25.0),
      ('Taco Bell — S 7th St', 'Grand Junction', '201 S 7th St', 9, 10, PickupStatus.completed, 42.0),
      ('Blue Moon Bar & Grille', 'Grand Junction', '120 N 1st St', 9, 35, PickupStatus.completed, 41.5),
      ('Main Street Bagels', 'Grand Junction', '559 Main St', 10, 5, PickupStatus.inProgress, null),
      ('McDonald\'s — Horizon Dr', 'Grand Junction', '2424 Horizon Dr', 10, 35, PickupStatus.inProgress, null),
      ('Wendy\'s — Main St', 'Grand Junction', '1012 Main St', 11, 10, PickupStatus.scheduled, null),
      ('Starvin\' Arvin\'s — Main', 'Grand Junction', '752 Horizon Dr', 11, 40, PickupStatus.missed, null),
    ];

    // --- Route 2: North GJ — Tony Delgado ---
    // 6 completed, 2 in-progress, 2 scheduled
    final r2 = [
      ('Texas Roadhouse', 'Grand Junction', '2464 US-6', 7, 0, PickupStatus.completed, 68.0),
      ('Red Robin', 'Grand Junction', '2424 Patterson Rd', 7, 30, PickupStatus.completed, 34.0),
      ('Applebee\'s — North Ave', 'Grand Junction', '2268 North Ave', 8, 0, PickupStatus.completed, 47.5),
      ('Olive Garden — North Ave', 'Grand Junction', '2458 North Ave', 8, 30, PickupStatus.completed, 52.0),
      ('IHOP — North Ave', 'Grand Junction', '2314 North Ave', 9, 5, PickupStatus.completed, 29.0),
      ('Chili\'s — North Ave', 'Grand Junction', '2502 North Ave', 9, 35, PickupStatus.completed, 41.5),
      ('Qdoba Mexican Eats', 'Grand Junction', '2610 North Ave', 10, 10, PickupStatus.inProgress, null),
      ('Five Guys — North GJ', 'Grand Junction', '2700 Crossroads Blvd', 10, 45, PickupStatus.inProgress, null),
      ('Panda Express — 24 Rd', 'Grand Junction', '609 24 Rd', 11, 15, PickupStatus.scheduled, null),
      ('Denny\'s — 24 Rd', 'Grand Junction', '589 24 Rd', 11, 50, PickupStatus.scheduled, null),
    ];

    // --- Route 3: East GJ / Clifton — Sarah Kim (on break) ---
    // 7 completed, 0 in-progress, 4 scheduled
    final r3 = [
      ('Kannah Creek Brewing', 'Grand Junction', '1960 N 12th St', 7, 0, PickupStatus.completed, 28.0),
      ('Los Reyes Mexican Grill', 'Clifton', '3226 F Rd', 7, 30, PickupStatus.completed, 33.5),
      ('Burger King — G Rd', 'Clifton', '3141 G Rd', 8, 5, PickupStatus.completed, 45.0),
      ('KFC — Clifton', 'Clifton', '3178 F Rd', 8, 35, PickupStatus.completed, 38.0),
      ('Pizza Hut — Clifton', 'Clifton', '3248 F Rd', 9, 0, PickupStatus.completed, 27.5),
      ('Sonic Drive-In — Clifton', 'Clifton', '3212 G Rd', 9, 30, PickupStatus.completed, 31.0),
      ('Jack in the Box — Clifton', 'Clifton', '3174 G Rd', 10, 0, PickupStatus.completed, 28.0),
      ('Panera Bread — Mesa Mall', 'Grand Junction', '2424 US-6', 10, 35, PickupStatus.scheduled, null),
      ('Domino\'s — Mesa Mall', 'Grand Junction', '2462 US-6', 11, 5, PickupStatus.scheduled, null),
      ('Subway — F Rd', 'Clifton', '3190 F Rd', 11, 35, PickupStatus.scheduled, null),
      ('Waffle House — Clifton', 'Clifton', '3255 F Rd', 12, 5, PickupStatus.scheduled, null),
    ];

    // --- Route 4: West GJ / Fruita — Jake Morrison ---
    // 5 completed, 2 in-progress, 3 scheduled
    final r4 = [
      ('Hot Tomato Restaurant — Fruita', 'Fruita', '124 N Mulberry St', 7, 0, PickupStatus.completed, 19.5),
      ('Rib City Grill — Fruita', 'Fruita', '340 Hwy 6-50', 7, 35, PickupStatus.completed, 36.0),
      ('McDonald\'s — Fruita', 'Fruita', '516 Hwy 6-50', 8, 10, PickupStatus.completed, 52.5),
      ('Taco Bell — Fruita', 'Fruita', '508 Hwy 6-50', 8, 40, PickupStatus.completed, 41.0),
      ('Arby\'s — Fruita', 'Fruita', '492 Hwy 6-50', 9, 10, PickupStatus.completed, 33.0),
      ('Subway — Fruita', 'Fruita', '482 Hwy 6-50', 9, 45, PickupStatus.inProgress, null),
      ('Pizza Hut — Fruita', 'Fruita', '468 Hwy 6-50', 10, 20, PickupStatus.inProgress, null),
      ('Wendy\'s — Fruita', 'Fruita', '455 Hwy 6-50', 10, 55, PickupStatus.scheduled, null),
      ('Fruita Juice & Java', 'Fruita', '137 N Plum St', 11, 30, PickupStatus.scheduled, null),
      ('Taco Party — Fruita', 'Fruita', '211 E Aspen Ave', 12, 0, PickupStatus.scheduled, null),
    ];

    // --- Route 5: Montrose — Carlos Rivera (returning) ---
    // 8 completed, 0 in-progress, 1 scheduled, 1 missed
    final r5 = [
      ('Horsefly Brewing Company', 'Montrose', '846 E Main St', 6, 30, PickupStatus.completed, 24.5),
      ('Colorado Boy Pizza & Brewery', 'Montrose', '322 W Main St', 7, 0, PickupStatus.completed, 31.0),
      ('La Playa Mexican Restaurant', 'Montrose', '1904 S Townsend Ave', 7, 35, PickupStatus.completed, 38.5),
      ('Fiesta Guadalajara', 'Montrose', '230 S Townsend Ave', 8, 10, PickupStatus.completed, 34.0),
      ('Starvin\' Arvin\'s — Montrose', 'Montrose', '1809 E Main St', 8, 45, PickupStatus.completed, 27.0),
      ('McDonald\'s — Montrose', 'Montrose', '1920 S Townsend Ave', 9, 15, PickupStatus.completed, 55.5),
      ('Subway — Montrose', 'Montrose', '840 S Townsend Ave', 9, 45, PickupStatus.completed, 22.0),
      ('Domino\'s — Montrose', 'Montrose', '215 N Townsend Ave', 10, 15, PickupStatus.completed, 38.0),
      ('KFC — Montrose', 'Montrose', '1930 S Townsend Ave', 11, 0, PickupStatus.scheduled, null),
      ('Kannah Creek Taphouse — Montrose', 'Montrose', '916 Main St', 11, 40, PickupStatus.missed, null),
    ];

    // --- Route 6: Delta — Amy Chen ---
    // 5 completed, 2 in-progress, 2 scheduled
    final r6 = [
      ('Delta Brewing Company', 'Delta', '221 Main St', 7, 0, PickupStatus.completed, 22.0),
      ('El Tapatio Mexican Restaurant', 'Delta', '648 Main St', 7, 35, PickupStatus.completed, 29.5),
      ('Garlic Mike\'s Restaurant', 'Delta', '122 Grand Ave', 8, 10, PickupStatus.completed, 18.5),
      ('McDonald\'s — Delta', 'Delta', '680 Main St', 8, 45, PickupStatus.completed, 48.0),
      ('Subway — Delta', 'Delta', '668 Main St', 9, 20, PickupStatus.completed, 21.0),
      ('Pizza Hut — Delta', 'Delta', '650 Main St', 9, 55, PickupStatus.inProgress, null),
      ('Taco Bell — Delta', 'Delta', '640 Main St', 10, 30, PickupStatus.inProgress, null),
      ('China Garden — Delta', 'Delta', '310 Main St', 11, 5, PickupStatus.scheduled, null),
      ('Siri\'s Thai Restaurant — Delta', 'Delta', '185 Main St', 11, 40, PickupStatus.scheduled, null),
    ];

    // --- Route 7: Glenwood Springs — Derek Thompson ---
    // 6 completed, 2 in-progress, 3 scheduled
    final r7 = [
      ('Glenwood Canyon Brewpub', 'Glenwood Springs', '402 7th St', 6, 30, PickupStatus.completed, 31.5),
      ('The Pullman Restaurant', 'Glenwood Springs', '330 7th St', 7, 5, PickupStatus.completed, 24.0),
      ('Italian Underground', 'Glenwood Springs', '715 Grand Ave', 7, 40, PickupStatus.completed, 28.5),
      ('Smoke Modern BBQ', 'Glenwood Springs', '106 W 6th St', 8, 15, PickupStatus.completed, 22.0),
      ('McDonald\'s — Glenwood Spgs', 'Glenwood Springs', '51 Mel Rey Rd', 8, 50, PickupStatus.completed, 54.0),
      ('Subway — Glenwood Spgs', 'Glenwood Springs', '110 W 6th St', 9, 25, PickupStatus.completed, 20.0),
      ('Florindo\'s Italian Cuisine', 'Glenwood Springs', '721 Grand Ave', 10, 0, PickupStatus.inProgress, null),
      ('Wendy\'s — Glenwood Spgs', 'Glenwood Springs', '85 Mel Rey Rd', 10, 35, PickupStatus.inProgress, null),
      ('Taco Bell — Glenwood Spgs', 'Glenwood Springs', '105 Mel Rey Rd', 11, 10, PickupStatus.scheduled, null),
      ('Pizza Hut — Glenwood Spgs', 'Glenwood Springs', '97 Mel Rey Rd', 11, 45, PickupStatus.scheduled, null),
      ('Domino\'s — Glenwood Spgs', 'Glenwood Springs', '2020 Grand Ave', 12, 15, PickupStatus.scheduled, null),
    ];

    // --- Route 8: Rifle — Lisa Nakamura (on break) ---
    // 6 completed, 0 in-progress, 4 scheduled
    final r8 = [
      ('The Rustic Café — Rifle', 'Rifle', '114 E 3rd St', 7, 0, PickupStatus.completed, 18.0),
      ('Wok This Way — Rifle', 'Rifle', '218 Railroad Ave', 7, 35, PickupStatus.completed, 21.5),
      ('Shooters Bar & Grill — Rifle', 'Rifle', '310 E 3rd St', 8, 10, PickupStatus.completed, 29.0),
      ('McDonald\'s — Rifle', 'Rifle', '1375 Railroad Ave', 8, 45, PickupStatus.completed, 51.0),
      ('Subway — Rifle', 'Rifle', '1360 Railroad Ave', 9, 20, PickupStatus.completed, 19.5),
      ('Wendy\'s — Rifle', 'Rifle', '1380 Railroad Ave', 9, 55, PickupStatus.completed, 49.0),
      ('KFC — Rifle', 'Rifle', '1350 Railroad Ave', 10, 30, PickupStatus.scheduled, null),
      ('Arby\'s — Rifle', 'Rifle', '1340 Railroad Ave', 11, 5, PickupStatus.scheduled, null),
      ('Sonic — Rifle', 'Rifle', '1320 Railroad Ave', 11, 40, PickupStatus.scheduled, null),
      ('Pizza Hut — Rifle', 'Rifle', '1310 Railroad Ave', 12, 15, PickupStatus.scheduled, null),
    ];

    // --- Route 9: Moab, UT — Brandon Scott (returning) ---
    // 7 completed, 0 in-progress, 1 scheduled, 1 missed
    final r9 = [
      ('Moab Brewery', 'Moab, UT', '686 S Main St', 6, 0, PickupStatus.completed, 28.0),
      ('Desert Bistro', 'Moab, UT', '36 S 100 W', 6, 40, PickupStatus.completed, 22.5),
      ('Pasta Jay\'s — Moab', 'Moab, UT', '4 S 100 W', 7, 20, PickupStatus.completed, 19.0),
      ('Milt\'s Stop & Eat', 'Moab, UT', '356 Mill Creek Dr', 8, 0, PickupStatus.completed, 16.5),
      ('McDonald\'s — Moab', 'Moab, UT', '880 N Main St', 8, 40, PickupStatus.completed, 52.0),
      ('Subway — Moab', 'Moab, UT', '890 N Main St', 9, 20, PickupStatus.completed, 18.0),
      ('Denny\'s — Moab', 'Moab, UT', '1510 N Hwy 191', 10, 0, PickupStatus.completed, 33.0),
      ('Burger King — Moab', 'Moab, UT', '815 N Main St', 11, 0, PickupStatus.scheduled, null),
      ('Pizza Hut — Moab', 'Moab, UT', '840 N Main St', 11, 45, PickupStatus.missed, null),
    ];

    // --- Route 10: Grand Valley Loop — Rachel Flores ---
    // 6 completed, 2 in-progress, 2 scheduled, 1 missed
    final r10 = [
      ('Palisade Brewing Co.', 'Palisade', '200 Kluge Ave', 7, 0, PickupStatus.completed, 24.0),
      ('Canyon Wind Cellars', 'Palisade', '3907 N River Rd', 7, 40, PickupStatus.completed, 12.0),
      ('La Barrita Mexican — Palisade', 'Palisade', '128 W 3rd St', 8, 20, PickupStatus.completed, 26.5),
      ('Two Rivers Winery', 'Grand Junction', '2087 Broadway', 9, 0, PickupStatus.completed, 14.0),
      ('McDonald\'s — Palisade', 'Palisade', '385 Hwy 6-50', 9, 35, PickupStatus.completed, 48.0),
      ('Taco Bell — Palisade', 'Palisade', '370 Hwy 6-50', 10, 10, PickupStatus.completed, 39.0),
      ('Subway — Loma', 'Loma', '650 Hwy 6-50', 10, 45, PickupStatus.inProgress, null),
      ('Sonic — Palisade', 'Palisade', '355 Hwy 6-50', 11, 20, PickupStatus.inProgress, null),
      ('Burger King — Palisade', 'Palisade', '340 Hwy 6-50', 11, 55, PickupStatus.scheduled, null),
      ('KFC — Palisade', 'Palisade', '325 Hwy 6-50', 12, 30, PickupStatus.scheduled, null),
      ('Tacoparty — Grand Valley', 'Grand Junction', '316 Main St', 13, 0, PickupStatus.missed, null),
    ];

    // --- Route 11: I-70 Corridor — Mike O'Brien (off duty) ---
    // 0 completed, 0 in-progress, 11 scheduled
    final r11 = [
      ('Debeque Diner', 'De Beque', '110 Main St', 8, 0, PickupStatus.scheduled, null),
      ('Parachute Steakhouse', 'Parachute', '212 1st St', 8, 45, PickupStatus.scheduled, null),
      ('Battlement Mesa Grill', 'Parachute', '400 Battlement Pkwy', 9, 30, PickupStatus.scheduled, null),
      ('McDonald\'s — Parachute', 'Parachute', '260 Green St', 10, 15, PickupStatus.scheduled, null),
      ('Subway — Parachute', 'Parachute', '252 Green St', 11, 0, PickupStatus.scheduled, null),
      ('Pizza Hut — Parachute', 'Parachute', '242 Green St', 11, 45, PickupStatus.scheduled, null),
      ('Sonic — Parachute', 'Parachute', '230 Green St', 12, 30, PickupStatus.scheduled, null),
      ('Arby\'s — Parachute', 'Parachute', '220 Green St', 13, 15, PickupStatus.scheduled, null),
      ('Domino\'s — Battlement Mesa', 'Parachute', '395 Battlement Pkwy', 14, 0, PickupStatus.scheduled, null),
      ('Taco Bell — Parachute', 'Parachute', '210 Green St', 14, 45, PickupStatus.scheduled, null),
      ('KFC — Grand Valley', 'De Beque', '125 Main St', 15, 30, PickupStatus.scheduled, null),
    ];

    // --- Route 12: CO Natl Monument Area — Danielle Park ---
    // 7 completed, 2 in-progress, 1 scheduled, 1 missed
    final r12 = [
      ('Monument Café — Fruita', 'Fruita', '239 S Mulberry St', 7, 0, PickupStatus.completed, 21.0),
      ('Desert Rose Restaurant', 'Fruita', '115 W Aspen Ave', 7, 35, PickupStatus.completed, 18.5),
      ('La Frontera Mexican — Fruita', 'Fruita', '326 Hwy 6-50', 8, 10, PickupStatus.completed, 32.0),
      ('Mike\'s Kitchen — Fruita', 'Fruita', '142 E Ottley Ave', 8, 45, PickupStatus.completed, 24.0),
      ('McDonald\'s — Monument Rd', 'Fruita', '510 Hwy 340', 9, 20, PickupStatus.completed, 53.0),
      ('Subway — Fruita West', 'Fruita', '495 Hwy 340', 9, 55, PickupStatus.completed, 20.0),
      ('Wendy\'s — Monument Rd', 'Fruita', '480 Hwy 340', 10, 30, PickupStatus.completed, 38.0),
      ('Pizza Hut — Fruita NM', 'Fruita', '465 Hwy 340', 11, 5, PickupStatus.inProgress, null),
      ('Taco Bell — Fruita West', 'Fruita', '450 Hwy 340', 11, 40, PickupStatus.inProgress, null),
      ('Sonic — NM Gate Area', 'Fruita', '435 Hwy 340', 12, 15, PickupStatus.scheduled, null),
      ('Arby\'s — Monument Blvd', 'Fruita', '420 Hwy 340', 13, 0, PickupStatus.missed, null),
    ];

    int pid = 1;

    void addPickups(
      List<(String, String, String, int, int, PickupStatus, double?)> stops,
      String routeId,
      String routeName,
      String driverName,
    ) {
      for (final s in stops) {
        final scheduledTime = _time(s.$4, s.$5);
        pickups.add(Pickup(
          id: 'p${pid.toString().padLeft(3, '0')}',
          locationName: s.$1,
          city: s.$2,
          address: s.$3,
          scheduledTime: scheduledTime,
          completedTime: s.$6 == PickupStatus.completed
              ? scheduledTime.add(const Duration(minutes: 15))
              : null,
          status: s.$6,
          volumeGallons: s.$7,
          driverName: driverName,
          routeId: routeId,
          routeName: routeName,
        ));
        pid++;
      }
    }

    addPickups(r1, 'r01', 'Route 1 — Downtown GJ', 'Marcus Webb');
    addPickups(r2, 'r02', 'Route 2 — North GJ', 'Tony Delgado');
    addPickups(r3, 'r03', 'Route 3 — East GJ / Clifton', 'Sarah Kim');
    addPickups(r4, 'r04', 'Route 4 — West GJ / Fruita', 'Jake Morrison');
    addPickups(r5, 'r05', 'Route 5 — Montrose', 'Carlos Rivera');
    addPickups(r6, 'r06', 'Route 6 — Delta', 'Amy Chen');
    addPickups(r7, 'r07', 'Route 7 — Glenwood Springs', 'Derek Thompson');
    addPickups(r8, 'r08', 'Route 8 — Rifle', 'Lisa Nakamura');
    addPickups(r9, 'r09', 'Route 9 — Moab, UT', 'Brandon Scott');
    addPickups(r10, 'r10', 'Route 10 — Grand Valley Loop', 'Rachel Flores');
    addPickups(r11, 'r11', 'Route 11 — I-70 Corridor', "Mike O'Brien");
    addPickups(r12, 'r12', 'Route 12 — CO Natl Monument', 'Danielle Park');

    return pickups;
  }

  // ---------------------------------------------------------------------------
  // Trades — 16 total
  // ---------------------------------------------------------------------------
  static List<Trade> getTrades() => [
        Trade(
          id: 'T-2604-001',
          type: TradeType.sell,
          commodity: CommodityType.uco,
          volumeLbs: 150000,
          pricePerLb: 0.487,
          counterparty: 'Diamond Green Diesel',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 17),
        ),
        Trade(
          id: 'T-2604-002',
          type: TradeType.buy,
          commodity: CommodityType.uco,
          volumeLbs: 85000,
          pricePerLb: 0.421,
          counterparty: 'Mountain West Collectors',
          status: TradeStatus.settled,
          tradeDate: DateTime(2026, 4, 10),
        ),
        Trade(
          id: 'T-2604-003',
          type: TradeType.sell,
          commodity: CommodityType.yellowGrease,
          volumeLbs: 200000,
          pricePerLb: 0.392,
          counterparty: 'Crimson Renewable Energy',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 18),
        ),
        Trade(
          id: 'T-2604-004',
          type: TradeType.buy,
          commodity: CommodityType.uco,
          volumeLbs: 120000,
          pricePerLb: 0.439,
          counterparty: 'Colorado Grease Co.',
          status: TradeStatus.pendingSettlement,
          tradeDate: DateTime(2026, 4, 14),
        ),
        Trade(
          id: 'T-2604-005',
          type: TradeType.sell,
          commodity: CommodityType.tallow,
          volumeLbs: 75000,
          pricePerLb: 0.551,
          counterparty: 'Renewable Energy Group',
          status: TradeStatus.settled,
          tradeDate: DateTime(2026, 4, 8),
        ),
        Trade(
          id: 'T-2604-006',
          type: TradeType.buy,
          commodity: CommodityType.yellowGrease,
          volumeLbs: 95000,
          pricePerLb: 0.358,
          counterparty: 'Western Slope Renderers',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 16),
        ),
        Trade(
          id: 'T-2604-007',
          type: TradeType.sell,
          commodity: CommodityType.uco,
          volumeLbs: 180000,
          pricePerLb: 0.502,
          counterparty: 'Pacific Coast Energy',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 19),
        ),
        Trade(
          id: 'T-2604-008',
          type: TradeType.buy,
          commodity: CommodityType.tallow,
          volumeLbs: 60000,
          pricePerLb: 0.478,
          counterparty: 'Four Corners Rendering',
          status: TradeStatus.settled,
          tradeDate: DateTime(2026, 4, 7),
        ),
        Trade(
          id: 'T-2604-009',
          type: TradeType.sell,
          commodity: CommodityType.uco,
          volumeLbs: 100000,
          pricePerLb: 0.461,
          counterparty: 'World Energy',
          status: TradeStatus.pendingSettlement,
          tradeDate: DateTime(2026, 4, 15),
        ),
        Trade(
          id: 'T-2604-010',
          type: TradeType.buy,
          commodity: CommodityType.uco,
          volumeLbs: 140000,
          pricePerLb: 0.445,
          counterparty: 'Utah Valley Grease',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 18),
        ),
        Trade(
          id: 'T-2604-011',
          type: TradeType.sell,
          commodity: CommodityType.yellowGrease,
          volumeLbs: 160000,
          pricePerLb: 0.401,
          counterparty: 'Valero Renewables',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 17),
        ),
        Trade(
          id: 'T-2604-012',
          type: TradeType.buy,
          commodity: CommodityType.uco,
          volumeLbs: 70000,
          pricePerLb: 0.432,
          counterparty: 'Grand Mesa Collectors',
          status: TradeStatus.settled,
          tradeDate: DateTime(2026, 4, 9),
        ),
        Trade(
          id: 'T-2604-013',
          type: TradeType.sell,
          commodity: CommodityType.tallow,
          volumeLbs: 90000,
          pricePerLb: 0.574,
          counterparty: 'ADM Renewables',
          status: TradeStatus.pendingSettlement,
          tradeDate: DateTime(2026, 4, 16),
        ),
        Trade(
          id: 'T-2604-014',
          type: TradeType.buy,
          commodity: CommodityType.yellowGrease,
          volumeLbs: 110000,
          pricePerLb: 0.371,
          counterparty: 'Rocky Mountain Grease',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 19),
        ),
        Trade(
          id: 'T-2604-015',
          type: TradeType.sell,
          commodity: CommodityType.uco,
          volumeLbs: 220000,
          pricePerLb: 0.493,
          counterparty: 'Diamond Green Diesel',
          status: TradeStatus.open,
          tradeDate: DateTime(2026, 4, 19),
        ),
        Trade(
          id: 'T-2604-016',
          type: TradeType.buy,
          commodity: CommodityType.uco,
          volumeLbs: 165000,
          pricePerLb: 0.449,
          counterparty: 'Southwest Grease Trading',
          status: TradeStatus.settled,
          tradeDate: DateTime(2026, 4, 11),
        ),
      ];

  // ---------------------------------------------------------------------------
  // Daily Volumes — 28 days ending today
  // ---------------------------------------------------------------------------
  static List<DailyVolume> getDailyVolumes() {
    final data = [
      // (days ago, gallons) — day 27 = oldest, day 0 = today (partial)
      (27, 1940), // Mon Mar 23
      (26, 2010), // Tue Mar 24
      (25, 1980), // Wed Mar 25
      (24, 2090), // Thu Mar 26
      (23, 2180), // Fri Mar 27
      (22, 870),  // Sat Mar 28
      (21, 430),  // Sun Mar 29
      (20, 1960), // Mon Mar 30
      (19, 2020), // Tue Mar 31
      (18, 2090), // Wed Apr 1
      (17, 2140), // Thu Apr 2
      (16, 2310), // Fri Apr 3
      (15, 950),  // Sat Apr 4
      (14, 380),  // Sun Apr 5
      (13, 2000), // Mon Apr 6
      (12, 2120), // Tue Apr 7
      (11, 2050), // Wed Apr 8
      (10, 2190), // Thu Apr 9
      (9, 2280),  // Fri Apr 10
      (8, 890),   // Sat Apr 11
      (7, 410),   // Sun Apr 12
      (6, 1980),  // Mon Apr 13
      (5, 2150),  // Tue Apr 14
      (4, 2210),  // Wed Apr 15
      (3, 2340),  // Thu Apr 16
      (2, 2180),  // Fri Apr 17
      (1, 820),   // Sat Apr 18
      (0, 1847),  // Sun Apr 19 (today, partial)
    ];

    return data
        .map((e) => DailyVolume(
              date: _today.subtract(Duration(days: e.$1)),
              gallons: e.$2,
            ))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Commodity Prices (baseline)
  // ---------------------------------------------------------------------------
  static List<CommodityPrice> getCommodityPrices() => [
        const CommodityPrice(name: 'UCO', pricePerLb: 0.487, change: 0.003),
        const CommodityPrice(name: 'Yellow Grease', pricePerLb: 0.392, change: -0.002),
        const CommodityPrice(name: 'Tallow', pricePerLb: 0.553, change: 0.005),
      ];
}
