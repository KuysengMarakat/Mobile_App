import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Action card for scan actions. Supports an optional gradient "feature"
/// style for high-emphasis actions.
class ScanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool featured;

  const ScanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.radiusMedium);
    final accent = iconColor ?? AppTheme.primaryPurple;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: featured ? AppTheme.heroGradient : null,
            color: featured ? null : AppTheme.surface,
            borderRadius: radius,
            border: featured
                ? null
                : Border.all(color: AppTheme.hairline, width: 1),
            boxShadow: featured ? AppTheme.shadowLg : AppTheme.shadowSm,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: featured
                      ? Colors.white.withOpacity(0.16)
                      : accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: featured ? AppTheme.accentGold : accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: featured ? Colors.white : AppTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.3,
                        color: featured
                            ? Colors.white.withOpacity(0.85)
                            : AppTheme.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: featured ? Colors.white70 : AppTheme.inkFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
