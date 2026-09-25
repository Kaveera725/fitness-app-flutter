import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/milestone_celebration_modal.dart';
import '../main_tab_screen.dart';

/// Rating item model for workout effort feedback
class _EffortRating {
  final int level;
  final String emoji;
  final String label;
  final Color activeColor;

  const _EffortRating({
    required this.level,
    required this.emoji,
    required this.label,
    required this.activeColor,
  });
}

/// Workout Complete Screen
/// Shown immediately after a user completes a workout in the Workout Player.
class WorkoutCompleteScreen extends StatefulWidget {
  final String workoutName;
  final String workoutCategory;
  final int durationSeconds;
  final int caloriesBurned;
  final int exercisesCompleted;
  final int totalExercises;
  final int personalRecordsHit;
  final bool hasMilestoneUnlocked;
  final String milestoneTitle;
  final String milestoneSubtitle;
  final int milestoneXp;

  const WorkoutCompleteScreen({
    super.key,
    this.workoutName = "Upper Body Hypertrophy & Power",
    this.workoutCategory = "Strength · Biceps & Chest",
    this.durationSeconds = 2548, // ~42m 28s
    this.caloriesBurned = 384,
    this.exercisesCompleted = 8,
    this.totalExercises = 8,
    this.personalRecordsHit = 2,
    this.hasMilestoneUnlocked = true,
    this.milestoneTitle = "7-Day Streak Master!",
    this.milestoneSubtitle = "Trained 7 consecutive days · +150 XP",
    this.milestoneXp = 150,
  });

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  int? _selectedEffortLevel;

  static const List<_EffortRating> _ratings = [
    _EffortRating(level: 1, emoji: "😴", label: "Easy", activeColor: Color(0xFF64B5F6)),
    _EffortRating(level: 2, emoji: "⚡", label: "Good", activeColor: Color(0xFF81C784)),
    _EffortRating(level: 3, emoji: "🔥", label: "Challenging", activeColor: AppTheme.primary),
    _EffortRating(level: 4, emoji: "💥", label: "Brutal", activeColor: AppTheme.accentOrange),
    _EffortRating(level: 5, emoji: "💀", label: "All Out", activeColor: Color(0xFFFF5252)),
  ];

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _onDone() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainTabScreen()),
      (route) => false,
    );
  }

  void _openMilestoneModal() {
    MilestoneCelebrationModal.show(
      context,
      badgeTitle: widget.milestoneTitle,
      badgeDescription: widget.milestoneSubtitle,
      badgeIcon: Icons.local_fire_department_rounded,
      badgeColor: AppTheme.accentOrange,
      xpReward: widget.milestoneXp,
    );
  }

  void _showShareSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _WorkoutShareBottomSheet(
        workoutName: widget.workoutName,
        duration: _formatDuration(widget.durationSeconds),
        calories: widget.caloriesBurned,
        prs: widget.personalRecordsHit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top action bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "FITPULSE TRACKER",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close / Skip icon
                  IconButton(
                    onPressed: _onDone,
                    icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                    tooltip: "Close",
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // 1. Celebratory Animated Header
                    _buildCelebratoryHeader(theme),

                    const SizedBox(height: 24),

                    // 2. Stats Summary Grid (2x2)
                    _buildStatsGrid(),

                    const SizedBox(height: 18),

                    // 3. Inline Streak Milestone / Achievement Card
                    if (widget.hasMilestoneUnlocked) ...[
                      _buildMilestoneCard(),
                      const SizedBox(height: 18),
                    ],

                    // 4. "How did that feel?" Quick Feedback Row
                    _buildFeedbackSection(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTA & Share Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------
  Widget _buildCelebratoryHeader(ThemeData theme) {
    return Column(
      children: [
        // Glowing animated celebratory trophy/checkmark badge
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow halo
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.28),
                      blurRadius: 36,
                      spreadRadius: 6,
                    ),
                  ],
                ),
              ),

              // Outer dashed decorative ring
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
              ),

              // Inner solid badge container
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF2C3E14),
                      AppTheme.surfaceDark,
                    ],
                    center: Alignment(-0.2, -0.3),
                  ),
                  border: Border.all(
                    color: AppTheme.primary,
                    width: 2.2,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 44,
                  color: AppTheme.primary,
                ),
              ),
            ],
          )
              .animate()
              .scale(
                duration: 650.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0.3, 0.3),
                end: const Offset(1.0, 1.0),
              )
              .shimmer(
                delay: 700.ms,
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.4),
              ),
        ),

        const SizedBox(height: 18),

        // Bold Heading
        Text(
          "Workout Complete!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppTheme.textDark,
          ),
        )
            .animate()
            .fadeIn(delay: 150.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms),

        const SizedBox(height: 6),

        // Workout name subheading & category tag
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.workoutName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 250.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms),

        const SizedBox(height: 4),

        Text(
          widget.workoutCategory,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STATS GRID (with counting-up animations)
  // ---------------------------------------------------------------------------
  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SESSION SUMMARY",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.textMuted,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 12, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    "All sets recorded",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AnimatedStatBlock(
                title: "DURATION",
                displayValue: _formatDuration(widget.durationSeconds),
                unit: "mins",
                icon: Icons.timer_outlined,
                accentColor: AppTheme.primary,
                delayMs: 350,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnimatedCountStatBlock(
                title: "CALORIES",
                targetValue: widget.caloriesBurned,
                unit: "kcal",
                icon: Icons.local_fire_department_rounded,
                accentColor: AppTheme.accentOrange,
                delayMs: 450,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AnimatedCountStatBlock(
                title: "EXERCISES",
                targetValue: widget.exercisesCompleted,
                totalValue: widget.totalExercises,
                unit: "completed",
                icon: Icons.fitness_center_rounded,
                accentColor: const Color(0xFF00E5FF),
                delayMs: 550,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnimatedCountStatBlock(
                title: "PERSONAL RECORDS",
                targetValue: widget.personalRecordsHit,
                unit: "new PRs",
                icon: Icons.military_tech_rounded,
                accentColor: AppTheme.accentPurple,
                delayMs: 650,
                isHighlight: widget.personalRecordsHit > 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // INLINE STREAK MILESTONE CARD
  // ---------------------------------------------------------------------------
  Widget _buildMilestoneCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentOrange.withValues(alpha: 0.16),
            AppTheme.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.accentOrange.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentOrange.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openMilestoneModal,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Glowing flame icon badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.accentOrange,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppTheme.accentOrange,
                    size: 26,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.08, 1.08),
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    ),

                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.milestoneTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "+${widget.milestoneXp} XP",
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0D0F0D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.milestoneSubtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Claim / View Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentOrange.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentOrange,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: AppTheme.accentOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 750.ms, duration: 500.ms)
        .slideY(begin: 0.15, end: 0, duration: 500.ms);
  }

  // ---------------------------------------------------------------------------
  // "HOW DID THAT FEEL?" QUICK FEEDBACK ROW
  // ---------------------------------------------------------------------------
  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "HOW DID THAT FEEL?",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppTheme.textMuted,
                ),
              ),
              if (_selectedEffortLevel != null)
                Text(
                  "Saved for Coach AI",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ).animate().fadeIn(duration: 200.ms),
            ],
          ),
          const SizedBox(height: 14),

          // 5 Emoji ratings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _ratings.map((rating) {
              final isSelected = _selectedEffortLevel == rating.level;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedEffortLevel = rating.level;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? rating.activeColor.withValues(alpha: 0.18)
                        : AppTheme.surfaceLighter,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? rating.activeColor : AppTheme.surfaceBorder,
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: rating.activeColor.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        rating.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rating.label,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? rating.activeColor : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 850.ms, duration: 500.ms)
        .slideY(begin: 0.15, end: 0, duration: 500.ms);
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTION BAR (Share & Done CTA)
  // ---------------------------------------------------------------------------
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: const Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Share Button (Outlined Athletic Style)
          Container(
            height: 52,
            width: 54,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLighter,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceBorder, width: 1.2),
            ),
            child: IconButton(
              onPressed: _showShareSheet,
              icon: const Icon(
                Icons.share_outlined,
                color: AppTheme.textDark,
                size: 20,
              ),
              tooltip: "Share Workout",
            ),
          ),

          const SizedBox(width: 12),

          // Primary "Done" Button
          Expanded(
            child: CustomButton(
              text: "Done",
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                size: 18,
                color: Color(0xFF0D0F0D),
              ),
              onPressed: _onDone,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 950.ms, duration: 400.ms);
  }
}

// =============================================================================
// HELPER STAT BLOCKS WITH ANIMATIONS
// =============================================================================

class _AnimatedStatBlock extends StatelessWidget {
  final String title;
  final String displayValue;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final int delayMs;

  const _AnimatedStatBlock({
    required this.title,
    required this.displayValue,
    required this.unit,
    required this.icon,
    required this.accentColor,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayValue,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }
}

class _AnimatedCountStatBlock extends StatelessWidget {
  final String title;
  final int targetValue;
  final int? totalValue;
  final String unit;
  final IconData icon;
  final Color accentColor;
  final int delayMs;
  final bool isHighlight;

  const _AnimatedCountStatBlock({
    required this.title,
    required this.targetValue,
    this.totalValue,
    required this.unit,
    required this.icon,
    required this.accentColor,
    required this.delayMs,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isHighlight
              ? accentColor.withValues(alpha: 0.5)
              : AppTheme.surfaceBorder,
          width: 1,
        ),
        boxShadow: isHighlight
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isHighlight ? accentColor : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: targetValue),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              final valString = totalValue != null ? "$val/$totalValue" : "$val";
              return Text(
                valString,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isHighlight ? accentColor : AppTheme.textDark,
                  letterSpacing: -0.5,
                ),
              );
            },
          ),
          Text(
            unit,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }
}

// =============================================================================
// SHARE BOTTOM SHEET MODAL (UI Only)
// =============================================================================

class _WorkoutShareBottomSheet extends StatelessWidget {
  final String workoutName;
  final String duration;
  final int calories;
  final int prs;

  const _WorkoutShareBottomSheet({
    required this.workoutName,
    required this.duration,
    required this.calories,
    required this.prs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            Text(
              "Share Your Workout",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Inspire your fitness circle with your session progress",
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Share Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.surfaceLighter,
                    AppTheme.backgroundDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "FITPULSE CRUSHED",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.flash_on_rounded, color: AppTheme.primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    workoutName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _shareStatPill("⏱ $duration", "Duration"),
                      _shareStatPill("🔥 $calories", "Calories"),
                      _shareStatPill("🏆 $prs", "New PRs"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Social channels row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialOption(
                  icon: Icons.camera_alt_rounded,
                  label: "Instagram",
                  color: const Color(0xFFE1306C),
                  onTap: () => _copyAndToast(context, "Ready to share to Instagram Story!"),
                ),
                _SocialOption(
                  icon: Icons.chat_bubble_rounded,
                  label: "WhatsApp",
                  color: const Color(0xFF25D366),
                  onTap: () => _copyAndToast(context, "Workout link shared to WhatsApp!"),
                ),
                _SocialOption(
                  icon: Icons.tag_rounded,
                  label: "Twitter / X",
                  color: const Color(0xFF1DA1F2),
                  onTap: () => _copyAndToast(context, "Workout stats copied for X!"),
                ),
                _SocialOption(
                  icon: Icons.link_rounded,
                  label: "Copy Link",
                  color: AppTheme.primary,
                  onTap: () => _copyAndToast(context, "Workout summary link copied to clipboard!"),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _shareStatPill(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  void _copyAndToast(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.primary, width: 1),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SocialOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
