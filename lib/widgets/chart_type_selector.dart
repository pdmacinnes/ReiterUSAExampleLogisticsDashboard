import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChartTypeSelector<T> extends StatelessWidget {
  final List<(T, String, IconData)> options;
  final T selected;
  final void Function(T) onSelect;

  const ChartTypeSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: options.map((opt) {
        final isSelected = opt.$1 == selected;
        return GestureDetector(
          onTap: () => onSelect(opt.$1),
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accent.withOpacity(0.15)
                  : AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? AppTheme.accent : AppTheme.divider,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  opt.$3,
                  size: 13,
                  color: isSelected
                      ? AppTheme.accent
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  opt.$2,
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.accent
                        : AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
