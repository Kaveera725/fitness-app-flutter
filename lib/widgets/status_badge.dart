import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

    switch (type) {
      case BadgeType.active:
        primaryColor = const Color(0xFF00C853); // Emerald Green
        backgroundColor = const Color(0xFF00C853).withOpacity(0.12);
        break;
      case BadgeType.pending:
        primaryColor = const Color(0xFFFF9100); // Amber Orange
        backgroundColor = const Color(0xFFFF9100).withOpacity(0.12);
        break;
      case BadgeType.premium:
        primaryColor = const Color(0xFF7C4DFF); // Deep Indigo/Purple
        backgroundColor = const Color(0xFF7C4DFF).withOpacity(0.14);
        break;
      case BadgeType.free:
        primaryColor = Colors.grey.shade600;
        backgroundColor = Colors.grey.withOpacity(0.12);
        break;
      case BadgeType.custom:
        primaryColor = customColor ?? Theme.of(context).colorScheme.primary;
        backgroundColor = primaryColor.withOpacity(0.12);
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
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
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
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
