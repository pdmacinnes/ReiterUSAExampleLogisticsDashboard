import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/route_model.dart';
import '../theme/app_theme.dart';
import 'dashboard_card.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = context.watch<DashboardProvider>().routes;

    return DashboardCard(
      title: 'Route Coverage — Western CO / Eastern UT',
      child: SizedBox(
        height: 320,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomPaint(
            painter: _MapPainter(routes: routes),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

// lat/lon bounds
const _minLat = 36.8;
const _maxLat = 41.5;
const _minLon = -111.8;
const _maxLon = -104.8;

double _toX(double lon, double width) =>
    (lon - _minLon) / (_maxLon - _minLon) * width;

double _toY(double lat, double height) =>
    (1 - (lat - _minLat) / (_maxLat - _minLat)) * height;

// Route center coordinates keyed by route id
const Map<String, (double, double)> _coords = {
  'r01': (39.063, -108.549),
  'r02': (39.100, -108.555),
  'r03': (39.066, -108.450),
  'r04': (39.158, -108.732),
  'r05': (38.479, -107.876),
  'r06': (38.740, -107.855),
  'r07': (39.549, -107.325),
  'r08': (39.532, -107.783),
  'r09': (38.573, -109.549),
  'r10': (39.050, -108.530),
  'r11': (39.480, -108.050),
  'r12': (39.054, -108.700),
  'r13': (37.278, -107.880),
  'r14': (37.349, -108.585),
  'r15': (38.800, -107.710),
  'r16': (40.485, -106.831),
  'r17': (40.515, -107.546),
  'r18': (40.456, -109.527),
  'r19': (39.599, -110.811),
  'r20': (40.087, -108.804),
  'r21': (39.191, -106.818),
  'r22': (39.549, -107.656),
  'r23': (39.117, -108.350),
  'r24': (39.052, -108.580),
};

// Short labels for major cities on the map
const _cityLabels = <(double, double, String)>[
  (39.063, -108.549, 'Grand Junction'),
  (38.479, -107.876, 'Montrose'),
  (39.549, -107.325, 'Glenwood Spgs'),
  (38.573, -109.549, 'Moab, UT'),
  (37.278, -107.880, 'Durango'),
  (40.485, -106.831, 'Steamboat Spgs'),
  (39.599, -110.811, 'Price, UT'),
];

class _MapPainter extends CustomPainter {
  final List<RouteModel> routes;

  const _MapPainter({required this.routes});

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawStateBoundaries(canvas, size);
    _drawRivers(canvas, size);
    _drawRoutes(canvas, size);
    _drawCityLabels(canvas, size);
    _drawLegend(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    // Map background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A1520),
    );

    // Colorado fill (lon -109.05 to -102.05, lat 37 to 41)
    final coPaint = Paint()..color = const Color(0xFF112030);
    final coLeft = _toX(-109.05, size.width);
    final coRight = _toX(-102.05, size.width);
    final coTop = _toY(41.0, size.height);
    final coBottom = _toY(37.0, size.height);
    canvas.drawRect(Rect.fromLTRB(coLeft, coTop, coRight, coBottom), coPaint);

    // Utah visible portion fill
    final utPaint = Paint()..color = const Color(0xFF0D1C2A);
    final utLeft = _toX(-114.0, size.width);
    final utRight = coLeft;
    canvas.drawRect(Rect.fromLTRB(utLeft, coTop, utRight, coBottom), utPaint);
  }

  void _drawStateBoundaries(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = const Color(0xFF2A4060)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Colorado border (simplified rectangle)
    final coLeft = _toX(-109.05, size.width);
    final coRight = _toX(-102.05, size.width);
    final coTop = _toY(41.0, size.height);
    final coBottom = _toY(37.0, size.height);
    canvas.drawRect(Rect.fromLTRB(coLeft, coTop, coRight, coBottom), borderPaint);

    // UT/CO state line label
    final stLabelPaint = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'CO',
            style: TextStyle(
                color: const Color(0xFF3A6080),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    stLabelPaint.paint(canvas,
        Offset(coLeft + 8, coTop + 6));

    final utLabelPaint = TextPainter(
      text: TextSpan(
        text: 'UT',
        style: TextStyle(
            color: const Color(0xFF3A6080),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    utLabelPaint.paint(canvas,
        Offset(_toX(-110.5, size.width), coTop + 6));
  }

  void _drawRivers(Canvas canvas, Size size) {
    // Colorado River (very simplified — GJ west to UT)
    final riverPaint = Paint()
      ..color = const Color(0xFF1A3D5C).withOpacity(0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Rough Colorado River path through Grand Junction area
    final pts = <(double, double)>[
      (39.549, -107.325), // Glenwood Springs
      (39.532, -107.783), // Rifle
      (39.480, -108.050), // DeBeque area
      (39.063, -108.549), // Grand Junction
      (39.020, -108.900), // West of GJ
      (38.840, -109.200), // Near Utah border
      (38.573, -109.549), // Moab area
    ];
    path.moveTo(_toX(pts[0].$2, size.width), _toY(pts[0].$1, size.height));
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(_toX(pts[i].$2, size.width), _toY(pts[i].$1, size.height));
    }
    canvas.drawPath(path, riverPaint);
  }

  void _drawRoutes(Canvas canvas, Size size) {
    final routeMap = {for (final r in routes) r.id: r};

    for (final entry in _coords.entries) {
      final route = routeMap[entry.key];
      if (route == null) continue;

      final (lat, lon) = entry.value;
      final x = _toX(lon, size.width);
      final y = _toY(lat, size.height);
      final color = route.driverStatus.color;

      // Outer glow
      canvas.drawCircle(
        Offset(x, y),
        9,
        Paint()..color = color.withOpacity(0.15),
      );
      // Ring
      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = color.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      // Filled dot
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = color,
      );
    }
  }

  void _drawCityLabels(Canvas canvas, Size size) {
    for (final (lat, lon, label) in _cityLabels) {
      final x = _toX(lon, size.width);
      final y = _toY(lat, size.height);

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              color: Color(0xFF6090B0),
              fontSize: 9,
              fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x + 7, y - 5));
    }
  }

  void _drawLegend(Canvas canvas, Size size) {
    const statuses = [
      (DriverStatus.onRoute, 'On Route'),
      (DriverStatus.onBreak, 'On Break'),
      (DriverStatus.returning, 'Returning'),
      (DriverStatus.offDuty, 'Off Duty'),
    ];

    const startX = 8.0;
    var startY = size.height - 10.0 - statuses.length * 18.0;

    for (final (status, label) in statuses) {
      canvas.drawCircle(
        Offset(startX + 5, startY + 5),
        5,
        Paint()..color = status.color,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              color: Color(0xFF8AAABB),
              fontSize: 9.5,
              fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(startX + 14, startY - 1));
      startY += 18;
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.routes != routes;
}
