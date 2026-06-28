import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Pill badge showing scan status with soft tinted background and icon.
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
    final softColor = AppTheme.getStatusSoftColor(status);
    final icon = AppTheme.getStatusIcon(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 11 : 7,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: size * 0.62),
          if (showLabel) ...[
            const SizedBox(width: 5),
            Text(
              _label(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _label() {
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
