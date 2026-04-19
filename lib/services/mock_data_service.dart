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
  // Routes — 24 total
  // ---------------------------------------------------------------------------
  static List<RouteModel> getRoutes() => [
        // ---- Original 12 ----
        const RouteModel(id: 'r01', name: 'Route 1 — Downtown GJ', driverName: 'Marcus Webb', driverStatus: DriverStatus.onRoute, totalStops: 11, completedStops: 7, gallonsCollected: 218.5),
        const RouteModel(id: 'r02', name: 'Route 2 — North GJ', driverName: 'Tony Delgado', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 6, gallonsCollected: 195.0),
        const RouteModel(id: 'r03', name: 'Route 3 — East GJ / Clifton', driverName: 'Sarah Kim', driverStatus: DriverStatus.onBreak, totalStops: 11, completedStops: 7, gallonsCollected: 231.0),
        const RouteModel(id: 'r04', name: 'Route 4 — West GJ / Fruita', driverName: 'Jake Morrison', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 5, gallonsCollected: 162.0),
        const RouteModel(id: 'r05', name: 'Route 5 — Montrose', driverName: 'Carlos Rivera', driverStatus: DriverStatus.returning, totalStops: 10, completedStops: 8, gallonsCollected: 270.5),
        const RouteModel(id: 'r06', name: 'Route 6 — Delta', driverName: 'Amy Chen', driverStatus: DriverStatus.onRoute, totalStops: 9, completedStops: 5, gallonsCollected: 148.0),
        const RouteModel(id: 'r07', name: 'Route 7 — Glenwood Springs', driverName: 'Derek Thompson', driverStatus: DriverStatus.onRoute, totalStops: 11, completedStops: 6, gallonsCollected: 203.5),
        const RouteModel(id: 'r08', name: 'Route 8 — Rifle', driverName: 'Lisa Nakamura', driverStatus: DriverStatus.onBreak, totalStops: 10, completedStops: 6, gallonsCollected: 188.0),
        const RouteModel(id: 'r09', name: 'Route 9 — Moab, UT', driverName: 'Brandon Scott', driverStatus: DriverStatus.returning, totalStops: 9, completedStops: 7, gallonsCollected: 222.0),
        const RouteModel(id: 'r10', name: 'Route 10 — Grand Valley Loop', driverName: 'Rachel Flores', driverStatus: DriverStatus.onRoute, totalStops: 11, completedStops: 6, gallonsCollected: 185.5),
        const RouteModel(id: 'r11', name: "Route 11 — I-70 Corridor", driverName: "Mike O'Brien", driverStatus: DriverStatus.offDuty, totalStops: 11, completedStops: 0, gallonsCollected: 0.0),
        const RouteModel(id: 'r12', name: 'Route 12 — CO Natl Monument', driverName: 'Danielle Park', driverStatus: DriverStatus.onRoute, totalStops: 11, completedStops: 7, gallonsCollected: 224.0),
        // ---- New 12 ----
        const RouteModel(id: 'r13', name: 'Route 13 — Durango', driverName: 'James Carter', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 5, gallonsCollected: 140.0),
        const RouteModel(id: 'r14', name: 'Route 14 — Cortez / Four Corners', driverName: 'Nicole Rodriguez', driverStatus: DriverStatus.onRoute, totalStops: 11, completedStops: 4, gallonsCollected: 120.0),
        const RouteModel(id: 'r15', name: 'Route 15 — Hotchkiss / Paonia', driverName: 'David Kim', driverStatus: DriverStatus.returning, totalStops: 11, completedStops: 9, gallonsCollected: 243.0),
        const RouteModel(id: 'r16', name: 'Route 16 — Steamboat Springs', driverName: 'Tiffany Walsh', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 5, gallonsCollected: 125.0),
        const RouteModel(id: 'r17', name: 'Route 17 — Craig / Hayden', driverName: 'Robert Martinez', driverStatus: DriverStatus.onBreak, totalStops: 11, completedStops: 6, gallonsCollected: 174.0),
        const RouteModel(id: 'r18', name: 'Route 18 — Vernal, UT', driverName: 'Keisha Johnson', driverStatus: DriverStatus.returning, totalStops: 10, completedStops: 8, gallonsCollected: 208.0),
        const RouteModel(id: 'r19', name: 'Route 19 — Price / Helper, UT', driverName: 'Chris Anderson', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 4, gallonsCollected: 112.0),
        const RouteModel(id: 'r20', name: 'Route 20 — Rangely / Meeker', driverName: 'Maria Gonzalez', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 5, gallonsCollected: 135.0),
        const RouteModel(id: 'r21', name: 'Route 21 — Aspen / Carbondale', driverName: 'Steve Brown', driverStatus: DriverStatus.onBreak, totalStops: 10, completedStops: 4, gallonsCollected: 96.0),
        const RouteModel(id: 'r22', name: 'Route 22 — Silt / New Castle', driverName: 'Amber Williams', driverStatus: DriverStatus.onRoute, totalStops: 10, completedStops: 5, gallonsCollected: 140.0),
        const RouteModel(id: 'r23', name: 'Route 23 — Palisade Extended', driverName: 'Kevin Lee', driverStatus: DriverStatus.returning, totalStops: 10, completedStops: 7, gallonsCollected: 182.0),
        const RouteModel(id: 'r24', name: 'Route 24 — GJ Industrial', driverName: 'Sandra Thompson', driverStatus: DriverStatus.offDuty, totalStops: 11, completedStops: 0, gallonsCollected: 0.0),
      ];

  // ---------------------------------------------------------------------------
  // Pickups — 248 total
  // ---------------------------------------------------------------------------
  static List<Pickup> getPickups() {
    final List<Pickup> pickups = [];
    int pid = 1;

    void add(
      List<(String, String, String, int, int, PickupStatus, double?)> stops,
      String routeId,
      String routeName,
      String driverName,
    ) {
      for (final s in stops) {
        final t = _time(s.$4, s.$5);
        pickups.add(Pickup(
          id: 'p${pid.toString().padLeft(3, '0')}',
          locationName: s.$1,
          city: s.$2,
          address: s.$3,
          scheduledTime: t,
          completedTime: s.$6 == PickupStatus.completed
              ? t.add(const Duration(minutes: 15))
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

    // Route 1 — Downtown GJ — Marcus Webb
    add([
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
    ], 'r01', 'Route 1 — Downtown GJ', 'Marcus Webb');

    // Route 2 — North GJ — Tony Delgado
    add([
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
    ], 'r02', 'Route 2 — North GJ', 'Tony Delgado');

    // Route 3 — East GJ / Clifton — Sarah Kim
    add([
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
    ], 'r03', 'Route 3 — East GJ / Clifton', 'Sarah Kim');

    // Route 4 — West GJ / Fruita — Jake Morrison
    add([
      ('Hot Tomato Restaurant', 'Fruita', '124 N Mulberry St', 7, 0, PickupStatus.completed, 19.5),
      ('Rib City Grill — Fruita', 'Fruita', '340 Hwy 6-50', 7, 35, PickupStatus.completed, 36.0),
      ('McDonald\'s — Fruita', 'Fruita', '516 Hwy 6-50', 8, 10, PickupStatus.completed, 52.5),
      ('Taco Bell — Fruita', 'Fruita', '508 Hwy 6-50', 8, 40, PickupStatus.completed, 41.0),
      ('Arby\'s — Fruita', 'Fruita', '492 Hwy 6-50', 9, 10, PickupStatus.completed, 33.0),
      ('Subway — Fruita', 'Fruita', '482 Hwy 6-50', 9, 45, PickupStatus.inProgress, null),
      ('Pizza Hut — Fruita', 'Fruita', '468 Hwy 6-50', 10, 20, PickupStatus.inProgress, null),
      ('Wendy\'s — Fruita', 'Fruita', '455 Hwy 6-50', 10, 55, PickupStatus.scheduled, null),
      ('Fruita Juice & Java', 'Fruita', '137 N Plum St', 11, 30, PickupStatus.scheduled, null),
      ('Taco Party — Fruita', 'Fruita', '211 E Aspen Ave', 12, 0, PickupStatus.scheduled, null),
    ], 'r04', 'Route 4 — West GJ / Fruita', 'Jake Morrison');

    // Route 5 — Montrose — Carlos Rivera
    add([
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
    ], 'r05', 'Route 5 — Montrose', 'Carlos Rivera');

    // Route 6 — Delta — Amy Chen
    add([
      ('Delta Brewing Company', 'Delta', '221 Main St', 7, 0, PickupStatus.completed, 22.0),
      ('El Tapatio Mexican Restaurant', 'Delta', '648 Main St', 7, 35, PickupStatus.completed, 29.5),
      ('Garlic Mike\'s Restaurant', 'Delta', '122 Grand Ave', 8, 10, PickupStatus.completed, 18.5),
      ('McDonald\'s — Delta', 'Delta', '680 Main St', 8, 45, PickupStatus.completed, 48.0),
      ('Subway — Delta', 'Delta', '668 Main St', 9, 20, PickupStatus.completed, 21.0),
      ('Pizza Hut — Delta', 'Delta', '650 Main St', 9, 55, PickupStatus.inProgress, null),
      ('Taco Bell — Delta', 'Delta', '640 Main St', 10, 30, PickupStatus.inProgress, null),
      ('China Garden — Delta', 'Delta', '310 Main St', 11, 5, PickupStatus.scheduled, null),
      ('Siri\'s Thai Restaurant', 'Delta', '185 Main St', 11, 40, PickupStatus.scheduled, null),
    ], 'r06', 'Route 6 — Delta', 'Amy Chen');

    // Route 7 — Glenwood Springs — Derek Thompson
    add([
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
    ], 'r07', 'Route 7 — Glenwood Springs', 'Derek Thompson');

    // Route 8 — Rifle — Lisa Nakamura
    add([
      ('The Rustic Café — Rifle', 'Rifle', '114 E 3rd St', 7, 0, PickupStatus.completed, 18.0),
      ('Wok This Way — Rifle', 'Rifle', '218 Railroad Ave', 7, 35, PickupStatus.completed, 21.5),
      ('Shooters Bar & Grill', 'Rifle', '310 E 3rd St', 8, 10, PickupStatus.completed, 29.0),
      ('McDonald\'s — Rifle', 'Rifle', '1375 Railroad Ave', 8, 45, PickupStatus.completed, 51.0),
      ('Subway — Rifle', 'Rifle', '1360 Railroad Ave', 9, 20, PickupStatus.completed, 19.5),
      ('Wendy\'s — Rifle', 'Rifle', '1380 Railroad Ave', 9, 55, PickupStatus.completed, 49.0),
      ('KFC — Rifle', 'Rifle', '1350 Railroad Ave', 10, 30, PickupStatus.scheduled, null),
      ('Arby\'s — Rifle', 'Rifle', '1340 Railroad Ave', 11, 5, PickupStatus.scheduled, null),
      ('Sonic — Rifle', 'Rifle', '1320 Railroad Ave', 11, 40, PickupStatus.scheduled, null),
      ('Pizza Hut — Rifle', 'Rifle', '1310 Railroad Ave', 12, 15, PickupStatus.scheduled, null),
    ], 'r08', 'Route 8 — Rifle', 'Lisa Nakamura');

    // Route 9 — Moab UT — Brandon Scott
    add([
      ('Moab Brewery', 'Moab, UT', '686 S Main St', 6, 0, PickupStatus.completed, 28.0),
      ('Desert Bistro', 'Moab, UT', '36 S 100 W', 6, 40, PickupStatus.completed, 22.5),
      ('Pasta Jay\'s — Moab', 'Moab, UT', '4 S 100 W', 7, 20, PickupStatus.completed, 19.0),
      ('Milt\'s Stop & Eat', 'Moab, UT', '356 Mill Creek Dr', 8, 0, PickupStatus.completed, 16.5),
      ('McDonald\'s — Moab', 'Moab, UT', '880 N Main St', 8, 40, PickupStatus.completed, 52.0),
      ('Subway — Moab', 'Moab, UT', '890 N Main St', 9, 20, PickupStatus.completed, 18.0),
      ('Denny\'s — Moab', 'Moab, UT', '1510 N Hwy 191', 10, 0, PickupStatus.completed, 33.0),
      ('Burger King — Moab', 'Moab, UT', '815 N Main St', 11, 0, PickupStatus.scheduled, null),
      ('Pizza Hut — Moab', 'Moab, UT', '840 N Main St', 11, 45, PickupStatus.missed, null),
    ], 'r09', 'Route 9 — Moab, UT', 'Brandon Scott');

    // Route 10 — Grand Valley Loop — Rachel Flores
    add([
      ('Palisade Brewing Co.', 'Palisade', '200 Kluge Ave', 7, 0, PickupStatus.completed, 24.0),
      ('Canyon Wind Cellars', 'Palisade', '3907 N River Rd', 7, 40, PickupStatus.completed, 12.0),
      ('La Barrita Mexican', 'Palisade', '128 W 3rd St', 8, 20, PickupStatus.completed, 26.5),
      ('Two Rivers Winery', 'Grand Junction', '2087 Broadway', 9, 0, PickupStatus.completed, 14.0),
      ('McDonald\'s — Palisade', 'Palisade', '385 Hwy 6-50', 9, 35, PickupStatus.completed, 48.0),
      ('Taco Bell — Palisade', 'Palisade', '370 Hwy 6-50', 10, 10, PickupStatus.completed, 39.0),
      ('Subway — Loma', 'Loma', '650 Hwy 6-50', 10, 45, PickupStatus.inProgress, null),
      ('Sonic — Palisade', 'Palisade', '355 Hwy 6-50', 11, 20, PickupStatus.inProgress, null),
      ('Burger King — Palisade', 'Palisade', '340 Hwy 6-50', 11, 55, PickupStatus.scheduled, null),
      ('KFC — Palisade', 'Palisade', '325 Hwy 6-50', 12, 30, PickupStatus.scheduled, null),
      ('Tacoparty — Grand Valley', 'Grand Junction', '316 Main St', 13, 0, PickupStatus.missed, null),
    ], 'r10', 'Route 10 — Grand Valley Loop', 'Rachel Flores');

    // Route 11 — I-70 Corridor — Mike O'Brien (off duty)
    add([
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
    ], 'r11', 'Route 11 — I-70 Corridor', "Mike O'Brien");

    // Route 12 — CO Natl Monument — Danielle Park
    add([
      ('Monument Café — Fruita', 'Fruita', '239 S Mulberry St', 7, 0, PickupStatus.completed, 21.0),
      ('Desert Rose Restaurant', 'Fruita', '115 W Aspen Ave', 7, 35, PickupStatus.completed, 18.5),
      ('La Frontera Mexican', 'Fruita', '326 Hwy 6-50', 8, 10, PickupStatus.completed, 32.0),
      ('Mike\'s Kitchen — Fruita', 'Fruita', '142 E Ottley Ave', 8, 45, PickupStatus.completed, 24.0),
      ('McDonald\'s — Monument Rd', 'Fruita', '510 Hwy 340', 9, 20, PickupStatus.completed, 53.0),
      ('Subway — Fruita West', 'Fruita', '495 Hwy 340', 9, 55, PickupStatus.completed, 20.0),
      ('Wendy\'s — Monument Rd', 'Fruita', '480 Hwy 340', 10, 30, PickupStatus.completed, 38.0),
      ('Pizza Hut — Fruita NM', 'Fruita', '465 Hwy 340', 11, 5, PickupStatus.inProgress, null),
      ('Taco Bell — Fruita West', 'Fruita', '450 Hwy 340', 11, 40, PickupStatus.inProgress, null),
      ('Sonic — NM Gate Area', 'Fruita', '435 Hwy 340', 12, 15, PickupStatus.scheduled, null),
      ('Arby\'s — Monument Blvd', 'Fruita', '420 Hwy 340', 13, 0, PickupStatus.missed, null),
    ], 'r12', 'Route 12 — CO Natl Monument', 'Danielle Park');

    // Route 13 — Durango — James Carter
    add([
      ('Steamworks Brewing Co.', 'Durango', '801 E 2nd Ave', 6, 30, PickupStatus.completed, 31.0),
      ('Ore House Restaurant', 'Durango', '147 E College Dr', 7, 10, PickupStatus.completed, 24.5),
      ('Ken & Sue\'s Restaurant', 'Durango', '636 Main Ave', 7, 50, PickupStatus.completed, 18.0),
      ('Guido\'s Favorite Foods', 'Durango', '711 Main Ave', 8, 30, PickupStatus.completed, 22.5),
      ('McDonald\'s — Durango', 'Durango', '2900 Main Ave', 9, 10, PickupStatus.completed, 44.0),
      ('Subway — Durango', 'Durango', '2890 Main Ave', 9, 50, PickupStatus.inProgress, null),
      ('Pizza Hut — Durango', 'Durango', '2860 Main Ave', 10, 30, PickupStatus.inProgress, null),
      ('Taco Bell — Durango', 'Durango', '2840 Main Ave', 11, 10, PickupStatus.scheduled, null),
      ('KFC — Durango', 'Durango', '2820 Main Ave', 11, 50, PickupStatus.scheduled, null),
      ('Sonic — Durango', 'Durango', '2800 Main Ave', 12, 30, PickupStatus.missed, null),
    ], 'r13', 'Route 13 — Durango', 'James Carter');

    // Route 14 — Cortez / Four Corners — Nicole Rodriguez
    add([
      ('Absolute Bakery & Café', 'Cortez', '110 E Main St', 6, 45, PickupStatus.completed, 14.0),
      ('Nero\'s Italian Restaurant', 'Cortez', '303 W Main St', 7, 25, PickupStatus.completed, 27.5),
      ('Pippo\'s Pizzeria', 'Cortez', '420 E Main St', 8, 5, PickupStatus.completed, 21.0),
      ('McDonald\'s — Cortez', 'Cortez', '2040 E Main St', 8, 45, PickupStatus.completed, 48.0),
      ('Subway — Cortez', 'Cortez', '2020 E Main St', 9, 25, PickupStatus.inProgress, null),
      ('Pizza Hut — Cortez', 'Cortez', '2000 E Main St', 10, 5, PickupStatus.inProgress, null),
      ('Taco Bell — Cortez', 'Cortez', '1980 E Main St', 10, 45, PickupStatus.scheduled, null),
      ('Wendy\'s — Cortez', 'Cortez', '1960 E Main St', 11, 25, PickupStatus.scheduled, null),
      ('KFC — Cortez', 'Cortez', '1940 E Main St', 12, 5, PickupStatus.scheduled, null),
      ('Sonic — Cortez', 'Cortez', '1920 E Main St', 12, 45, PickupStatus.scheduled, null),
      ('Domino\'s — Cortez', 'Cortez', '1900 E Main St', 13, 25, PickupStatus.missed, null),
    ], 'r14', 'Route 14 — Cortez / Four Corners', 'Nicole Rodriguez');

    // Route 15 — Hotchkiss / Paonia — David Kim
    add([
      ('The Fork in the Road', 'Hotchkiss', '185 Bridge St', 6, 30, PickupStatus.completed, 16.0),
      ('Paonia Brewing Co.', 'Paonia', '120 Grand Ave', 7, 10, PickupStatus.completed, 22.5),
      ('Black Bridge Brewery', 'Hotchkiss', '300 E Main St', 7, 50, PickupStatus.completed, 19.0),
      ('Crawford Store & Grill', 'Crawford', '410 Hwy 92', 8, 30, PickupStatus.completed, 14.5),
      ('McDonald\'s — Hotchkiss', 'Hotchkiss', '620 Bridge St', 9, 10, PickupStatus.completed, 42.0),
      ('Subway — Hotchkiss', 'Hotchkiss', '610 Bridge St', 9, 50, PickupStatus.completed, 18.0),
      ('Pizza Palace — Paonia', 'Paonia', '210 Grand Ave', 10, 30, PickupStatus.completed, 25.0),
      ('Domino\'s — Paonia', 'Paonia', '200 Grand Ave', 11, 10, PickupStatus.completed, 31.0),
      ('Taco Bell — Hotchkiss', 'Hotchkiss', '590 Bridge St', 11, 50, PickupStatus.completed, 29.0),
      ('Sonic — Hotchkiss', 'Hotchkiss', '580 Bridge St', 12, 30, PickupStatus.scheduled, null),
      ('KFC — Hotchkiss', 'Hotchkiss', '570 Bridge St', 13, 10, PickupStatus.missed, null),
    ], 'r15', 'Route 15 — Hotchkiss / Paonia', 'David Kim');

    // Route 16 — Steamboat Springs — Tiffany Walsh
    add([
      ('Mahogany Ridge Brewery', 'Steamboat Springs', '435 Lincoln Ave', 7, 0, PickupStatus.completed, 28.0),
      ('Mazzola\'s Italian Restaurant', 'Steamboat Springs', '917 Lincoln Ave', 7, 45, PickupStatus.completed, 21.5),
      ('The Egg & I — Steamboat', 'Steamboat Springs', '2255 Apres Ski Way', 8, 30, PickupStatus.completed, 17.0),
      ('Steamboat Smokehouse', 'Steamboat Springs', '912 Lincoln Ave', 9, 15, PickupStatus.completed, 33.0),
      ('McDonald\'s — Steamboat Spgs', 'Steamboat Springs', '1855 Central Park Dr', 10, 0, PickupStatus.completed, 51.5),
      ('Subway — Steamboat Spgs', 'Steamboat Springs', '1845 Central Park Dr', 10, 45, PickupStatus.inProgress, null),
      ('Pizza Hut — Steamboat Spgs', 'Steamboat Springs', '1835 Central Park Dr', 11, 30, PickupStatus.inProgress, null),
      ('Taco Bell — Steamboat Spgs', 'Steamboat Springs', '1825 Central Park Dr', 12, 15, PickupStatus.scheduled, null),
      ('Wendy\'s — Steamboat Spgs', 'Steamboat Springs', '1815 Central Park Dr', 13, 0, PickupStatus.scheduled, null),
      ('KFC — Steamboat Spgs', 'Steamboat Springs', '1805 Central Park Dr', 13, 45, PickupStatus.scheduled, null),
    ], 'r16', 'Route 16 — Steamboat Springs', 'Tiffany Walsh');

    // Route 17 — Craig / Hayden — Robert Martinez
    add([
      ('The Homesteader Restaurant', 'Craig', '535 Yampa Ave', 6, 30, PickupStatus.completed, 19.0),
      ('Fiesta Vallarta — Craig', 'Craig', '420 W Victory Way', 7, 15, PickupStatus.completed, 26.5),
      ('East Side Bistro', 'Craig', '612 W Victory Way', 8, 0, PickupStatus.completed, 22.0),
      ('McDonald\'s — Craig', 'Craig', '1000 W Victory Way', 8, 45, PickupStatus.completed, 49.0),
      ('Subway — Craig', 'Craig', '990 W Victory Way', 9, 30, PickupStatus.completed, 20.5),
      ('Pizza Hut — Craig', 'Craig', '980 W Victory Way', 10, 15, PickupStatus.completed, 37.0),
      ('Taco Bell — Craig', 'Craig', '970 W Victory Way', 11, 0, PickupStatus.inProgress, null),
      ('Wendy\'s — Craig', 'Craig', '960 W Victory Way', 11, 45, PickupStatus.inProgress, null),
      ('Sonic — Craig', 'Craig', '950 W Victory Way', 12, 30, PickupStatus.scheduled, null),
      ('Domino\'s — Hayden', 'Hayden', '200 W Jefferson Ave', 13, 15, PickupStatus.scheduled, null),
      ('KFC — Craig', 'Craig', '940 W Victory Way', 14, 0, PickupStatus.missed, null),
    ], 'r17', 'Route 17 — Craig / Hayden', 'Robert Martinez');

    // Route 18 — Vernal UT — Keisha Johnson
    add([
      ('Vernal Brewing Company', 'Vernal, UT', '55 S 500 E', 6, 0, PickupStatus.completed, 24.0),
      ('Ranch Hand Restaurant', 'Vernal, UT', '125 W Main St', 6, 45, PickupStatus.completed, 19.5),
      ('Western Park Inn & Grill', 'Vernal, UT', '1684 W Hwy 40', 7, 30, PickupStatus.completed, 17.0),
      ('McDonald\'s — Vernal', 'Vernal, UT', '1250 W Main St', 8, 15, PickupStatus.completed, 52.0),
      ('Subway — Vernal', 'Vernal, UT', '1240 W Main St', 9, 0, PickupStatus.completed, 18.5),
      ('Pizza Hut — Vernal', 'Vernal, UT', '1230 W Main St', 9, 45, PickupStatus.completed, 28.0),
      ('Taco Bell — Vernal', 'Vernal, UT', '1220 W Main St', 10, 30, PickupStatus.completed, 31.0),
      ('Sonic — Vernal', 'Vernal, UT', '1210 W Main St', 11, 15, PickupStatus.completed, 18.0),
      ('Wendy\'s — Vernal', 'Vernal, UT', '1200 W Main St', 12, 0, PickupStatus.scheduled, null),
      ('Domino\'s — Vernal', 'Vernal, UT', '1190 W Main St', 12, 45, PickupStatus.missed, null),
    ], 'r18', 'Route 18 — Vernal, UT', 'Keisha Johnson');

    // Route 19 — Price / Helper UT — Chris Anderson
    add([
      ('Castle Gate Brewing Co.', 'Helper, UT', '22 S Main St', 7, 0, PickupStatus.completed, 18.5),
      ('The Fat Belly Diner', 'Price, UT', '75 N Carbon Ave', 7, 45, PickupStatus.completed, 22.0),
      ('Farlaino\'s Italian', 'Price, UT', '87 W Main St', 8, 30, PickupStatus.completed, 19.0),
      ('McDonald\'s — Price', 'Price, UT', '645 E Main St', 9, 15, PickupStatus.completed, 48.5),
      ('Subway — Price', 'Price, UT', '635 E Main St', 10, 0, PickupStatus.inProgress, null),
      ('Pizza Hut — Price', 'Price, UT', '625 E Main St', 10, 45, PickupStatus.inProgress, null),
      ('Taco Bell — Price', 'Price, UT', '615 E Main St', 11, 30, PickupStatus.scheduled, null),
      ('Sonic — Price', 'Price, UT', '605 E Main St', 12, 15, PickupStatus.scheduled, null),
      ('Wendy\'s — Price', 'Price, UT', '595 E Main St', 13, 0, PickupStatus.scheduled, null),
      ('Domino\'s — Price', 'Price, UT', '585 E Main St', 13, 45, PickupStatus.missed, null),
    ], 'r19', 'Route 19 — Price / Helper, UT', 'Chris Anderson');

    // Route 20 — Rangely / Meeker — Maria Gonzalez
    add([
      ('Rio Blanco Steakhouse', 'Meeker', '560 Market St', 7, 0, PickupStatus.completed, 21.5),
      ('The Cowboy\'s Kitchen', 'Rangely', '120 E Main St', 7, 50, PickupStatus.completed, 17.0),
      ('Meeker Café', 'Meeker', '590 Market St', 8, 40, PickupStatus.completed, 14.5),
      ('McDonald\'s — Meeker', 'Meeker', '1200 Market St', 9, 30, PickupStatus.completed, 44.0),
      ('Subway — Meeker', 'Meeker', '1190 Market St', 10, 20, PickupStatus.completed, 16.5),
      ('Pizza Hut — Rangely', 'Rangely', '200 E Main St', 11, 10, PickupStatus.inProgress, null),
      ('Taco Bell — Meeker', 'Meeker', '1180 Market St', 12, 0, PickupStatus.inProgress, null),
      ('Sonic — Rangely', 'Rangely', '190 E Main St', 12, 50, PickupStatus.scheduled, null),
      ('Domino\'s — Meeker', 'Meeker', '1170 Market St', 13, 40, PickupStatus.scheduled, null),
      ('KFC — Rangely', 'Rangely', '180 E Main St', 14, 30, PickupStatus.missed, null),
    ], 'r20', 'Route 20 — Rangely / Meeker', 'Maria Gonzalez');

    // Route 21 — Aspen / Carbondale — Steve Brown
    add([
      ('Village Smithy Restaurant', 'Carbondale', '26 S 3rd St', 7, 0, PickupStatus.completed, 22.0),
      ('Phat Thai — Carbondale', 'Carbondale', '510 Main St', 7, 45, PickupStatus.completed, 18.5),
      ('Carbondale Beer Works', 'Carbondale', '14 N 4th St', 8, 30, PickupStatus.completed, 24.0),
      ('McDonald\'s — Carbondale', 'Carbondale', '1000 Hwy 133', 9, 15, PickupStatus.completed, 48.0),
      ('Subway — Carbondale', 'Carbondale', '990 Hwy 133', 10, 0, PickupStatus.inProgress, null),
      ('Pizza Hut — Carbondale', 'Carbondale', '980 Hwy 133', 10, 45, PickupStatus.inProgress, null),
      ('Taco Bell — Carbondale', 'Carbondale', '970 Hwy 133', 11, 30, PickupStatus.scheduled, null),
      ('Sonic — Carbondale', 'Carbondale', '960 Hwy 133', 12, 15, PickupStatus.scheduled, null),
      ('Wendy\'s — Carbondale', 'Carbondale', '950 Hwy 133', 13, 0, PickupStatus.scheduled, null),
      ('Domino\'s — Carbondale', 'Carbondale', '940 Hwy 133', 13, 45, PickupStatus.missed, null),
    ], 'r21', 'Route 21 — Aspen / Carbondale', 'Steve Brown');

    // Route 22 — Silt / New Castle — Amber Williams
    add([
      ('Dos Hombres Mexican — Silt', 'Silt', '710 Main St', 7, 0, PickupStatus.completed, 20.0),
      ('Red Zone Sports Bar', 'Silt', '810 Main St', 7, 45, PickupStatus.completed, 17.5),
      ('The Landing — New Castle', 'New Castle', '320 Castle Valley Blvd', 8, 30, PickupStatus.completed, 22.0),
      ('McDonald\'s — Silt', 'Silt', '1100 Main St', 9, 15, PickupStatus.completed, 46.0),
      ('Subway — Silt', 'Silt', '1090 Main St', 10, 0, PickupStatus.completed, 19.5),
      ('Pizza Hut — New Castle', 'New Castle', '400 Castle Valley Blvd', 10, 45, PickupStatus.inProgress, null),
      ('Taco Bell — Silt', 'Silt', '1080 Main St', 11, 30, PickupStatus.inProgress, null),
      ('Sonic — Silt', 'Silt', '1070 Main St', 12, 15, PickupStatus.scheduled, null),
      ('Domino\'s — New Castle', 'New Castle', '390 Castle Valley Blvd', 13, 0, PickupStatus.scheduled, null),
      ('KFC — Silt', 'Silt', '1060 Main St', 13, 45, PickupStatus.missed, null),
    ], 'r22', 'Route 22 — Silt / New Castle', 'Amber Williams');

    // Route 23 — Palisade Extended — Kevin Lee
    add([
      ('Talbott\'s Cider Co.', 'Palisade', '3535 E 1/2 Rd', 6, 45, PickupStatus.completed, 14.5),
      ('Colterris Winery', 'Palisade', '3548 E 1/2 Rd', 7, 30, PickupStatus.completed, 12.0),
      ('Aloha Winery — Palisade', 'Palisade', '3560 G Rd', 8, 15, PickupStatus.completed, 11.0),
      ('McDonald\'s — Palisade Ext', 'Palisade', '500 US-6', 9, 0, PickupStatus.completed, 45.5),
      ('Subway — Palisade Ext', 'Palisade', '490 US-6', 9, 45, PickupStatus.completed, 18.0),
      ('Pizza Hut — Palisade Ext', 'Palisade', '480 US-6', 10, 30, PickupStatus.completed, 26.5),
      ('Taco Bell — Palisade Ext', 'Palisade', '470 US-6', 11, 15, PickupStatus.completed, 31.5),
      ('Sonic — Palisade Ext', 'Palisade', '460 US-6', 12, 0, PickupStatus.scheduled, null),
      ('KFC — Palisade Ext', 'Palisade', '450 US-6', 12, 45, PickupStatus.scheduled, null),
      ('Domino\'s — Palisade Ext', 'Palisade', '440 US-6', 13, 30, PickupStatus.missed, null),
    ], 'r23', 'Route 23 — Palisade Extended', 'Kevin Lee');

    // Route 24 — GJ Industrial — Sandra Thompson (off duty, all scheduled)
    add([
      ('Grand Junction Brewing Co.', 'Grand Junction', '1905 N 12th St', 8, 0, PickupStatus.scheduled, null),
      ('Saucy Mama\'s — Industrial', 'Grand Junction', '2100 Industrial Blvd', 8, 45, PickupStatus.scheduled, null),
      ('The Lunch Box — GJ Ind.', 'Grand Junction', '2200 Industrial Blvd', 9, 30, PickupStatus.scheduled, null),
      ('McDonald\'s — Industrial', 'Grand Junction', '2300 Industrial Blvd', 10, 15, PickupStatus.scheduled, null),
      ('Subway — Industrial GJ', 'Grand Junction', '2290 Industrial Blvd', 11, 0, PickupStatus.scheduled, null),
      ('Pizza Hut — Industrial GJ', 'Grand Junction', '2280 Industrial Blvd', 11, 45, PickupStatus.scheduled, null),
      ('Taco Bell — Industrial GJ', 'Grand Junction', '2270 Industrial Blvd', 12, 30, PickupStatus.scheduled, null),
      ('Wendy\'s — Industrial GJ', 'Grand Junction', '2260 Industrial Blvd', 13, 15, PickupStatus.scheduled, null),
      ('KFC — Industrial GJ', 'Grand Junction', '2250 Industrial Blvd', 14, 0, PickupStatus.scheduled, null),
      ('Sonic — Industrial GJ', 'Grand Junction', '2240 Industrial Blvd', 14, 45, PickupStatus.scheduled, null),
      ('Arby\'s — Industrial GJ', 'Grand Junction', '2230 Industrial Blvd', 15, 30, PickupStatus.scheduled, null),
    ], 'r24', 'Route 24 — GJ Industrial', 'Sandra Thompson');

    return pickups;
  }

  // ---------------------------------------------------------------------------
  // Trades — 32 total
  // ---------------------------------------------------------------------------
  static List<Trade> getTrades() => [
        // Original 16
        Trade(id: 'T-2604-001', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 150000, pricePerLb: 0.487, counterparty: 'Diamond Green Diesel', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 17)),
        Trade(id: 'T-2604-002', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 85000, pricePerLb: 0.421, counterparty: 'Mountain West Collectors', status: TradeStatus.settled, tradeDate: DateTime(2026, 4, 10)),
        Trade(id: 'T-2604-003', type: TradeType.sell, commodity: CommodityType.yellowGrease, volumeLbs: 200000, pricePerLb: 0.392, counterparty: 'Crimson Renewable Energy', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 18)),
        Trade(id: 'T-2604-004', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 120000, pricePerLb: 0.439, counterparty: 'Colorado Grease Co.', status: TradeStatus.pendingSettlement, tradeDate: DateTime(2026, 4, 14)),
        Trade(id: 'T-2604-005', type: TradeType.sell, commodity: CommodityType.tallow, volumeLbs: 75000, pricePerLb: 0.551, counterparty: 'Renewable Energy Group', status: TradeStatus.settled, tradeDate: DateTime(2026, 4, 8)),
        Trade(id: 'T-2604-006', type: TradeType.buy, commodity: CommodityType.yellowGrease, volumeLbs: 95000, pricePerLb: 0.358, counterparty: 'Western Slope Renderers', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 16)),
        Trade(id: 'T-2604-007', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 180000, pricePerLb: 0.502, counterparty: 'Pacific Coast Energy', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 19)),
        Trade(id: 'T-2604-008', type: TradeType.buy, commodity: CommodityType.tallow, volumeLbs: 60000, pricePerLb: 0.478, counterparty: 'Four Corners Rendering', status: TradeStatus.settled, tradeDate: DateTime(2026, 4, 7)),
        Trade(id: 'T-2604-009', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 100000, pricePerLb: 0.461, counterparty: 'World Energy', status: TradeStatus.pendingSettlement, tradeDate: DateTime(2026, 4, 15)),
        Trade(id: 'T-2604-010', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 140000, pricePerLb: 0.445, counterparty: 'Utah Valley Grease', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 18)),
        Trade(id: 'T-2604-011', type: TradeType.sell, commodity: CommodityType.yellowGrease, volumeLbs: 160000, pricePerLb: 0.401, counterparty: 'Valero Renewables', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 17)),
        Trade(id: 'T-2604-012', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 70000, pricePerLb: 0.432, counterparty: 'Grand Mesa Collectors', status: TradeStatus.settled, tradeDate: DateTime(2026, 4, 9)),
        Trade(id: 'T-2604-013', type: TradeType.sell, commodity: CommodityType.tallow, volumeLbs: 90000, pricePerLb: 0.574, counterparty: 'ADM Renewables', status: TradeStatus.pendingSettlement, tradeDate: DateTime(2026, 4, 16)),
        Trade(id: 'T-2604-014', type: TradeType.buy, commodity: CommodityType.yellowGrease, volumeLbs: 110000, pricePerLb: 0.371, counterparty: 'Rocky Mountain Grease', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 19)),
        Trade(id: 'T-2604-015', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 220000, pricePerLb: 0.493, counterparty: 'Diamond Green Diesel', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 19)),
        Trade(id: 'T-2604-016', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 165000, pricePerLb: 0.449, counterparty: 'Southwest Grease Trading', status: TradeStatus.settled, tradeDate: DateTime(2026, 4, 11)),
        // New 16
        Trade(id: 'T-2603-017', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 130000, pricePerLb: 0.478, counterparty: 'Neste US Inc.', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 28)),
        Trade(id: 'T-2603-018', type: TradeType.buy, commodity: CommodityType.tallow, volumeLbs: 80000, pricePerLb: 0.491, counterparty: 'Southwest Rendering Co.', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 25)),
        Trade(id: 'T-2603-019', type: TradeType.sell, commodity: CommodityType.yellowGrease, volumeLbs: 175000, pricePerLb: 0.385, counterparty: 'Phillips 66 Renewables', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 20)),
        Trade(id: 'T-2603-020', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 195000, pricePerLb: 0.431, counterparty: 'Colorado Basin Collectors', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 15)),
        Trade(id: 'T-2603-021', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 260000, pricePerLb: 0.469, counterparty: 'Marathon Petroleum Renewables', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 10)),
        Trade(id: 'T-2603-022', type: TradeType.buy, commodity: CommodityType.yellowGrease, volumeLbs: 145000, pricePerLb: 0.362, counterparty: 'Four Corners Rendering', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 5)),
        Trade(id: 'T-2603-023', type: TradeType.sell, commodity: CommodityType.tallow, volumeLbs: 110000, pricePerLb: 0.558, counterparty: 'Global Clean Energy Holdings', status: TradeStatus.settled, tradeDate: DateTime(2026, 3, 1)),
        Trade(id: 'T-2602-024', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 185000, pricePerLb: 0.418, counterparty: 'Utah Grease Recovery', status: TradeStatus.settled, tradeDate: DateTime(2026, 2, 28)),
        Trade(id: 'T-2604-025', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 95000, pricePerLb: 0.498, counterparty: 'Sinclair Renewables', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 18)),
        Trade(id: 'T-2604-026', type: TradeType.buy, commodity: CommodityType.tallow, volumeLbs: 55000, pricePerLb: 0.482, counterparty: 'Western Beef Processing', status: TradeStatus.pendingSettlement, tradeDate: DateTime(2026, 4, 17)),
        Trade(id: 'T-2604-027', type: TradeType.sell, commodity: CommodityType.yellowGrease, volumeLbs: 135000, pricePerLb: 0.408, counterparty: 'TotalEnergies Renewables', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 16)),
        Trade(id: 'T-2604-028', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 210000, pricePerLb: 0.441, counterparty: 'Rocky Mountain Grease', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 15)),
        Trade(id: 'T-2604-029', type: TradeType.sell, commodity: CommodityType.uco, volumeLbs: 310000, pricePerLb: 0.511, counterparty: 'Chevron Lummus Global', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 19)),
        Trade(id: 'T-2604-030', type: TradeType.buy, commodity: CommodityType.yellowGrease, volumeLbs: 90000, pricePerLb: 0.366, counterparty: 'Delta Rendering Inc.', status: TradeStatus.pendingSettlement, tradeDate: DateTime(2026, 4, 14)),
        Trade(id: 'T-2604-031', type: TradeType.sell, commodity: CommodityType.tallow, volumeLbs: 70000, pricePerLb: 0.563, counterparty: 'Suncor Renewables', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 18)),
        Trade(id: 'T-2604-032', type: TradeType.buy, commodity: CommodityType.uco, volumeLbs: 155000, pricePerLb: 0.453, counterparty: 'Grand Junction Grease LLC', status: TradeStatus.open, tradeDate: DateTime(2026, 4, 19)),
      ];

  // ---------------------------------------------------------------------------
  // Daily Volumes — 56 days
  // ---------------------------------------------------------------------------
  static List<DailyVolume> getDailyVolumes() {
    final data = [
      // --- Older 28 days (Feb 23 – Mar 22) ---
      (55, 1920), (54, 2080), (53, 2010), (52, 2150), (51, 2290),
      (50, 840),  (49, 390),  (48, 1890), (47, 1970), (46, 2060),
      (45, 2130), (44, 2240), (43, 910),  (42, 420),  (41, 1960),
      (40, 2040), (39, 2100), (38, 2200), (37, 2350), (36, 880),
      (35, 400),  (34, 2010), (33, 2090), (32, 2140), (31, 2260),
      (30, 2310), (29, 900),  (28, 415),
      // --- Original 28 days (Mar 23 – Apr 19) ---
      (27, 1940), (26, 2010), (25, 1980), (24, 2090), (23, 2180),
      (22, 870),  (21, 430),  (20, 1960), (19, 2020), (18, 2090),
      (17, 2140), (16, 2310), (15, 950),  (14, 380),  (13, 2000),
      (12, 2120), (11, 2050), (10, 2190), (9, 2280),  (8, 890),
      (7, 410),   (6, 1980),  (5, 2150),  (4, 2210),  (3, 2340),
      (2, 2180),  (1, 820),   (0, 1847),
    ];

    return data
        .map((e) => DailyVolume(
              date: _today.subtract(Duration(days: e.$1)),
              gallons: e.$2,
            ))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Commodity Prices
  // ---------------------------------------------------------------------------
  static List<CommodityPrice> getCommodityPrices() => [
        const CommodityPrice(name: 'UCO', pricePerLb: 0.487, change: 0.003),
        const CommodityPrice(name: 'Yellow Grease', pricePerLb: 0.392, change: -0.002),
        const CommodityPrice(name: 'Tallow', pricePerLb: 0.553, change: 0.005),
      ];
}
