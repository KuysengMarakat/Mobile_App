import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// A soft, elevated surface card used across the app.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final List<BoxShadow>? shadow;
  final BorderRadius? radius;
  final Border? border;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.shadow,
    this.radius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final br = radius ?? BorderRadius.circular(AppTheme.radiusMedium);
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface,
        borderRadius: br,
        boxShadow: shadow ?? AppTheme.shadowMd,
        border: border ?? Border.all(color: AppTheme.hairline, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: br,
        child: InkWell(
          onTap: onTap,
          borderRadius: br,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}


/// Section header with an optional trailing action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.inkMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// A small label chip for tags like "Blue Team".
class PillTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color? background;
  final IconData? icon;

  const PillTag({
    super.key,
    required this.label,
    this.color = AppTheme.primaryPurple,
    this.background,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}


/// Compact statistic chip used in the stats row.
class StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: AppTheme.shadowSm,
          border: Border.all(color: AppTheme.hairline),
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.inkMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The brand "Divine Eye" logo mark with shield + eye + glow ring.
class BrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final Color ringColor;
  final Color eyeColor;

  const BrandLogo({
    super.key,
    this.size = 110,
    this.showGlow = true,
    this.ringColor = AppTheme.accentGold,
    this.eyeColor = AppTheme.accentGold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
        ),
        border: Border.all(color: ringColor.withOpacity(0.9), width: 2.5),
        boxShadow: showGlow ? AppTheme.glow(ringColor, opacity: 0.30) : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.shield_outlined,
              size: size * 0.62, color: Colors.white.withOpacity(0.22)),
          Icon(Icons.remove_red_eye_rounded,
              size: size * 0.34, color: eyeColor),
        ],
      ),
    );
  }
}
