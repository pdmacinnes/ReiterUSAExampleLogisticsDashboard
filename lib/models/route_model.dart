import 'package:flutter/material.dart';

enum DriverStatus { onRoute, onBreak, returning, offDuty }

extension DriverStatusX on DriverStatus {
  String get label {
    switch (this) {
      case DriverStatus.onRoute:
        return 'On Route';
      case DriverStatus.onBreak:
        return 'Break';
      case DriverStatus.returning:
        return 'Returning';
      case DriverStatus.offDuty:
        return 'Off Duty';
    }
  }

  Color get color {
    switch (this) {
      case DriverStatus.onRoute:
        return const Color(0xFF27AE60);
      case DriverStatus.onBreak:
        return const Color(0xFFF39C12);
      case DriverStatus.returning:
        return const Color(0xFF3498DB);
      case DriverStatus.offDuty:
        return const Color(0xFF8BA5BE);
    }
  }
}

class RouteModel {
  final String id;
  final String name;
  final String driverName;
  final DriverStatus driverStatus;
  final int totalStops;
  final int completedStops;
  final double gallonsCollected;

  const RouteModel({
    required this.id,
    required this.name,
    required this.driverName,
    required this.driverStatus,
    required this.totalStops,
    required this.completedStops,
    required this.gallonsCollected,
  });

  double get progress =>
      totalStops > 0 ? completedStops / totalStops : 0.0;
}
