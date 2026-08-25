import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness/widgets/gradient_button.dart';
import 'package:fitness/screens/main_tab_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confettiController;
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    for (int i = 0; i < 35; i++) {
      _particles.add(_ConfettiParticle(index: i));
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF260D4D), Color(0xFF1A0A33), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // ── Confetti particles ────────────────────────────────────────
            ...List.generate(_particles.length, (i) {
              final p = _particles[i];
              return AnimatedBuilder(
                animation: _confettiController,
                builder: (context, _) {
                  final progress = _confettiController.value;
                  return Positioned(
                    left: (p.startX * size.width + (p.drift * progress * 50))
                        .clamp(0.0, size.width - 10),
                    top: -20 + (progress * (size.height + 40) * p.speed),
                    child: Opacity(
                      opacity: (1.0 - progress).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: progress * p.rotation * 4,
                        child: Container(
                          width: p.size,
                          height: p.size * 0.5,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // ── Main Content ──────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Success icon
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFF5E35B1)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C4DFF).withOpacity(0.5),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack),

                    const SizedBox(height: 28),

                    Text(
                      "You're Premium! 🎉",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: 0.2),

                    const SizedBox(height: 12),

                    Text(
                      'Welcome to FitPulse Premium.\nAll elite coaching and workouts unlocked.',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 36),

                    // Perks checklist
                    ...[
                      '✓  Personal coach messaging unlocked',
                      '✓  Full analytics & body tracking',
                      '✓  All premium workout routines',
                    ].asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            e.value,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: const Color(0xFF00E676),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),

                    const Spacer(),

                    GradientButton(
                      text: 'Start Exploring',
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const MainTabScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.rocket_launch_rounded,
                          color: Colors.white, size: 20),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  final double startX;
  final double drift;
  final double speed;
  final double rotation;
  final double size;
  final Color color;

  static const _colors = [
    Color(0xFF7C4DFF),
    Color(0xFFFFD700),
    Color(0xFF00E676),
    Color(0xFFFF6D00),
    Color(0xFFE040FB),
    Color(0xFF40C4FF),
  ];

  _ConfettiParticle({required int index})
      : startX = (index * 37 % 97) / 100.0,
        drift = ((index * 13 % 20) - 10) / 10.0,
        speed = 0.6 + (index * 7 % 40) / 100.0,
        rotation = (index % 6) * 1.05,
        size = 6.0 + (index % 4) * 2.0,
        color = _colors[index % _colors.length];
}
