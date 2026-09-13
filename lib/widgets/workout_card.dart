import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String duration;
  final String difficulty;
  final String imageUrl;
  final VoidCallback onTap;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.surfaceBorder,
            width: 1,
          ),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF0D0F0D).withValues(alpha: 0.4),
                const Color(0xFF0D0F0D).withValues(alpha: 0.94),
              ],
              stops: const [0.2, 0.6, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 80), // To give image space
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTag(Icons.timer_outlined, duration, AppTheme.primary),
                  const SizedBox(width: 10),
                  _buildTag(Icons.local_fire_department_rounded, difficulty, Colors.orangeAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141714).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accentColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.manrope(
              color: AppTheme.textDark,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
