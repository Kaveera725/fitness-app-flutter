import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/coach.dart';
import '../theme/app_theme.dart';

class CoachReviewCard extends StatelessWidget {
  final Review review;
  final bool isDark;
  final EdgeInsetsGeometry? margin;

  const CoachReviewCard({
    super.key,
    required this.review,
    this.isDark = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppTheme.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTheme.surfaceBorder : Colors.transparent;
    final nameColor = isDark ? AppTheme.textDark : Colors.black87;
    final commentColor = isDark ? AppTheme.textSecondary : Colors.grey.shade700;
    final avatarBg = isDark
        ? AppTheme.accentGreen.withValues(alpha: 0.15)
        : const Color(0xFF5E35B1).withValues(alpha: 0.12);
    final avatarTextColor =
        isDark ? AppTheme.accentGreen : const Color(0xFF5E35B1);

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: borderColor, width: 1) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (review.avatarUrl != null && review.avatarUrl!.isNotEmpty)
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(review.avatarUrl!),
                  backgroundColor: avatarBg,
                  onBackgroundImageError: (_, _) {},
                )
              else
                CircleAvatar(
                  radius: 14,
                  backgroundColor: avatarBg,
                  child: Text(
                    review.reviewer.isNotEmpty ? review.reviewer[0] : 'U',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: avatarTextColor,
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewer,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: nameColor,
                      ),
                    ),
                    if (review.date != null)
                      Text(
                        review.date!,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: isDark
                              ? AppTheme.textSecondary.withValues(alpha: 0.7)
                              : Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  review.rating.round().clamp(1, 5),
                  (_) => const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: commentColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
