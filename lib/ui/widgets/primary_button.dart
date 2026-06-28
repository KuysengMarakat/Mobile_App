import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Premium button with gradient fill, glow, loading state, and a subtle
/// press-scale micro-interaction. Supports gradient, solid, and outlined.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 56,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null && !widget.isLoading;
    final fg = widget.foregroundColor ??
        (widget.isOutlined ? AppTheme.primaryPurple : Colors.white);

    final content = widget.isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20, color: fg),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );


    final radius = BorderRadius.circular(AppTheme.radiusMedium);
    final useGradient = !widget.isOutlined &&
        widget.backgroundColor == null &&
        (widget.gradient != null || true);
    final gradient = widget.isOutlined
        ? null
        : (widget.backgroundColor != null
            ? null
            : (widget.gradient ?? AppTheme.primaryGradient));

    final accentColor = widget.backgroundColor ?? AppTheme.primaryPurple;

    return GestureDetector(
      onTapDown: (_) {
        if (!disabled) setState(() => _pressed = true);
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: disabled ? 0.55 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: gradient,
              color: widget.isOutlined
                  ? Colors.transparent
                  : widget.backgroundColor,
              borderRadius: radius,
              border: widget.isOutlined
                  ? Border.all(
                      color: (widget.foregroundColor ?? AppTheme.primaryPurple)
                          .withOpacity(0.35),
                      width: 1.5,
                    )
                  : null,
              boxShadow: (widget.isOutlined || disabled)
                  ? null
                  : [
                      BoxShadow(
                        color: (useGradient
                                ? AppTheme.primaryPurple
                                : accentColor)
                            .withOpacity(0.32),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
