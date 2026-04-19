import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets? padding;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTheme.headingMedium),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Divider(color: AppTheme.divider, height: 18, thickness: 1),
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
