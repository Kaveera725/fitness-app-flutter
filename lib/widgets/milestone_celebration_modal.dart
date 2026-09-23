import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// A single confetti particle that flies outward from the center.
class _ConfettiParticle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotation;
  final bool isSquare;

  const _ConfettiParticle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotation,
    required this.isSquare,
  });
}

/// Confetti burst painter — draws animated particles radiating outward.
class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress; // 0.0 → 1.0 animation progress
  final Offset center;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Particles spread out fast then slow (easeOut-like with gravity)
      final t = math.pow(progress, 0.6).toDouble();
      final spread = p.speed * t;
      final gravity = 90 * progress * progress; // Gravity pulls down
      final opacity = (1.0 - math.pow(progress, 1.8).toDouble()).clamp(0.0, 1.0);

      final dx = math.cos(p.angle) * spread;
      final dy = math.sin(p.angle) * spread + gravity;
      final px = center.dx + dx;
      final py = center.dy + dy;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation + progress * math.pi * 3);

      if (p.isSquare) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) =>
      old.progress != progress || old.center != center;
}

/// Entry point for the Milestone Celebration Modal.
///
/// Usage (from anywhere in the app):
/// ```dart
/// MilestoneCelebrationModal.show(
///   context,
///   badgeTitle: '7-Day Streak',
///   badgeDescription: 'Trained every day for a full week!',
///   badgeIcon: Icons.local_fire_department_rounded,
///   badgeColor: AppTheme.accentOrange,
///   xpReward: 75,
/// );
/// ```
class MilestoneCelebrationModal extends StatefulWidget {
  final String badgeTitle;
  final String badgeDescription;
  final IconData badgeIcon;
  final Color badgeColor;
  final int xpReward;
  final VoidCallback? onDismiss;

  const MilestoneCelebrationModal({
    super.key,
    required this.badgeTitle,
    required this.badgeDescription,
    required this.badgeIcon,
    required this.badgeColor,
    this.xpReward = 50,
    this.onDismiss,
  });

  /// Static show helper — the recommended way to trigger this overlay
  /// from anywhere in the app (Home, Workout Player, Progress, etc.)
  static Future<void> show(
    BuildContext context, {
    required String badgeTitle,
    required String badgeDescription,
    required IconData badgeIcon,
    required Color badgeColor,
    int xpReward = 50,
    VoidCallback? onDismiss,
  }) async {
    // Fire haptic feedback immediately on badge unlock
    await HapticFeedback.heavyImpact();

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.82),
      barrierDismissible: false,
      builder: (_) => MilestoneCelebrationModal(
        badgeTitle: badgeTitle,
        badgeDescription: badgeDescription,
        badgeIcon: badgeIcon,
        badgeColor: badgeColor,
        xpReward: xpReward,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<MilestoneCelebrationModal> createState() =>
      _MilestoneCelebrationModalState();
}

class _MilestoneCelebrationModalState
    extends State<MilestoneCelebrationModal> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _badgeController;
  late List<_ConfettiParticle> _particles;

  // Confetti color palette — festive & athletic
  static const _confettiColors = [
    AppTheme.primary,         // Neon lime green
    AppTheme.accentOrange,    // Orange
    Color(0xFFFFD600),        // Gold
    Color(0xFF00E5FF),        // Cyan
    Color(0xFFFF5252),        // Red
    Color(0xFFE040FB),        // Purple
    Color(0xFFFFFFFF),        // White
    Color(0xFF76FF03),        // Bright lime
  ];

  @override
  void initState() {
    super.initState();

    // Generate randomized confetti particles
    final rng = math.Random();
    _particles = List.generate(72, (i) {
      return _ConfettiParticle(
        angle: (i / 72) * math.pi * 2 + rng.nextDouble() * 0.4 - 0.2,
        speed: 80 + rng.nextDouble() * 200,
        color: _confettiColors[rng.nextInt(_confettiColors.length)],
        size: 5 + rng.nextDouble() * 8,
        rotation: rng.nextDouble() * math.pi * 2,
        isSquare: rng.nextBool(),
      );
    });

    // Confetti burst — fires outward then fades
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    // Badge icon bounce-in
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Stagger badge animation 400ms after confetti starts
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _badgeController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── Confetti Layer (full-screen behind modal) ──────────────
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confettiController,
                builder: (context, child) => CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _confettiController.value,
                    center: Offset(size.width / 2, size.height * 0.35),
                  ),
                  size: Size(size.width, size.height),
                ),
              ),
            ),
          ),

          // ── Main Content Card ──────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: widget.badgeColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.badgeColor.withValues(alpha: 0.25),
                  blurRadius: 40,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Headline with emoji
                Text(
                  '🎉 Achievement Unlocked!',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 350.ms),

                const SizedBox(height: 28),

                // ── Animated Badge Icon ──────────────────────────────
                _buildAnimatedBadge(),

                const SizedBox(height: 24),

                // Badge Title
                Text(
                  widget.badgeTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 400.ms)
                    .slideY(begin: 0.15, end: 0, delay: 700.ms),

                const SizedBox(height: 8),

                // Badge Description
                Text(
                  widget.badgeDescription,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.45,
                  ),
                ).animate().fadeIn(delay: 850.ms, duration: 400.ms),

                const SizedBox(height: 20),

                // XP Reward Pill
                _buildXpPill(),

                const SizedBox(height: 28),

                // Dismiss Button
                _buildDismissButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBadge() {
    return AnimatedBuilder(
      animation: _badgeController,
      builder: (_, child) {
        final bounce = _bounceOut(_badgeController.value);
        return Transform.scale(
          scale: bounce,
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing ring (always animated post-reveal)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.badgeColor.withValues(alpha: 0.25),
                width: 12,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.08, 1.08),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),

          // Middle ring
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.badgeColor.withValues(alpha: 0.45),
                width: 3,
              ),
            ),
          ),

          // Core glowing badge circle
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.badgeColor.withValues(alpha: 0.45),
                  widget.badgeColor.withValues(alpha: 0.18),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.badgeColor.withValues(alpha: 0.6),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              widget.badgeIcon,
              color: widget.badgeColor,
              size: 44,
            ),
          ),

          // Sparkle overlays on corners
          Positioned(
            top: 2,
            right: 8,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: widget.badgeColor.withValues(alpha: 0.85),
              size: 16,
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .fade(begin: 0.3, end: 1.0, duration: 900.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
          ),
          Positioned(
            bottom: 4,
            left: 6,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: widget.badgeColor.withValues(alpha: 0.65),
              size: 12,
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .fade(begin: 0.2, end: 0.9, duration: 1200.ms)
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.1, 1.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildXpPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppTheme.primary, size: 18),
          const SizedBox(width: 6),
          Text(
            '+${widget.xpReward} XP Earned',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 950.ms, duration: 350.ms)
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), delay: 950.ms);
  }

  Widget _buildDismissButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
          widget.onDismiss?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.badgeColor,
          foregroundColor: AppTheme.backgroundDark,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          'Awesome! 🎯',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1100.ms, duration: 350.ms)
        .slideY(begin: 0.2, end: 0, delay: 1100.ms);
  }

  /// Custom elastic bounce easing: overshoots then settles at 1.0
  double _bounceOut(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    }
    final f = (2 * t) - 2;
    if (t < 0.85) {
      // Overshoot peak
      return 1.0 + 0.18 * math.sin(f * math.pi * 1.2);
    }
    // Settle
    return 1.0 + (0.05 * math.sin((t - 0.85) / 0.15 * math.pi * 2)) * (1 - t);
  }
}
