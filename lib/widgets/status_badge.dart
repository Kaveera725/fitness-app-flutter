import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

enum BadgeType {
  active,
  pending,
  premium,
  free,
  custom,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final Color? customColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.custom,
    this.customColor,
    this.icon,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  factory StatusBadge.active({String label = 'Active'}) {
    return StatusBadge(
      label: label,
      type: BadgeType.active,
      icon: Icons.check_circle_rounded,
    );
  }

  factory StatusBadge.pending({String label = 'Pending'}) {
    return StatusBadge(
      label: label,
      type: BadgeType.pending,
      icon: Icons.hourglass_top_rounded,
    );
  }

  factory StatusBadge.premium({String label = 'Premium'}) {
    return StatusBadge(
      label: label,
      type: BadgeType.premium,
      icon: Icons.star_rounded,
    );
  }

  factory StatusBadge.free({String label = 'Free'}) {
    return StatusBadge(
      label: label,
      type: BadgeType.free,
      icon: Icons.person_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor;
    Color backgroundColor;
    Color borderColor;

    switch (type) {
      case BadgeType.active:
        // Neon green text/icon with dark translucent background
        primaryColor = AppTheme.primary;
        backgroundColor = AppTheme.primary.withValues(alpha: 0.14);
        borderColor = AppTheme.primary.withValues(alpha: 0.35);
        break;
      case BadgeType.pending:
        primaryColor = AppTheme.accentOrange;
        backgroundColor = AppTheme.accentOrange.withValues(alpha: 0.14);
        borderColor = AppTheme.accentOrange.withValues(alpha: 0.35);
        break;
      case BadgeType.premium:
        // Secondary accent purple strictly for premium/pro badge
        primaryColor = AppTheme.accentPurple;
        backgroundColor = AppTheme.accentPurple.withValues(alpha: 0.16);
        borderColor = AppTheme.accentPurple.withValues(alpha: 0.38);
        break;
      case BadgeType.free:
        // Muted grey for inactive/free
        primaryColor = AppTheme.textSecondary;
        backgroundColor = const Color(0xFF222622);
        borderColor = AppTheme.surfaceBorder;
        break;
      case BadgeType.custom:
        primaryColor = customColor ?? AppTheme.primary;
        backgroundColor = primaryColor.withValues(alpha: 0.14);
        borderColor = primaryColor.withValues(alpha: 0.35);
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: primaryColor,
            ),
            const SizedBox(width: 5),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: type == BadgeType.active
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.6),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
