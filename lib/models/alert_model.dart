import 'package:flutter/material.dart';

enum AlertType { info, warning, urgent }

extension AlertTypeX on AlertType {
  Color get color {
    switch (this) {
      case AlertType.info:
        return const Color(0xFF3498DB);
      case AlertType.warning:
        return const Color(0xFFF39C12);
      case AlertType.urgent:
        return const Color(0xFFE74C3C);
    }
  }

  IconData get icon {
    switch (this) {
      case AlertType.info:
        return Icons.info_outline_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.urgent:
        return Icons.error_outline_rounded;
    }
  }
}

class AlertItem {
  final AlertType type;
  final String title;
  final String detail;
  final DateTime timestamp;

  const AlertItem({
    required this.type,
    required this.title,
    required this.detail,
    required this.timestamp,
  });
}
