import 'dart:ui';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  final Color? color;
  final Border? border;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool isGlassy;
  final double blurSigma;
  final double elevation;
  final Color? shadowColor;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.color,
    this.border,
    this.borderRadius = 20.0,
    this.onTap,
    this.isGlassy = false,
    this.blurSigma = 10.0,
    this.elevation = 0,
    this.shadowColor,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine background color/gradient/glass effects
    final cardColor =
        widget.color ??
        (widget.gradient != null
            ? null
            : (widget.isGlassy
                  ? (isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.white.withOpacity(0.2))
                  : (isDark ? const Color(0xFF1E293B) : Colors.white)));

    final cardBorder =
        widget.border ??
        Border.all(
          color: widget.isGlassy
              ? (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.4))
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: 1,
        );

    Widget innerContent = Padding(
      padding: widget.padding ?? const EdgeInsets.all(20.0),
      child: widget.child,
    );

    // Apply glassmorphism if requested
    if (widget.isGlassy) {
      innerContent = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurSigma,
            sigmaY: widget.blurSigma,
          ),
          child: innerContent,
        ),
      );
    }

    Widget mainCard = AnimatedScale(
      scale: _isPressed && widget.onTap != null ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: cardBorder,
          boxShadow: widget.elevation > 0 || (!isDark && !widget.isGlassy)
              ? [
                  BoxShadow(
                    color:
                        widget.shadowColor ??
                        (isDark
                            ? const Color(0x1F000000)
                            : const Color(0x080F172A)),
                    blurRadius: widget.elevation > 0
                        ? widget.elevation * 3
                        : 12,
                    offset: Offset(
                      0,
                      widget.elevation > 0 ? widget.elevation : 4,
                    ),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: widget.onTap != null
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: widget.onTap != null
                ? (_) => setState(() => _isPressed = false)
                : null,
            onTapCancel: widget.onTap != null
                ? () => setState(() => _isPressed = false)
                : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: widget.isGlassy
                ? (isDark ? Colors.white12 : Colors.black12)
                : Theme.of(context).primaryColor.withOpacity(0.08),
            highlightColor: Colors.transparent,
            child: innerContent,
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      return Semantics(button: true, enabled: true, child: mainCard);
    }
    return mainCard;
  }
}
