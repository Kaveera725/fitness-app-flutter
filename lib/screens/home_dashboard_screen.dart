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
    // Return first name cleanly
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fix 1: Real user greeting with role badge pill
              _buildHeader(theme, currentUser, isPremium, isCoach, isAdmin),
              const SizedBox(height: 18),

              // Daily Goal Ring Card
              _buildTodayProgress(theme, isPremium),
              const SizedBox(height: 16),

              // Premium / Member Contextual Status & Upgrade Callout
              if (isMember) ...[
                _buildMemberUpgradeBanner(context),
                const SizedBox(height: 16),
              ] else if (isPremium) ...[
                _buildPremiumPerksBar(context),
                const SizedBox(height: 16),
              ],

              // Fix 2 & Fix 4: Combined compact 3-metric row with trends and progress
              _buildQuickMetricsRow(theme),
              const SizedBox(height: 20),

              // Fix 3: Dynamic meaningful weekly activity chart
              _buildWeeklyActivity(theme),
              const SizedBox(height: 20),

              // Fix 5: Personalized Today's Picks
              _buildTodayWorkout(context, theme, isPremium),
              const SizedBox(height: 24),
            ],
          ).animate().fade().slideY(begin: 0.05, end: 0, duration: 350.ms),
        ),
      ),
    );
  }

  // ==========================================
  // FIX 1: Real User Header & Role Badge
  // ==========================================
  Widget _buildHeader(
    ThemeData theme,
    UserSession? currentUser,
    bool isPremium,
    bool isCoach,
    bool isAdmin,
  ) {
    final displayName = _getGreetingName(currentUser);
    final roleTitle = currentUser?.roleTitle ?? "Member";

    Color badgeColor;
    IconData badgeIcon;
    if (isAdmin) {
      badgeColor = Colors.deepOrange;
      badgeIcon = Icons.shield_rounded;
    } else if (isCoach) {
      badgeColor = Colors.cyan;
      badgeIcon = Icons.sports_rounded;
    } else if (isPremium) {
      badgeColor = const Color(0xFFFFB300);
      badgeIcon = Icons.star_rounded;
    } else {
      badgeColor = AppTheme.primary;
      badgeIcon = Icons.person_rounded;
    }

    final pillLabel = isPremium
        ? "PREMIUM"
        : (isCoach
            ? "COACH"
            : (isAdmin ? "ADMIN" : "MEMBER"));

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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                // Small Role Badge Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: badgeColor.withOpacity(0.4),
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
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              displayName,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Profile Avatar (Gold ring for Premium)
        Container(
          padding: EdgeInsets.all(isPremium ? 2.5 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isPremium
                ? const LinearGradient(
                    colors: [Color(0xFFFFD54F), Color(0xFFFF8F00), Color(0xFF7C4DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: isPremium
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: ClipOval(
            child: Container(
              width: 52,
              height: 52,
              color: theme.colorScheme.primary.withOpacity(0.2),
              child: Image.network(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                    size: 28,
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
  // Daily Goal Card
  // ==========================================
  Widget _buildTodayProgress(ThemeData theme, bool isPremium) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [const Color(0xFF4A148C), const Color(0xFF6A1B9A), const Color(0xFF7B1FA2)]
              : [AppTheme.primaryDark, AppTheme.primary, const Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.32),
            blurRadius: 16,
            offset: const Offset(0, 8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, size: 13, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            isPremium ? "PRO DAILY GOAL" : "DAILY GOAL",
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "🔥 5-Day Streak",
                        style: GoogleFonts.manrope(
                          color: AppTheme.accentGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "1,250",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "/ 2,000 kcal",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "750 kcal remaining to reach target",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          ProgressRing(
            progress: 0.625,
            color: AppTheme.accentGreen,
            size: 88,
            strokeWidth: 9,
            centerContent: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: AppTheme.accentGreen,
                  size: 24,
                ),
                Text(
                  "63%",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().scale(delay: 150.ms, duration: 450.ms, curve: Curves.easeOutBack),
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C4DFF).withOpacity(0.12),
            const Color(0xFFFFB300).withOpacity(0.14),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB300).withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFA000), size: 20),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "Unlock 1-on-1 coach, custom diets & HD routines",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: Colors.grey.shade600,
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
              backgroundColor: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(64, 34),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        color: const Color(0xFFFFB300).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB300).withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Color(0xFFFFA000), size: 20),
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
                    color: const Color(0xFFE65100),
                  ),
                ),
                Text(
                  "AI Recovery: 94% Optimal • Coach Marcus Vance assigned",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: Colors.grey.shade700,
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
  // FIX 2 & FIX 4: Compact 3-Metric Row
  // ==========================================
  Widget _buildQuickMetricsRow(ThemeData theme) {
    return Row(
      children: const [
        // Metric 1: Steps
        Expanded(
          child: StatCard(
            title: "Steps",
            value: "8,432",
            target: "8.4k / 10k",
            progress: 0.84,
            trend: "+12%",
            trendPositive: true,
            icon: Icons.directions_walk_rounded,
            color: AppTheme.accentOrange,
          ),
        ),
        SizedBox(width: 10),

        // Metric 2: Water
        Expanded(
          child: StatCard(
            title: "Water",
            value: "2.1 L",
            target: "2.1 / 3.0 L",
            progress: 0.70,
            trend: "+8%",
            trendPositive: true,
            icon: Icons.water_drop_rounded,
            color: Color(0xFF00B0FF),
          ),
        ),
        SizedBox(width: 10),

        // Metric 3: Sleep
        Expanded(
          child: StatCard(
            title: "Sleep",
            value: "7h 45m",
            target: "7.8 / 8.0 h",
            progress: 0.97,
            trend: "97%",
            trendPositive: true,
            icon: Icons.bedtime_rounded,
            color: Color(0xFF7C4DFF),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FIX 3: Dynamic Meaningful Activity Chart
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
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Weekly Total: 13,150 kcal • Avg: 1,878 kcal",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            // Interactive Day Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: selectedDay.isWeekend
                    ? Colors.teal.withOpacity(0.12)
                    : AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedDay.isWeekend
                      ? Colors.teal.withOpacity(0.4)
                      : AppTheme.primary.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedDay.isWeekend ? Icons.nature_people_rounded : Icons.fitness_center_rounded,
                    size: 13,
                    color: selectedDay.isWeekend ? Colors.teal.shade700 : AppTheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${selectedDay.dayName}: ${selectedDay.calories.toInt()} kcal",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selectedDay.isWeekend ? Colors.teal.shade700 : AppTheme.primary,
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
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
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
                  getTooltipColor: (group) => Colors.grey.shade900,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = _weeklyActivity[group.x.toInt()];
                    return BarTooltipItem(
                      "${item.dayName} ${group.x.toInt() == _todayIndex ? '(Today)' : ''}\n",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "${item.calories.toInt()} kcal\n",
                          style: const TextStyle(
                            color: AppTheme.accentGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: item.focus,
                          style: TextStyle(
                            color: Colors.grey.shade400,
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
                                        ? AppTheme.accentGreen
                                        : (item.isWeekend
                                            ? Colors.teal.shade600
                                            : (isSelected ? AppTheme.primary : Colors.grey.shade500)),
                                    fontSize: 12,
                                    fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                if (isToday)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.accentGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                else if (item.isWeekend)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade300,
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
    // Today: Radiant accent gradient
    // Weekend: Distinct teal/amber tone
    // Regular Weekdays: Sophisticated purple shade
    Color rodColor;
    if (isToday) {
      rodColor = AppTheme.primary;
    } else if (isWeekend) {
      rodColor = Colors.teal.shade400;
    } else if (isSelected) {
      rodColor = AppTheme.primary.withOpacity(0.75);
    } else {
      rodColor = AppTheme.primary.withOpacity(0.35);
    }

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: data.calories,
          color: rodColor,
          gradient: isToday
              ? const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accentGreen],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              : null,
          width: isToday ? 15 : (isWeekend ? 13 : 12),
          borderRadius: BorderRadius.circular(6),
          borderSide: isToday
              ? const BorderSide(color: AppTheme.accentGreen, width: 1.5)
              : (isSelected ? BorderSide(color: AppTheme.primary, width: 1.2) : BorderSide.none),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 3200,
            color: isToday
                ? AppTheme.accentGreen.withOpacity(0.08)
                : (isWeekend ? Colors.teal.withOpacity(0.05) : theme.colorScheme.primary.withOpacity(0.05)),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // FIX 5: Varied Today's Picks with Microcopy
  // ==========================================
  Widget _buildTodayWorkout(BuildContext context, ThemeData theme, bool isPremium) {
    // Varied picks distinct from generic workout library
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
        // Section Header with See All Navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Plan",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // Personalized for you microcopy line
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 14,
              color: isPremium ? const Color(0xFFFFA000) : AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              isPremium
                  ? "Personalized for you • Matched to your 94% recovery score"
                  : "Personalized for you • Based on your daily goals & routine",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPremium ? const Color(0xFFE65100) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Workout Pick Cards
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Background image with fallback
              Positioned.fill(
                child: Image.network(
                  workout["image"]!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF311B92), Color(0xFF5E35B1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay & Content
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        workout["tag"]!,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Title
                    Text(
                      workout["title"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Duration, Difficulty, and Calorie Badges
                    Row(
                      children: [
                        _buildMiniTag(Icons.timer_outlined, workout["duration"]!),
                        const SizedBox(width: 8),
                        _buildMiniTag(Icons.fitness_center_outlined, workout["difficulty"]!),
                        const SizedBox(width: 8),
                        _buildMiniTag(Icons.local_fire_department_outlined, workout["calories"]!),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 16,
                            color: Colors.black,
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

  Widget _buildMiniTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
