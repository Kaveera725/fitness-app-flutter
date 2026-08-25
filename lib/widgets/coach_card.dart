import 'package:flutter/material.dart';
import 'package:fitness/models/coach.dart';
import 'package:fitness/widgets/custom_button.dart';
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(coach.imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.name,
                    style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coach.specialty,
                    style: GoogleFonts.manrope(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${coach.rating.toStringAsFixed(1)}', style: GoogleFonts.manrope(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text('(${coach.reviewCount} reviews)', style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StatusBadge(
                    label: '${coach.experienceYears} yrs',
                    type: BadgeType.custom,
                    customColor: const Color(0xFF7C4DFF),
                  ),
                ],
              ),
            ),
            CustomButton(text: 'View Profile', onPressed: onViewProfile, isPrimary: true, isFullWidth: false),
          ],
        ),
      ),
    );
  }
}
