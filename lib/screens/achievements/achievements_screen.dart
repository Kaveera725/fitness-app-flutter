import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/milestone_celebration_modal.dart';
import 'models/achievement_data.dart';
import 'models/achievement_model.dart';

/// The dedicated full Achievements screen.
///
/// Features:
/// - Level & XP progress banner header
/// - Category filter chips (All / Streaks / Workouts / Consistency / Milestones)
/// - 2-column grid: earned in full color, locked greyed-out with silhouette + progress bar
/// - Tap any badge → detail bottom-sheet popup
/// - "Celebrate" button on earned badges replays the MilestoneCelebrationModal
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  AchievementCategory? _selectedCategory; // null = All
  late TabController _tabController;

  final _allCategories = AchievementCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _allCategories.length + 1, // +1 for "All"
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AchievementItem> get _filtered {
    if (_selectedCategory == null) return AchievementData.all;
    return AchievementData.forCategory(_selectedCategory!);
  }

  @override
  Widget build(BuildContext context) {
    final earned = AchievementData.earnedCount;
    final total = AchievementData.all.length;
    final totalXp = AchievementData.totalXpEarned;
    final completionPct = ((earned / total) * 100).round();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Level & XP Banner ──────────────────────────────────
            _LevelBanner(
              earned: earned,
              total: total,
              totalXp: totalXp,
              completionPct: completionPct,
            ),

            const SizedBox(height: 22),

            // ── Category Filter Chips ──────────────────────────────
            _CategoryFilter(
              selected: _selectedCategory,
              onChanged: (cat) => setState(() => _selectedCategory = cat),
            ),

            const SizedBox(height: 20),

            // ── Section Label ──────────────────────────────────────
            _buildSectionLabel(earned, total),

            const SizedBox(height: 14),

            // ── Badge Grid ─────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (ctx, i) {
                final badge = _filtered[i];
                return _BadgeCard(
                  badge: badge,
                  index: i,
                  onTap: () => _showBadgeDetail(badge),
                );
              },
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppTheme.textDark,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Achievements',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textDark,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFFFD600).withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFD600), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Lv 4',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFD600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(int earned, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedCategory == null
              ? 'All Badges'
              : '${_selectedCategory!.label} Badges',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          '${_filtered.where((b) => b.isEarned).length} / ${_filtered.length} Earned',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showBadgeDetail(AchievementItem badge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BadgeDetailSheet(
        badge: badge,
        onCelebrate: badge.isEarned
            ? () {
                Navigator.pop(context);
                MilestoneCelebrationModal.show(
                  context,
                  badgeTitle: badge.title,
                  badgeDescription: badge.description,
                  badgeIcon: badge.icon,
                  badgeColor: badge.color,
                  xpReward: badge.xpReward,
                );
              }
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _LevelBanner extends StatelessWidget {
  final int earned;
  final int total;
  final int totalXp;
  final int completionPct;

  const _LevelBanner({
    required this.earned,
    required this.total,
    required this.totalXp,
    required this.completionPct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar ring
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, Color(0xFF7DBF10)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFF0D0F0D),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level 4 Athlete',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$earned of $total badges earned  •  $totalXp XP',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$completionPct%',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar toward next level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level 5',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '$totalXp / 1500 XP',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (totalXp / 1500).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: const Color(0xFF141714),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick stat pills row
          Row(
            children: [
              _statPill('🔥', 'Current Streak', '12 days', AppTheme.accentOrange),
              const SizedBox(width: 8),
              _statPill('🏋️', 'Workouts', '64 done', AppTheme.primary),
              const SizedBox(width: 8),
              _statPill('⭐', 'Total XP', '$totalXp pts', const Color(0xFFFFD600)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0);
  }

  Widget _statPill(String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 9,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY FILTER
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryFilter extends StatelessWidget {
  final AchievementCategory? selected;
  final ValueChanged<AchievementCategory?> onChanged;

  const _CategoryFilter({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          // "All" chip
          _chip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => onChanged(null),
          ),
          ...AchievementCategory.values.map(
            (cat) => _chip(
              label: cat.label,
              isSelected: selected == cat,
              onTap: () => onChanged(cat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : const Color(0xFF141714),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color:
                  isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BADGE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeCard extends StatelessWidget {
  final AchievementItem badge;
  final int index;
  final VoidCallback onTap;

  const _BadgeCard({
    required this.badge,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEarned = badge.isEarned;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEarned
                ? badge.rarityGlowColor.withValues(alpha: 0.4)
                : AppTheme.surfaceBorder,
            width: 1,
          ),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: badge.rarityGlowColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Top: Category + State indicator ─────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isEarned ? badge.color : AppTheme.textMuted)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge.category.label,
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isEarned ? badge.color : AppTheme.textMuted,
                    ),
                  ),
                ),
                Icon(
                  isEarned
                      ? Icons.verified_rounded
                      : Icons.lock_outline_rounded,
                  size: 16,
                  color: isEarned ? badge.rarityGlowColor : AppTheme.textMuted,
                ),
              ],
            ),

            // ── Center: Glowing badge icon ───────────────────────
            _buildBadgeIcon(isEarned),

            // ── Bottom: Title, earned date or progress ───────────
            Column(
              children: [
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isEarned ? AppTheme.textDark : AppTheme.textSecondary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                if (isEarned)
                  _earnedBadge()
                else
                  _progressIndicator(),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 45).ms, duration: 320.ms)
        .slideY(begin: 0.08, end: 0, delay: (index * 45).ms);
  }

  Widget _buildBadgeIcon(bool isEarned) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEarned
            ? badge.color.withValues(alpha: 0.2)
            : const Color(0xFF1A1D1A),
        border: Border.all(
          color: isEarned
              ? badge.rarityGlowColor.withValues(alpha: 0.6)
              : AppTheme.surfaceBorder,
          width: 2,
        ),
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: badge.rarityGlowColor.withValues(alpha: 0.3),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isEarned
          ? Icon(badge.icon, color: badge.color, size: 30)
          // Locked silhouette — desaturated + slightly blurred via opacity/color
          : ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.212, 0.715, 0.072, 0, 0,
                0.212, 0.715, 0.072, 0, 0,
                0.212, 0.715, 0.072, 0, 0,
                0, 0, 0, 0.35, 0,
              ]),
              child: Icon(badge.icon, color: AppTheme.textMuted, size: 30),
            ),
    );
  }

  Widget _earnedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badge.earnedDateFormatted.isNotEmpty
            ? 'Earned ${badge.earnedDateFormatted}'
            : 'Earned ✓',
        style: GoogleFonts.manrope(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    return Column(
      children: [
        Text(
          badge.progressLabel,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: badge.progressFraction,
            minHeight: 4,
            backgroundColor: const Color(0xFF141714),
            valueColor: AlwaysStoppedAnimation<Color>(
              badge.color.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BADGE DETAIL BOTTOM-SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeDetailSheet extends StatelessWidget {
  final AchievementItem badge;
  final VoidCallback? onCelebrate;

  const _BadgeDetailSheet({
    required this.badge,
    this.onCelebrate,
  });

  @override
  Widget build(BuildContext context) {
    final isEarned = badge.isEarned;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: badge.rarityGlowColor.withValues(alpha: isEarned ? 0.4 : 0.2),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Large glowing badge icon ─────────────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: badge.rarityGlowColor.withValues(
                        alpha: isEarned ? 0.25 : 0.1,
                      ),
                      width: 10,
                    ),
                  ),
                ),
                // Inner badge
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isEarned
                        ? badge.color.withValues(alpha: 0.2)
                        : const Color(0xFF1A1D1A),
                    border: Border.all(
                      color: isEarned
                          ? badge.rarityGlowColor.withValues(alpha: 0.6)
                          : AppTheme.surfaceBorder,
                      width: 2,
                    ),
                    boxShadow: isEarned
                        ? [
                            BoxShadow(
                              color: badge.rarityGlowColor.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isEarned
                      ? Icon(badge.icon, color: badge.color, size: 44)
                      : ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.212, 0.715, 0.072, 0, 0,
                            0.212, 0.715, 0.072, 0, 0,
                            0.212, 0.715, 0.072, 0, 0,
                            0, 0, 0, 0.4, 0,
                          ]),
                          child: Icon(badge.icon, color: AppTheme.textMuted, size: 44),
                        ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Rarity & Category tags
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tag(badge.rarityLabel, badge.rarityGlowColor),
                const SizedBox(width: 8),
                _tag(badge.category.label, AppTheme.textSecondary),
              ],
            ),

            const SizedBox(height: 14),

            // Title
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Info grid: How to earn, XP reward, earned date
            _buildInfoGrid(isEarned),

            const SizedBox(height: 20),

            if (!isEarned) ...[
              // Progress section for locked badges
              _buildProgressSection(),
              const SizedBox(height: 20),
            ],

            // CTA Button
            if (isEarned)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onCelebrate,
                  icon: const Text('🎉', style: TextStyle(fontSize: 16)),
                  label: Text(
                    'Celebrate Again',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: badge.color,
                    foregroundColor: AppTheme.backgroundDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.lock_outline_rounded, size: 18),
                  label: Text(
                    'Keep Grinding — You Got This!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(bool isEarned) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141714),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.help_outline_rounded,
            'How to Earn',
            badge.howToEarn,
          ),
          const Divider(color: AppTheme.surfaceBorder, height: 20),
          _infoRow(
            Icons.star_rounded,
            'XP Reward',
            '+${badge.xpReward} XP on unlock',
          ),
          if (isEarned && badge.earnedDateFormatted.isNotEmpty) ...[
            const Divider(color: AppTheme.surfaceBorder, height: 20),
            _infoRow(
              Icons.calendar_today_rounded,
              'Earned Date',
              badge.earnedDateFormatted,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141714),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                badge.progressLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: badge.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: badge.progressFraction,
              minHeight: 10,
              backgroundColor: AppTheme.surfaceDark,
              valueColor: AlwaysStoppedAnimation<Color>(badge.color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(badge.progressFraction * 100).round()}% complete — '
            '${badge.targetProgress - badge.currentProgress} ${badge.progressUnit} to go!',
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
