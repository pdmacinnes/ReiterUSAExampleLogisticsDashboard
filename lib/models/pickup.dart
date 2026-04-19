import 'package:flutter/material.dart';

enum PickupStatus { scheduled, inProgress, completed, missed }

extension PickupStatusX on PickupStatus {
  String get label {
    switch (this) {
      case PickupStatus.scheduled:
        return 'Scheduled';
      case PickupStatus.inProgress:
        return 'In Progress';
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.missed:
        return 'Missed';
    }
  }

  Color get color {
    switch (this) {
      case PickupStatus.scheduled:
        return const Color(0xFF8BA5BE);
      case PickupStatus.inProgress:
        return const Color(0xFF3498DB);
      case PickupStatus.completed:
        return const Color(0xFF27AE60);
      case PickupStatus.missed:
        return const Color(0xFFE74C3C);
    }
  }

  Color get bgColor {
    return color.withOpacity(0.15);
  }
}

class Pickup {
  final String id;
  final String locationName;
  final String city;
  final String address;
  final DateTime scheduledTime;
  final DateTime? completedTime;
  final PickupStatus status;
  final double? volumeGallons;
  final String driverName;
  final String routeId;
  final String routeName;

  const Pickup({
    required this.id,
    required this.locationName,
    required this.city,
    required this.address,
    required this.scheduledTime,
    this.completedTime,
    required this.status,
    this.volumeGallons,
    required this.driverName,
    required this.routeId,
    required this.routeName,
  });
}
