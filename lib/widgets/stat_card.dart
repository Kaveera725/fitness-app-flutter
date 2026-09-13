import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? target;
  final double? progress;
  final String? trend;
  final bool trendPositive;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.target,
    this.progress,
    this.trend,
    this.trendPositive = true,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark, // Dark card background (#1A1D1A)
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.surfaceBorder, // Subtle 1px lighter border
            width: 1,
          ),
          boxShadow: [
            // Soft subtle glow instead of dark drop shadow
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Dark Translucent Icon Pill + Trend indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: (trendPositive ? AppTheme.primary : Colors.redAccent).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (trendPositive ? AppTheme.primary : Colors.redAccent).withValues(alpha: 0.25),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          size: 11,
                          color: trendPositive ? AppTheme.primary : Colors.redAccent,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          trend!,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: trendPositive ? AppTheme.primary : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Middle: Extra bold confident stats number + Title
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800, // Extra bold & confident
                color: AppTheme.textDark,
                letterSpacing: -0.3,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary, // Muted grey (#8A8F8A)
              ),
            ),

            // Bottom: Progress bar toward daily target (if provided)
            if (progress != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  minHeight: 4,
                  backgroundColor: const Color(0xFF252A25), // Dark track
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              if (target != null) ...[
                const SizedBox(height: 5),
                Text(
                  target!,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ] else if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle!,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
