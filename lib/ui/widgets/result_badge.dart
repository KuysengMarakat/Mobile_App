import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Badge widget showing scan result status with color and icon.
class ResultBadge extends StatelessWidget {
  final String status;
  final bool showLabel;
  final double size;

  const ResultBadge({
    super.key,
    required this.status,
    this.showLabel = true,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getStatusColor(status);
    final icon = AppTheme.getStatusIcon(status);
    final label = _getLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: size * 0.7),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getLabel() {
    switch (status.toLowerCase()) {
      case 'safe':
        return 'Safe';
      case 'warning':
        return 'Warning';
      case 'dangerous':
        return 'Dangerous';
      default:
        return 'Unknown';
    }
  }
}
