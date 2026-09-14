import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../coaches/find_coach_screen.dart';
import 'self_build_meal_plan_screen.dart';
import 'request_meal_plan_screen.dart';

enum UserTier {
  free,
  premium,
}

class MealItem {
  final String mealType;
  final IconData icon;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String imageUrl;
  final String time;

  const MealItem({
    required this.mealType,
    required this.icon,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.imageUrl,
    required this.time,
  });
}

class MealPlanHubScreen extends StatefulWidget {
  /// Mock state variables as specified in technical requirements:
  /// [userType] can be 'free' or 'premium'
  final String userType;
  final bool hasCoach;
  final bool hasPlan;
  final bool hasPendingRequest;

  // Backwards compatibility constructor parameter
  final UserTier? initialTier;

  const MealPlanHubScreen({
    super.key,
    this.userType = 'free',
    this.hasCoach = false,
    this.hasPlan = false,
    this.hasPendingRequest = false,
    this.initialTier,
  });

  @override
  State<MealPlanHubScreen> createState() => _MealPlanHubScreenState();
}

class _MealPlanHubScreenState extends State<MealPlanHubScreen> {
  // Mock state variables for toggling between the 3 requested states
  late String userType; // 'free' or 'premium'
  late bool hasCoach; // bool
  late bool hasPlan; // bool
  late bool hasPendingRequest; // bool

  bool get isPremium => userType.toLowerCase() == 'premium';
  bool get isFree => !isPremium;

  // Assigned coach mock data
  final Map<String, dynamic> _coach = const {
    'name': 'Alex Strong',
    'specialty': 'Strength & Sports Nutrition',
    'imageUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    'rating': 4.9,
  };

  // Sample meals list for when a plan exists
  final List<MealItem> _todayMeals = const [
    MealItem(
      mealType: "Breakfast",
      icon: Icons.wb_sunny_outlined,
      name: "Power Oats with Whey & Blueberries",
      calories: 420,
      protein: 34,
      carbs: 52,
      fats: 8,
      imageUrl: "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=400&q=80",
      time: "8:00 AM",
    ),
    MealItem(
      mealType: "Lunch",
      icon: Icons.wb_twilight_rounded,
      name: "Grilled Herb Chicken & Quinoa Bowl",
      calories: 580,
      protein: 52,
      carbs: 48,
      fats: 14,
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80",
      time: "1:00 PM",
    ),
    MealItem(
      mealType: "Pre-Workout Snack",
      icon: Icons.energy_savings_leaf_outlined,
      name: "Greek Yogurt with Honey & Almonds",
      calories: 240,
      protein: 22,
      carbs: 18,
      fats: 7,
      imageUrl: "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&q=80",
      time: "4:30 PM",
    ),
    MealItem(
      mealType: "Dinner",
      icon: Icons.nightlight_round,
      name: "Pan-Seared Salmon with Asparagus",
      calories: 620,
      protein: 46,
      carbs: 22,
      fats: 32,
      imageUrl: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&q=80",
      time: "8:00 PM",
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTier != null) {
      userType = widget.initialTier == UserTier.premium ? 'premium' : 'free';
    } else {
      userType = widget.userType;
    }
    hasCoach = widget.hasCoach;
    hasPlan = widget.hasPlan;
    hasPendingRequest = widget.hasPendingRequest;
  }

  void _navigateToSelfBuild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelfBuildMealPlanScreen(
          onPlanCreated: () {
            setState(() {
              hasPlan = true;
              hasPendingRequest = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Custom Meal Plan generated successfully!"),
                backgroundColor: AppTheme.surfaceDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.primary),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleRequestFromCoach() {
    if (isPremium && !hasCoach) {
      // STATE 3: Premium user WITHOUT an assigned coach yet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FindCoachScreen(
            bannerMessage: "Select a coach first to request a meal plan",
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Select a coach first to request a meal plan",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.surfaceDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.primary),
          ),
        ),
      );
    } else if (isPremium && hasCoach) {
      // STATE 2: Open Request Meal Plan Form Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RequestMealPlanScreen(
            coachName: _coach['name'],
            coachSpecialty: _coach['specialty'],
            coachAvatarUrl: _coach['imageUrl'],
            onRequestSubmitted: () {
              setState(() {
                hasPendingRequest = true;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: Text(
          "Your Meal Plan",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        actions: [
          // State Simulation Switcher Button (Allows easy previewing of States 1, 2, and 3)
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppTheme.primary),
            tooltip: "Switch State Preview",
            onPressed: _showStateSimulationSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current State Indicator Pill
            _buildStateIndicatorBanner(),
            const SizedBox(height: 16),

            // ── Main Content Area (Transitions according to States 1, 2, 3) ──
            if (hasPlan)
              _buildPlanActiveView()
            else
              _buildNoPlanView(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // State Simulation Badge Indicator
  // ==========================================
  Widget _buildStateIndicatorBanner() {
    String stateDescription;
    if (isFree) {
      stateDescription = "State 1: Free / Standard User (Self-Service)";
    } else if (hasCoach) {
      stateDescription = "State 2: Premium User • Assigned: ${_coach['name']}";
    } else {
      stateDescription = "State 3: Premium User • No Coach Assigned Yet";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141714),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(
            isPremium ? Icons.workspace_premium_rounded : Icons.person_rounded,
            size: 15,
            color: isPremium ? AppTheme.accentPurple : AppTheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              stateDescription,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          InkWell(
            onTap: _showStateSimulationSheet,
            child: Text(
              "Change",
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // NO PLAN VIEW (Covers States 1, 2, and 3)
  // ==========================================
  Widget _buildNoPlanView() {
    // If pending request was already sent to coach in State 2
    if (hasPendingRequest && isPremium && hasCoach) {
      return _buildPendingRequestCard()
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.05, end: 0);
    }

    // STATE 1: Free/Standard user (no coach access)
    if (isFree) {
      return _buildFreeEmptyState()
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.05, end: 0);
    }

    // STATE 2 & STATE 3: Premium user without an active plan yet
    return _buildPremiumOptionsView()
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }

  // ------------------------------------------
  // State 1: Free User Empty State
  // ------------------------------------------
  Widget _buildFreeEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
            ),
            child: const Icon(Icons.restaurant_rounded, size: 36, color: AppTheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            "No meal plan yet — let's build one",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fuel your workouts with a personalized nutrition structure tailored to your calorie and protein goals.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToSelfBuild,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                "Create Meal Plan",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // State 2 & 3: Premium User Options (Build Own vs Request from Coach)
  // ------------------------------------------
  Widget _buildPremiumOptionsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose How to Build Your Plan",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "As a Pro member, you can architect your own macros or receive a bespoke prescription.",
          style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),

        // Option 1: "Build My Own" (Self-Service)
        GestureDetector(
          onTap: _navigateToSelfBuild,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.surfaceBorder, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppTheme.primary, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Build My Own",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Configure calories, macro ratios & personal diet rules independently.",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Option 2: "Request from Coach"
        // In State 2: Shows coach avatar + name
        // In State 3: Prompts to select coach from Directory
        GestureDetector(
          onTap: _handleRequestFromCoach,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasCoach ? AppTheme.primary.withValues(alpha: 0.4) : AppTheme.surfaceBorder,
                width: 1.2,
              ),
              boxShadow: hasCoach
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (hasCoach)
                  // Coach's small avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _coach['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF222622),
                          child: const Icon(Icons.person, color: AppTheme.primary),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentPurple.withValues(alpha: 0.35)),
                    ),
                    child: const Icon(Icons.person_search_rounded, color: AppTheme.accentPurple, size: 26),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              hasCoach ? "Request from ${_coach['name']}" : "Request from Coach",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          if (hasCoach) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, size: 14, color: AppTheme.primary),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hasCoach
                            ? "Your assigned 1-on-1 coach will design a targeted meal blueprint."
                            : "Select an elite trainer to build your personalized plan.",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // State 2: Pending Request Card
  // ------------------------------------------
  Widget _buildPendingRequestCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    _coach['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF222622),
                      child: const Icon(Icons.person, color: AppTheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.hourglass_top_rounded, size: 11, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            "REQUEST SENT",
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Waiting for ${_coach['name']} to respond",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Your coach received your metabolic stats and is curating your personalized meal schedule. Typical response time is under 24 hours.",
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _navigateToSelfBuild,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.surfaceBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Build Temporary Plan",
                    style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    hasPendingRequest = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ACTIVE PLAN VIEW (Today's Meals Vertical List)
  // ==========================================
  Widget _buildPlanActiveView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Daily Calorie & Macro Target Card
        _buildDailyMacroSummary(),
        const SizedBox(height: 20),

        // Section Title & Edit Plan Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Meals",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: _navigateToSelfBuild,
              icon: const Icon(Icons.edit_note_rounded, color: AppTheme.primary, size: 18),
              label: Text(
                "Edit Plan",
                style: GoogleFonts.manrope(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Vertical List of Meals
        Column(
          children: _todayMeals.asMap().entries.map((entry) {
            final idx = entry.key;
            final meal = entry.value;
            return _buildMealCard(meal)
                .animate()
                .fadeIn(delay: (idx * 60).ms, duration: 350.ms)
                .slideY(begin: 0.05, end: 0);
          }).toList(),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Daily Nutrition Progress Card
  // ------------------------------------------
  Widget _buildDailyMacroSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daily Calorie Goal",
                    style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "1,860",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/ 2,100 kcal",
                        style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
                ),
                child: Text(
                  "240 kcal left",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.88,
              minHeight: 6,
              backgroundColor: Color(0xFF242824),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroItem("Protein", "154g", "Target: 165g", AppTheme.primary),
              _buildVerticalDivider(),
              _buildMacroItem("Carbs", "140g", "Target: 180g", Colors.orangeAccent),
              _buildVerticalDivider(),
              _buildMacroItem("Fats", "61g", "Target: 65g", Colors.cyanAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String title, String current, String target, Color color) {
    return Column(
      children: [
        Text(
          current,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, color: color),
        ),
        Text(
          title,
          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark),
        ),
        Text(
          target,
          style: GoogleFonts.manrope(fontSize: 10, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 30,
      color: AppTheme.surfaceBorder,
    );
  }

  // ------------------------------------------
  // Meal Item Card
  // ------------------------------------------
  Widget _buildMealCard(MealItem meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Row(
        children: [
          // Small Thumbnail with Rounded Corners
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 68,
              height: 68,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF222622),
                  child: const Icon(Icons.fastfood_rounded, color: AppTheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Meal Info & Macros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(meal.icon, size: 13, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          meal.mealType.toUpperCase(),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      meal.time,
                      style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  meal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${meal.calories} kcal • ${meal.protein}g Protein • ${meal.carbs}g C • ${meal.fats}g F",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // State Simulation Modal Sheet
  // ==========================================
  void _showStateSimulationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Meal Plan State Simulation",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Switch between the 3 required states dynamically to preview every flow.",
                    style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // State 1 Shortcut
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: isFree ? AppTheme.primary.withValues(alpha: 0.12) : null,
                    leading: const Icon(Icons.person_outline, color: AppTheme.primary),
                    title: Text("State 1: Free / Standard User", style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                    subtitle: Text("Self-build only, no coach access", style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    trailing: Switch(
                      value: isFree,
                      thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
                      onChanged: (val) {
                        setState(() {
                          userType = val ? 'free' : 'premium';
                        });
                        setSheetState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 6),

                  // State 2 Shortcut
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: (isPremium && hasCoach) ? AppTheme.primary.withValues(alpha: 0.12) : null,
                    leading: const Icon(Icons.sports, color: AppTheme.primary),
                    title: Text("State 2: Premium WITH Coach", style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                    subtitle: Text("Assigned to ${_coach['name']}", style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    trailing: Switch(
                      value: isPremium && hasCoach,
                      thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
                      onChanged: (val) {
                        setState(() {
                          userType = 'premium';
                          hasCoach = val;
                        });
                        setSheetState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 6),

                  // State 3 Shortcut
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: (isPremium && !hasCoach) ? AppTheme.primary.withValues(alpha: 0.12) : null,
                    leading: const Icon(Icons.person_search_rounded, color: AppTheme.accentPurple),
                    title: Text("State 3: Premium WITHOUT Coach", style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                    subtitle: Text("Redirects to Coach Directory", style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    trailing: Switch(
                      value: isPremium && !hasCoach,
                      thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.accentPurple),
                      onChanged: (val) {
                        setState(() {
                          userType = 'premium';
                          hasCoach = !val;
                        });
                        setSheetState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Toggle Request Pending
                  SwitchListTile(
                    title: Text("Pending Request Sent", style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                    subtitle: Text(hasPendingRequest ? "Waiting for coach to respond card" : "No pending request", style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    value: hasPendingRequest,
                    thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
                    onChanged: (val) {
                      setState(() {
                        hasPendingRequest = val;
                      });
                      setSheetState(() {});
                    },
                  ),
                  const SizedBox(height: 6),

                  // Toggle Plan Exists
                  SwitchListTile(
                    title: Text("Plan Exists (Show Today's Meals)", style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                    subtitle: Text(hasPlan ? "Showing today's 4 meals" : "Showing empty / request state", style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    value: hasPlan,
                    thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
                    onChanged: (val) {
                      setState(() {
                        hasPlan = val;
                      });
                      setSheetState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
