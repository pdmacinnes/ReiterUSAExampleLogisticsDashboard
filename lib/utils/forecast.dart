import 'package:fl_chart/fl_chart.dart';
import '../models/daily_volume.dart';

/// Returns forecast FlSpots for the 7 days after the last data point.
/// Uses linear regression on all weekday data points.
List<FlSpot> computeForecast(List<DailyVolume> volumes) {
  if (volumes.length < 5) return [];

  final weekdays = <MapEntry<int, int>>[];
  for (int i = 0; i < volumes.length; i++) {
    final v = volumes[i];
    if (v.date.weekday != DateTime.saturday &&
        v.date.weekday != DateTime.sunday) {
      weekdays.add(MapEntry(i, v.gallons));
    }
  }
  if (weekdays.length < 3) return [];

  final n = weekdays.length.toDouble();
  double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
  for (final e in weekdays) {
    sumX += e.key;
    sumY += e.value;
    sumXY += e.key * e.value;
    sumX2 += e.key.toDouble() * e.key;
  }
  final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  final intercept = (sumY - slope * sumX) / n;

  final spots = <FlSpot>[];
  final lastIdx = volumes.length - 1;
  for (int i = 1; i <= 10; i++) {
    final futureDate = volumes.last.date.add(Duration(days: i));
    if (futureDate.weekday == DateTime.saturday ||
        futureDate.weekday == DateTime.sunday) continue;
    final x = (lastIdx + i).toDouble();
    final y = (slope * x + intercept).clamp(400.0, 3200.0);
    spots.add(FlSpot(x, y));
  }
  return spots;
}
