import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_ring.dart';
import 'workout_detail_screen.dart';
import 'workout_library_screen.dart';
import 'subscription/subscription_screen.dart';
import 'coaches/find_coach_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _ActivityData {
  final String dayShort;
  final String dayName;
  final double calories;
  final bool isWeekend;
  final String focus;

  const _ActivityData({
    required this.dayShort,
    required this.dayName,
    required this.calories,
    required this.isWeekend,
    required this.focus,
  });
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  // Realistic 7-day variation data (Monday through Sunday)
  static const List<_ActivityData> _weeklyActivity = [
    _ActivityData(dayShort: "M", dayName: "Mon", calories: 1420, isWeekend: false, focus: "Upper Body Strength"),
    _ActivityData(dayShort: "T", dayName: "Tue", calories: 2180, isWeekend: false, focus: "HIIT & Cardio"),
    _ActivityData(dayShort: "W", dayName: "Wed", calories: 1350, isWeekend: false, focus: "Active Recovery"),
    _ActivityData(dayShort: "T", dayName: "Thu", calories: 2450, isWeekend: false, focus: "Legs & Core Power"),
    _ActivityData(dayShort: "F", dayName: "Fri", calories: 1980, isWeekend: false, focus: "Full Body Circuit"),
    _ActivityData(dayShort: "S", dayName: "Sat", calories: 2850, isWeekend: true,  focus: "Weekend Outdoor Run"),
    _ActivityData(dayShort: "S", dayName: "Sun", calories: 920,  isWeekend: true,  focus: "Rest & Mobility"),
  ];

  late int _todayIndex;
  late int _selectedDayIndex;

  @override
  void initState() {
    super.initState();
    // 0 = Monday ... 6 = Sunday. Clamp within valid bounds
    _todayIndex = (DateTime.now().weekday - 1).clamp(0, 6);
    _selectedDayIndex = _todayIndex;
  }

  String _getGreetingName(UserSession? user) {
    if (user == null) return "Alex";
    final rawName = user.name?.trim() ?? "";
    if (rawName.isEmpty ||
        rawName.toLowerCase() == "member" ||
        rawName.toLowerCase() == "user" ||
        rawName.toLowerCase() == "premium") {
      final emailPrefix = user.email.split('@').first;
      if (emailPrefix.toLowerCase() == "member" || emailPrefix.isEmpty) {
        return "Alex";
      }
      return emailPrefix[0].toUpperCase() + emailPrefix.substring(1);
    }
    return rawName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ApiService.instance.currentUser;
    final isPremium = currentUser?.isPremium == true;
    final isCoach = currentUser?.isCoach == true;
    final isAdmin = currentUser?.isAdmin == true;
    final isMember = !isPremium && !isCoach && !isAdmin;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Greeting header with bold white name and MEMBER badge
              _buildHeader(theme, currentUser, isPremium, isCoach, isAdmin),
              const SizedBox(height: 18),

              // 2. Daily Goal Card (dark card with glowing neon green ring and white numbers)
              _buildTodayProgress(theme, isPremium)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 16),

              // 3. New Challenge Streak Banner: "2 Weeks of Energy" with neon START button
              _buildChallengeBanner(context)
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 16),

              // Contextual Member / Pro Perks
              if (isMember) ...[
                _buildMemberUpgradeBanner(context),
                const SizedBox(height: 16),
              ] else if (isPremium) ...[
                _buildPremiumPerksBar(context),
                const SizedBox(height: 16),
              ],

              // 4. Quick Metrics Row (Distinct icon colors, neon green progress bars)
              _buildQuickMetricsRow(theme)
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 20),

              // 5. Meaningful Weekly Activity Chart with glowing neon today rod
              _buildWeeklyActivity(theme)
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 20),

              // 6. Today's Plan Workout Section with full-bleed cards and neon pills
              _buildTodayWorkout(context, theme, isPremium)
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0, duration: 400.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header: Greeting & Role Badge
  // ==========================================
  Widget _buildHeader(
    ThemeData theme,
    UserSession? currentUser,
    bool isPremium,
    bool isCoach,
    bool isAdmin,
  ) {
    final displayName = _getGreetingName(currentUser);

    Color badgeColor = AppTheme.primary;
    IconData badgeIcon = Icons.person_rounded;
    String pillLabel = "MEMBER";

    if (isAdmin) {
      badgeColor = Colors.deepOrange;
      badgeIcon = Icons.shield_rounded;
      pillLabel = "ADMIN";
    } else if (isCoach) {
      badgeColor = Colors.cyan;
      badgeIcon = Icons.sports_rounded;
      pillLabel = "COACH";
    } else if (isPremium) {
      badgeColor = AppTheme.accentPurple;
      badgeIcon = Icons.star_rounded;
      pillLabel = "PREMIUM";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Good Morning,",
                  style: GoogleFonts.manrope(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                // Dark pill with neon green text/icon for MEMBER
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 11, color: badgeColor),
                      const SizedBox(width: 4),
                      Text(
                        pillLabel,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              displayName,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark, // Bold white/off-white
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Profile Avatar
        Container(
          padding: EdgeInsets.all(isPremium ? 2.5 : 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPremium ? AppTheme.accentPurple : AppTheme.surfaceBorder,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: const Color(0xFF1E221E),
              child: Image.network(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: AppTheme.primary,
                    size: 26,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. Daily Goal Card (Dark Card with Glowing Neon Progress Ring)
  // ==========================================
  Widget _buildTodayProgress(ThemeData theme, bool isPremium) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.surfaceBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222622),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.surfaceBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, size: 13, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            isPremium ? "PRO DAILY GOAL" : "DAILY GOAL",
                            style: GoogleFonts.manrope(
                              color: AppTheme.textDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            size: 13,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "5-Day Streak",
                            style: GoogleFonts.manrope(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "1,250",
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark, // Large bold white numbers
                        letterSpacing: -0.5,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "/ 2,000 kcal",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "750 kcal remaining to reach target",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ProgressRing(
            progress: 0.625,
            color: AppTheme.primary,
            size: 92,
            strokeWidth: 9,
            centerContent: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppTheme.primary,
                  size: 22,
                ),
                const SizedBox(height: 2),
                Text(
                  "63%",
                  style: GoogleFonts.poppins(
                    color: AppTheme.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(delay: 150.ms, duration: 500.ms, curve: Curves.easeOutBack)
              .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  // ==========================================
  // 3. Horizontal Streak/Challenge Banner ("2 Weeks of Energy")
  // ==========================================
  Widget _buildChallengeBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Glowing Trophy/Streak Icon Circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppTheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Challenge Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "NEW CHALLENGE",
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "2 Weeks of Energy",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  "14 days • 10 workouts to complete",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // START Button in Neon Green
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutLibraryScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: const Color(0xFF0D0F0D),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(64, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              "START",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: const Color(0xFF0D0F0D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Member: Pro Upgrade Banner
  // ==========================================
  Widget _buildMemberUpgradeBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentPurple.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.accentPurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upgrade to FitPulse Pro",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  "Unlock 1-on-1 coach, custom diets & HD routines",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(64, 34),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              "Upgrade",
              style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Premium Member: Active Perks Bar
  // ==========================================
  Widget _buildPremiumPerksBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppTheme.accentPurple, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FitPulse VIP Member • Pro Active",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentPurple,
                  ),
                ),
                Text(
                  "AI Recovery: 94% Optimal • Coach Marcus Vance assigned",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FindCoachScreen()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Coach",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppTheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. Quick Metrics Row (Distinct Icon Accents, Neon Green Progress)
  // ==========================================
  Widget _buildQuickMetricsRow(ThemeData theme) {
    return Row(
      children: const [
        // Metric 1: Steps (Orange icon accent, Neon green progress bar)
        Expanded(
          child: StatCard(
            title: "Steps",
            value: "8,432",
            target: "8.4k / 10k",
            progress: 0.84,
            trend: "+12%",
            trendPositive: true,
            icon: Icons.directions_walk_rounded,
            color: Color(0xFFFF9100), // Distinct orange accent
            progressColor: AppTheme.primary, // Neon green fill for consistency
          ),
        ),
        SizedBox(width: 10),

        // Metric 2: Water (Blue icon accent, Neon green progress bar)
        Expanded(
          child: StatCard(
            title: "Water",
            value: "2.1 L",
            target: "2.1 / 3.0 L",
            progress: 0.70,
            trend: "+8%",
            trendPositive: true,
            icon: Icons.water_drop_rounded,
            color: Color(0xFF00B0FF), // Distinct blue accent
            progressColor: AppTheme.primary, // Neon green fill for consistency
          ),
        ),
        SizedBox(width: 10),

        // Metric 3: Sleep (Purple icon accent, Neon green progress bar)
        Expanded(
          child: StatCard(
            title: "Sleep",
            value: "7h 45m",
            target: "7.8 / 8.0 h",
            progress: 0.97,
            trend: "97%",
            trendPositive: true,
            icon: Icons.bedtime_rounded,
            color: Color(0xFF9D4EDD), // Distinct purple accent
            progressColor: AppTheme.primary, // Neon green fill for consistency
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. Meaningful Weekly Activity Chart
  // ==========================================
  Widget _buildWeeklyActivity(ThemeData theme) {
    final selectedDay = _weeklyActivity[_selectedDayIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Activity Header + Interactive Selected Day Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activity",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  "Weekly Total: 13,150 kcal • Avg: 1,878 kcal",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),

            // Interactive Day Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selectedDay.isWeekend
                    ? const Color(0xFF1E2822)
                    : AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedDay.isWeekend
                      ? const Color(0xFF334B38)
                      : AppTheme.primary.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedDay.isWeekend ? Icons.nature_people_rounded : Icons.fitness_center_rounded,
                    size: 13,
                    color: selectedDay.isWeekend ? const Color(0xFF76D799) : AppTheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${selectedDay.dayName}: ${selectedDay.calories.toInt()} kcal",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selectedDay.isWeekend ? const Color(0xFF76D799) : AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bar Chart Card
        Container(
          height: 195,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.surfaceBorder, width: 1),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 3200,
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (event is FlTapUpEvent &&
                      barTouchResponse != null &&
                      barTouchResponse.spot != null) {
                    final touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    if (touchedIndex >= 0 && touchedIndex < _weeklyActivity.length) {
                      setState(() {
                        _selectedDayIndex = touchedIndex;
                      });
                    }
                  }
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => const Color(0xFF141714),
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = _weeklyActivity[group.x.toInt()];
                    return BarTooltipItem(
                      "${item.dayName} ${group.x.toInt() == _todayIndex ? '(Today)' : ''}\n",
                      const TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "${item.calories.toInt()} kcal\n",
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: item.focus,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < _weeklyActivity.length) {
                        final item = _weeklyActivity[index];
                        final isToday = index == _todayIndex;
                        final isSelected = index == _selectedDayIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.dayShort,
                                  style: TextStyle(
                                    color: isToday
                                        ? AppTheme.primary
                                        : (isSelected
                                            ? AppTheme.textDark
                                            : (item.isWeekend
                                                ? const Color(0xFF6A7F70)
                                                : AppTheme.textSecondary)),
                                    fontSize: 12,
                                    fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                if (isToday)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primary.withValues(alpha: 0.6),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  )
                                else if (item.isWeekend)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF435848),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(_weeklyActivity.length, (index) {
                return _buildBarGroupData(index, _weeklyActivity[index], theme);
              }),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroupData(int x, _ActivityData data, ThemeData theme) {
    final isToday = x == _todayIndex;
    final isSelected = x == _selectedDayIndex;
    final isWeekend = data.isWeekend;

    // Distinct Rod Colors:
    // Today: Glowing neon green gradient
    // Weekend: Muted slate-forest tone
    // Past days: Muted grey/white tone
    Color rodColor;
    if (isToday) {
      rodColor = AppTheme.primary;
    } else if (isWeekend) {
      rodColor = const Color(0xFF2C382F);
    } else if (isSelected) {
      rodColor = const Color(0xFF5A635A);
    } else {
      rodColor = const Color(0xFF383E38);
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: data.calories,
          color: rodColor,
          gradient: isToday
              ? const LinearGradient(
                  colors: [Color(0xFF8CE00A), AppTheme.primary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              : null,
          width: isToday ? 15 : (isWeekend ? 13 : 12),
          borderRadius: BorderRadius.circular(6),
          borderSide: isToday
              ? const BorderSide(color: AppTheme.primary, width: 1.5)
              : (isSelected ? const BorderSide(color: Colors.white38, width: 1.2) : BorderSide.none),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 3200,
            color: isToday
                ? AppTheme.primary.withValues(alpha: 0.1)
                : const Color(0xFF141714),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 6. Today's Plan Section (Full-Bleed Images, Dark Gradients, Neon Pills)
  // ==========================================
  Widget _buildTodayWorkout(BuildContext context, ThemeData theme, bool isPremium) {
    final picks = [
      {
        "title": "Upper Body Hypertrophy",
        "duration": "40 min",
        "difficulty": "Intermediate",
        "calories": "380 kcal",
        "image": "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800&q=80",
        "tag": isPremium ? "⭐ PRO RECOMMENDED" : "TODAY'S MAIN PICK",
      },
      {
        "title": "Mobility & Core Flow",
        "duration": "18 min",
        "difficulty": "All Levels",
        "calories": "140 kcal",
        "image": "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=80",
        "tag": "ACTIVE RECOVERY",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Plan",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkoutLibraryScreen()),
                );
              },
              child: Text(
                "See All",
                style: GoogleFonts.manrope(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 14,
              color: isPremium ? AppTheme.accentPurple : AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              isPremium
                  ? "Personalized for you • Matched to your 94% recovery score"
                  : "Personalized for you • Based on your daily goals & routine",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPremium ? AppTheme.accentPurple : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: picks.map((workout) {
            return _buildPickCard(context, theme, workout);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPickCard(BuildContext context, ThemeData theme, Map<String, String> workout) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailScreen(
              title: workout["title"]!,
              imageUrl: workout["image"]!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Full-bleed Image with fallback
              Positioned.fill(
                child: Image.network(
                  workout["image"]!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1B201B),
                      child: const Center(
                        child: Icon(Icons.fitness_center_rounded, color: AppTheme.primary, size: 40),
                      ),
                    );
                  },
                ),
              ),
              // Dark Athletic Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0D0F0D).withValues(alpha: 0.4),
                      const Color(0xFF0D0F0D).withValues(alpha: 0.95),
                    ],
                    stops: const [0.15, 0.5, 1.0],
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141714).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        workout["tag"]!,
                        style: GoogleFonts.manrope(
                          color: AppTheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 52),

                    // Title
                    Text(
                      workout["title"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Duration, Difficulty, and Calorie Badges in Neon Green Pills
                    Row(
                      children: [
                        _buildNeonPill(Icons.timer_outlined, workout["duration"]!),
                        const SizedBox(width: 8),
                        _buildNeonPill(Icons.fitness_center_outlined, workout["difficulty"]!),
                        const SizedBox(width: 8),
                        _buildNeonPill(Icons.local_fire_department_outlined, workout["calories"]!),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 18,
                            color: Color(0xFF0D0F0D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF141714).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
