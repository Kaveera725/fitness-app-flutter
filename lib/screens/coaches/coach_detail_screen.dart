import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fitness/models/coach.dart';
import 'package:fitness/widgets/gradient_button.dart';
import 'package:fitness/widgets/custom_button.dart';
import 'package:fitness/widgets/status_badge.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachDetailScreen extends StatelessWidget {
  final Coach coach;
  // Mock booleans for demo purposes
  final bool isPremium = false; // toggle to true to see premium UI
  final bool hasThisCoach = false; // toggle to true to see rating UI

  const CoachDetailScreen({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coach.name),
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner / large photo
            Stack(
              children: [
                Image.network(
                  coach.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    coach.name,
                    style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coach.specialty, style: GoogleFonts.manrope(fontSize: 18, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Text(coach.bio, style: GoogleFonts.manrope(fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${coach.rating.toStringAsFixed(1)} (${coach.reviewCount} reviews)',
                          style: GoogleFonts.manrope(fontSize: 14)),
                      const Spacer(),
                      StatusBadge(
                        label: '${coach.experienceYears} yrs',
                        type: BadgeType.custom,
                        customColor: const Color(0xFF7C4DFF),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Premium / Free conditional UI
                  isPremium
                      ? GradientButton(
                          text: 'Select as My Coach',
                          onPressed: () {},
                        )
                      : Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock, color: Color(0xFF7C4DFF)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Upgrade to Premium to select a coach',
                                    style: GoogleFonts.manrope(color: const Color(0xFF7C4DFF))),
                              ),
                              CustomButton(
                                text: 'Upgrade Now',
                                onPressed: () {},
                                isPrimary: false,
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 24),
                  // Rating section (visible if assigned)
                  if (hasThisCoach) ...[
                    Text('Rate this Coach', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    // Simple star selector (placeholder)
                    Row(
                      children: List.generate(5, (i) => Icon(Icons.star_border, size: 28, color: Colors.amber)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Leave a comment',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomButton(text: 'Submit', onPressed: () {}, isPrimary: true),
                  ],
                  const SizedBox(height: 24),
                  // Reviews list
                  Text('Reviews', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...coach.reviews.map((review) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(review.reviewer, style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                      review.rating.round(),
                                      (_) => const Icon(Icons.star, size: 16, color: Colors.amber)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(review.comment, style: GoogleFonts.manrope()),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
