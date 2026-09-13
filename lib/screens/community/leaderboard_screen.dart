import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class LeaderboardUser {
  final int rank;
  final String name;
  final String username;
  final String avatarUrl;
  final int points;
  final int streakDays;
  final bool isCurrentUser;
  final String badgeTitle;

  const LeaderboardUser({
    required this.rank,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.points,
    required this.streakDays,
    this.isCurrentUser = false,
    this.badgeTitle = "Athlete",
  });
}

class LeaderboardScreen extends StatefulWidget {
  final bool isEmbedded;
  const LeaderboardScreen({super.key, this.isEmbedded = false});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All Users", "Friends", "This Week"];

  // Top 3 Podium Users
  final LeaderboardUser _firstPlace = const LeaderboardUser(
    rank: 1,
    name: "Marcus Vance",
    username: "@marcus_fit",
    avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80",
    points: 15420,
    streakDays: 42,
    badgeTitle: "PRO ELITE",
  );

  final LeaderboardUser _secondPlace = const LeaderboardUser(
    rank: 2,
    name: "Sophia Chen",
    username: "@sophia_run",
    avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80",
    points: 13850,
    streakDays: 28,
    badgeTitle: "CHAMPION",
  );

  final LeaderboardUser _thirdPlace = const LeaderboardUser(
    rank: 3,
    name: "David Kim",
    username: "@dkim_lifts",
    avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80",
    points: 12190,
    streakDays: 19,
    badgeTitle: "WARRIOR",
  );

  // Ranked List (4th place downward)
  final List<LeaderboardUser> _rankedUsers = const [
    LeaderboardUser(
      rank: 4,
      name: "Emma Watson",
      username: "@emma_fit",
      avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&q=80",
      points: 10450,
      streakDays: 15,
      badgeTitle: "VETERAN",
    ),
    LeaderboardUser(
      rank: 5,
      name: "Alex (You)",
      username: "@alex_pulse",
      avatarUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
      points: 9820,
      streakDays: 12,
      isCurrentUser: true,
      badgeTitle: "MEMBER",
    ),
    LeaderboardUser(
      rank: 6,
      name: "Jordan Miller",
      username: "@jmiller_hiit",
      avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&q=80",
      points: 8940,
      streakDays: 9,
      badgeTitle: "CONTENDER",
    ),
    LeaderboardUser(
      rank: 7,
      name: "Liam O'Connor",
      username: "@liam_power",
      avatarUrl: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150&q=80",
      points: 8120,
      streakDays: 8,
      badgeTitle: "RISING",
    ),
    LeaderboardUser(
      rank: 8,
      name: "Zoe Martinez",
      username: "@zoe_yoga",
      avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&q=80",
      points: 7650,
      streakDays: 7,
      badgeTitle: "CONTENDER",
    ),
    LeaderboardUser(
      rank: 9,
      name: "Lucas Bennett",
      username: "@lucas_run",
      avatarUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&q=80",
      points: 6980,
      streakDays: 5,
      badgeTitle: "CHALLENGER",
    ),
    LeaderboardUser(
      rank: 10,
      name: "Aria Patel",
      username: "@aria_cardio",
      avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&q=80",
      points: 6420,
      streakDays: 4,
      badgeTitle: "CHALLENGER",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: AppTheme.backgroundDark,
              elevation: 0,
              title: Text(
                "Leaderboard",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              centerTitle: false,
            ),
      body: CustomScrollView(
        slivers: [
          // Filter Tabs (All Users / Friends / This Week)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: _buildFilterTabs(),
            ),
          ),

          // Podium Visual for Top 3 (2nd, 1st, 3rd)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: _buildPodium(),
            ),
          ),

          // Section Divider with Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Athletes",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    "Updated 5m ago",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Ranked List (Remaining Users)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = _rankedUsers[index];
                  return _buildUserRankCard(user, index);
                },
                childCount: _rankedUsers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Filter Tabs
  // ==========================================
  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _filters[index],
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // Podium Visual: 2nd, 1st, 3rd with Staggered Rise Animation
  // ==========================================
  Widget _buildPodium() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place (Silver)
          Expanded(
            child: _buildPodiumColumn(
              user: _secondPlace,
              height: 120,
              podiumColor: const Color(0xFF8CE010),
              medalIcon: Icons.military_tech_rounded,
              medalColor: const Color(0xFFC0C0C0),
              isFirst: false,
            )
                .animate()
                .slideY(begin: 0.4, end: 0, delay: 100.ms, duration: 550.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
          ),
          const SizedBox(width: 8),

          // 1st Place (Gold / Champion Center)
          Expanded(
            child: _buildPodiumColumn(
              user: _firstPlace,
              height: 160,
              podiumColor: AppTheme.primary,
              medalIcon: Icons.emoji_events_rounded,
              medalColor: const Color(0xFFFFD700),
              isFirst: true,
            )
                .animate()
                .slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
          ),
          const SizedBox(width: 8),

          // 3rd Place (Bronze)
          Expanded(
            child: _buildPodiumColumn(
              user: _thirdPlace,
              height: 95,
              podiumColor: const Color(0xFF6EAA08),
              medalIcon: Icons.workspace_premium_rounded,
              medalColor: const Color(0xFFCD7F32),
              isFirst: false,
            )
                .animate()
                .slideY(begin: 0.4, end: 0, delay: 200.ms, duration: 550.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required LeaderboardUser user,
    required double height,
    required Color podiumColor,
    required IconData medalIcon,
    required Color medalColor,
    required bool isFirst,
  }) {
    final avatarSize = isFirst ? 68.0 : 54.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown / Medal Indicator
        Icon(medalIcon, color: medalColor, size: isFirst ? 26 : 20),
        const SizedBox(height: 4),

        // Circular Profile Photo
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isFirst ? AppTheme.primary : podiumColor.withValues(alpha: 0.6),
              width: isFirst ? 3.0 : 2.0,
            ),
            boxShadow: isFirst
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: Image.network(
              user.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF222622),
                child: Icon(Icons.person, color: AppTheme.primary, size: avatarSize * 0.55),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // User Name & Score
        Text(
          user.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: isFirst ? 14 : 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          "${user.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} pts",
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isFirst ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),

        // Stepped Podium Block with Gradient & Rank Number
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                podiumColor.withValues(alpha: isFirst ? 0.95 : 0.7),
                podiumColor.withValues(alpha: 0.25),
                const Color(0xFF141714),
              ],
            ),
            border: Border.all(
              color: podiumColor.withValues(alpha: isFirst ? 0.8 : 0.4),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                width: isFirst ? 36 : 28,
                height: isFirst ? 36 : 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D0F0D).withValues(alpha: 0.8),
                  border: Border.all(color: podiumColor, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    "${user.rank}",
                    style: GoogleFonts.poppins(
                      fontSize: isFirst ? 18 : 14,
                      fontWeight: FontWeight.w900,
                      color: podiumColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department_rounded, size: 12, color: AppTheme.primary),
                  Text(
                    "${user.streakDays}d",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Ranked User List Row (Highlighted for Current User)
  // ==========================================
  Widget _buildUserRankCard(LeaderboardUser user, int index) {
    final isCurrent = user.isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppTheme.primary.withValues(alpha: 0.12)
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? AppTheme.primary
              : AppTheme.surfaceBorder,
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: 28,
            child: Text(
              "#${user.rank}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isCurrent ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? AppTheme.primary : AppTheme.surfaceBorder,
                width: 1.2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                user.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF222622),
                  child: const Icon(Icons.person, color: AppTheme.primary, size: 22),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "YOU",
                          style: GoogleFonts.manrope(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D0F0D),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  user.username,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score and Streak
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${user.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} pts",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isCurrent ? AppTheme.primary : AppTheme.textDark,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department_rounded, size: 12, color: AppTheme.primary),
                  const SizedBox(width: 2),
                  Text(
                    "${user.streakDays}d streak",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.04, end: 0);
  }
}
