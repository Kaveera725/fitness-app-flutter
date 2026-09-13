import 'package:flutter/material.dart';
import 'package:fitness/models/coach.dart';
import 'package:fitness/theme/app_theme.dart';
import 'package:fitness/widgets/status_badge.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachCard extends StatelessWidget {
  final Coach coach;
  final VoidCallback onViewProfile;

  const CoachCard({
    super.key,
    required this.coach,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.surfaceBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular avatar with graceful fallback
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Container(
                    width: 68,
                    height: 68,
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    child: Image.network(
                      coach.imageUrl,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              coach.name.isNotEmpty ? coach.name[0] : 'C',
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 68,
                          height: 68,
                          color: const Color(0xFF1F241F),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coach.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          coach.specialty,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            coach.rating.toStringAsFixed(1),
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${coach.reviewCount} reviews)',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          StatusBadge(
                            label: '${coach.experienceYears} yrs',
                            type: BadgeType.custom,
                            customColor: AppTheme.primary,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Full-width View Profile button (High-contrast bold on neon lime)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Profile',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF0D0F0D),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
