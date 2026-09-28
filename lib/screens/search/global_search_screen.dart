import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/coach.dart';
import '../../theme/app_theme.dart';
import '../../widgets/coach_card.dart';
import '../../widgets/workout_card.dart';
import '../coaches/coach_detail_screen.dart';
import '../coaches/find_coach_screen.dart';
import '../meal_plan/meal_plan_hub_screen.dart';
import '../meal_plan/meal_recipe_models.dart';
import '../workout_detail_screen.dart';
import '../workout_library_screen.dart';

/// Workout item model for search catalog
class _SearchWorkoutItem {
  final String title;
  final String duration;
  final String difficulty;
  final String category;
  final String imageUrl;

  const _SearchWorkoutItem({
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.imageUrl,
  });
}

/// Global Search Screen for FitPulse
/// Multi-category search across Workouts, Coaches, and Meals.
class GlobalSearchScreen extends StatefulWidget {
  final String? initialQuery;

  const GlobalSearchScreen({super.key, this.initialQuery});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _currentQuery = "";
  int _selectedTabIndex = 0; // 0: All, 1: Workouts, 2: Coaches, 3: Meals
  final List<String> _tabs = ["All", "Workouts", "Coaches", "Meals"];

  List<String> _recentSearches = [
    "Upper Body",
    "Coach Elena",
    "High-Protein",
    "HIIT Burn",
    "Mobility Flow",
  ];

  // ---------------------------------------------------------------------------
  // REALISTIC DUMMY SEARCH CATALOG
  // ---------------------------------------------------------------------------

  static const List<_SearchWorkoutItem> _kWorkoutsCatalog = [
    _SearchWorkoutItem(
      title: "Full Body Burn",
      duration: "30 min",
      difficulty: "Intermediate",
      category: "HIIT",
      imageUrl: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Core Crusher & Abs",
      duration: "15 min",
      difficulty: "Beginner",
      category: "Strength",
      imageUrl: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Morning Yoga Flow",
      duration: "20 min",
      difficulty: "Beginner",
      category: "Yoga",
      imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Sprint Interval Protocol",
      duration: "25 min",
      difficulty: "Advanced",
      category: "Cardio",
      imageUrl: "https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Upper Body Hypertrophy",
      duration: "45 min",
      difficulty: "Advanced",
      category: "Strength",
      imageUrl: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "HIIT Tabata Cardio Blast",
      duration: "35 min",
      difficulty: "Intermediate",
      category: "HIIT",
      imageUrl: "https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Glute & Leg Sculpt",
      duration: "40 min",
      difficulty: "Intermediate",
      category: "Strength",
      imageUrl: "https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=800&q=80",
    ),
    _SearchWorkoutItem(
      title: "Athletic Mobility & Recovery",
      duration: "25 min",
      difficulty: "Beginner",
      category: "Yoga",
      imageUrl: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=80",
    ),
  ];

  static final List<Coach> _kCoachesCatalog = [
    Coach(
      name: "Alex Strong",
      specialty: "Strength & Conditioning",
      imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80",
      rating: 4.9,
      reviewCount: 58,
      experienceYears: 6,
      bio: "Certified strength and conditioning specialist helping athletes build muscle, correct posture, and smash personal records.",
      reviews: [
        Review(reviewer: "Sarah M.", rating: 5.0, comment: "Helped me double my deadlift! Attentive form coaching."),
        Review(reviewer: "David K.", rating: 4.8, comment: "Progressive overload plans that actually work."),
      ],
    ),
    Coach(
      name: "Bella Flow",
      specialty: "Yoga & Mobility",
      imageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&q=80",
      rating: 4.9,
      reviewCount: 42,
      experienceYears: 7,
      bio: "Vinyasa yoga instructor focusing on mindful movement, thoracic mobility, flexibility, and core stability.",
      reviews: [
        Review(reviewer: "Emily R.", rating: 5.0, comment: "Transformed my daily mobility and hip tightness."),
      ],
    ),
    Coach(
      name: "Carlos Cardio",
      specialty: "Cardio & Endurance",
      imageUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80",
      rating: 4.8,
      reviewCount: 47,
      experienceYears: 5,
      bio: "Marathon finisher and aerobic threshold specialist. Heart rate zone training programs that build elite stamina.",
      reviews: [
        Review(reviewer: "Liam N.", rating: 4.8, comment: "Cut 18 mins off my half-marathon time!"),
      ],
    ),
    Coach(
      name: "Elena Vance",
      specialty: "Nutrition & Hypertrophy",
      imageUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80",
      rating: 5.0,
      reviewCount: 64,
      experienceYears: 8,
      bio: "Master nutritionist and bodybuilding specialist. Macro prescription, safe caloric cycling, and peak performance splits.",
      reviews: [
        Review(reviewer: "Marcus T.", rating: 5.0, comment: "Outstanding coach! Fixed my shoulder pinch and dialed my diet."),
      ],
    ),
    Coach(
      name: "Marcus Vance",
      specialty: "HIIT & Power",
      imageUrl: "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=300&q=80",
      rating: 4.9,
      reviewCount: 53,
      experienceYears: 6,
      bio: "High-intensity athletic training, explosive plyometrics, and kettlebell conditioning for rapid fat loss.",
      reviews: [
        Review(reviewer: "Chris P.", rating: 5.0, comment: "High energy, demanding, and incredibly rewarding."),
      ],
    ),
  ];

  static const List<RecipeItem> _kMealsCatalog = kSampleRecipes;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
    }

    // Auto-focus search input on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _currentQuery = query;
    });
  }

  void _onSearchSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      _saveRecentSearch(trimmed);
    }
  }

  void _saveRecentSearch(String term) {
    setState(() {
      _recentSearches.removeWhere((item) => item.toLowerCase() == term.toLowerCase());
      _recentSearches.insert(0, term);
      if (_recentSearches.length > 8) {
        _recentSearches = _recentSearches.sublist(0, 8);
      }
    });
  }

  void _clearQuery() {
    _searchController.clear();
    setState(() {
      _currentQuery = "";
    });
    _searchFocusNode.requestFocus();
  }

  void _applySearchTerm(String term) {
    HapticFeedback.selectionClick();
    _searchController.text = term;
    setState(() {
      _currentQuery = term;
    });
    _saveRecentSearch(term);
  }

  // ---------------------------------------------------------------------------
  // FILTERING LOGIC
  // ---------------------------------------------------------------------------

  List<_SearchWorkoutItem> get _filteredWorkouts {
    final q = _currentQuery.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _kWorkoutsCatalog.where((w) {
      return w.title.toLowerCase().contains(q) ||
          w.category.toLowerCase().contains(q) ||
          w.difficulty.toLowerCase().contains(q) ||
          w.duration.toLowerCase().contains(q);
    }).toList();
  }

  List<Coach> get _filteredCoaches {
    final q = _currentQuery.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _kCoachesCatalog.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.specialty.toLowerCase().contains(q) ||
          c.bio.toLowerCase().contains(q);
    }).toList();
  }

  List<RecipeItem> get _filteredMeals {
    final q = _currentQuery.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _kMealsCatalog.where((m) {
      return m.name.toLowerCase().contains(q) ||
          m.category.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q);
    }).toList();
  }

  int get _totalResultsCount {
    return _filteredWorkouts.length + _filteredCoaches.length + _filteredMeals.length;
  }

  int _getTabCount(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _totalResultsCount;
      case 1:
        return _filteredWorkouts.length;
      case 2:
        return _filteredCoaches.length;
      case 3:
        return _filteredMeals.length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isQueryEmpty = _currentQuery.trim().isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search Bar
            _buildSearchBar(),

            // Category Filter Tabs (visible when searching)
            if (!isQueryEmpty) _buildCategoryTabs(),

            // Main Content Area
            Expanded(
              child: isQueryEmpty
                  ? _buildBeforeTypingView()
                  : _buildSearchResultsView(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          // Back button
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              color: AppTheme.textDark,
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: "Back",
            ),
          ),

          const SizedBox(width: 10),

          // Search text field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? AppTheme.primary
                      : AppTheme.surfaceBorder,
                  width: _searchFocusNode.hasFocus ? 1.5 : 1.0,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                onChanged: _onQueryChanged,
                onSubmitted: _onSearchSubmitted,
                textInputAction: TextInputAction.search,
                style: GoogleFonts.manrope(
                  color: AppTheme.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "Search workouts, coaches, meals...",
                  hintStyle: GoogleFonts.manrope(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                  suffixIcon: _currentQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textSecondary),
                          onPressed: _clearQuery,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY TABS
  // ---------------------------------------------------------------------------
  Widget _buildCategoryTabs() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tabName = _tabs[index];
          final isSelected = _selectedTabIndex == index;
          final count = _getTabCount(index);

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    tabName,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0D0F0D).withValues(alpha: 0.2)
                          : AppTheme.surfaceLighter,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$count",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BEFORE TYPING VIEW (Recent Searches & Trending Suggestions)
  // ---------------------------------------------------------------------------
  Widget _buildBeforeTypingView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. RECENT SEARCHES
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    "RECENT SEARCHES",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Clear All",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((term) {
              return ActionChip(
                backgroundColor: AppTheme.surfaceDark,
                side: const BorderSide(color: AppTheme.surfaceBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                avatar: const Icon(Icons.north_west_rounded, size: 13, color: AppTheme.textSecondary),
                label: Text(
                  term,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                onPressed: () => _applySearchTerm(term),
              );
            }).toList(),
          ),
          const SizedBox(height: 26),
        ],

        // 2. TRENDING SUGGESTIONS
        Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, size: 16, color: AppTheme.accentOrange),
            const SizedBox(width: 6),
            Text(
              "TRENDING ON FITPULSE",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildTrendingTile(
          icon: Icons.fitness_center_rounded,
          accentColor: AppTheme.primary,
          title: "Full Body Burn HIIT",
          subtitle: "14.2k athletes completed this week",
          badge: "POPULAR",
          onTap: () => _applySearchTerm("Full Body Burn"),
        ),
        _buildTrendingTile(
          icon: Icons.sports_rounded,
          accentColor: AppTheme.accentPurple,
          title: "Coach Elena Vance",
          subtitle: "Top-rated Nutrition & Strength Coach",
          badge: "FEATURED",
          onTap: () => _applySearchTerm("Elena Vance"),
        ),
        _buildTrendingTile(
          icon: Icons.restaurant_menu_rounded,
          accentColor: const Color(0xFF00E676),
          title: "Power Oats with Whey & Blueberries",
          subtitle: "34g Protein · Clean Pre-Workout",
          badge: "RECIPE",
          onTap: () => _applySearchTerm("Power Oats"),
        ),
        _buildTrendingTile(
          icon: Icons.self_improvement_rounded,
          accentColor: const Color(0xFF00E5FF),
          title: "Morning Yoga Flow",
          subtitle: "20 min gentle thoracic & hip release",
          badge: "MOBILITY",
          onTap: () => _applySearchTerm("Yoga Flow"),
        ),
      ],
    ).animate().fadeIn(duration: 250.ms);
  }

  Widget _buildTrendingTile({
    required IconData icon,
    required Color accentColor,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH RESULTS VIEW
  // ---------------------------------------------------------------------------
  Widget _buildSearchResultsView() {
    final workouts = _filteredWorkouts;
    final coaches = _filteredCoaches;
    final meals = _filteredMeals;

    final currentTabCount = _getTabCount(_selectedTabIndex);

    // Empty state for current filter
    if (currentTabCount == 0) {
      return _buildEmptyResultsState();
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      children: [
        // Tab 0: ALL (Grouped results)
        if (_selectedTabIndex == 0) ...[
          // Workouts Section
          if (workouts.isNotEmpty) ...[
            _buildResultSectionHeader(
              title: "WORKOUTS",
              count: workouts.length,
              icon: Icons.fitness_center_rounded,
              accentColor: AppTheme.primary,
            ),
            ...workouts.map((w) => _buildWorkoutCardWrapper(w)),
            const SizedBox(height: 14),
          ],

          // Coaches Section
          if (coaches.isNotEmpty) ...[
            _buildResultSectionHeader(
              title: "COACHES",
              count: coaches.length,
              icon: Icons.sports_rounded,
              accentColor: AppTheme.accentPurple,
            ),
            ...coaches.map((c) => _buildCoachCardWrapper(c)),
            const SizedBox(height: 14),
          ],

          // Meals Section
          if (meals.isNotEmpty) ...[
            _buildResultSectionHeader(
              title: "MEALS & RECIPES",
              count: meals.length,
              icon: Icons.restaurant_menu_rounded,
              accentColor: const Color(0xFF00E676),
            ),
            ...meals.map((m) => _buildMealCardWrapper(m)),
          ],
        ],

        // Tab 1: WORKOUTS
        if (_selectedTabIndex == 1) ...workouts.map((w) => _buildWorkoutCardWrapper(w)),

        // Tab 2: COACHES
        if (_selectedTabIndex == 2) ...coaches.map((c) => _buildCoachCardWrapper(c)),

        // Tab 3: MEALS
        if (_selectedTabIndex == 3) ...meals.map((m) => _buildMealCardWrapper(m)),
      ],
    ).animate().fadeIn(duration: 250.ms);
  }

  Widget _buildResultSectionHeader({
    required String title,
    required int count,
    required IconData icon,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: accentColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder, width: 0.8),
            ),
            child: Text(
              "$count",
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXISTING CARD ADAPTERS (REUSED AS-IS)
  // ---------------------------------------------------------------------------

  // 1. Reuses WorkoutCard widget
  Widget _buildWorkoutCardWrapper(_SearchWorkoutItem workout) {
    return WorkoutCard(
      title: workout.title,
      duration: workout.duration,
      difficulty: workout.difficulty,
      imageUrl: workout.imageUrl,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WorkoutDetailScreen(
              title: workout.title,
              imageUrl: workout.imageUrl,
            ),
          ),
        );
      },
    );
  }

  // 2. Reuses CoachCard widget
  Widget _buildCoachCardWrapper(Coach coach) {
    return Padding(
      // Normalize margin so CoachCard aligns flush with WorkoutCard & RecipeCardWidget
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CoachCard(
        coach: coach,
        onViewProfile: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CoachDetailScreen(coach: coach),
            ),
          );
        },
      ),
    );
  }

  // 3. Reuses RecipeCardWidget
  Widget _buildMealCardWrapper(RecipeItem recipe) {
    return RecipeCardWidget(
      recipe: recipe,
      assignedSlot: null,
      onAddPressed: () => _showRecipePreviewSheet(recipe),
    );
  }

  void _showRecipePreviewSheet(RecipeItem recipe) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppTheme.surfaceBorder, width: 1.2)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 18),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      recipe.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${recipe.calories} kcal • ${recipe.category}",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                recipe.description,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Macros row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _macroPill("Protein", "${recipe.protein}g", AppTheme.primary),
                  _macroPill("Carbs", "${recipe.carbs}g", Colors.orangeAccent),
                  _macroPill("Fats", "${recipe.fats}g", Colors.lightBlueAccent),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MealPlanHubScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: const Color(0xFF0D0F0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    "View in Meal Plan Hub",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D0F0D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLighter,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY / NO-RESULTS STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceDark,
                border: Border.all(color: AppTheme.surfaceBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 38,
                color: AppTheme.textSecondary,
              ),
            ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Text(
              "No results found",
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
                children: [
                  const TextSpan(text: "We couldn't find any matches for "),
                  TextSpan(
                    text: "\"$_currentQuery\"",
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ". Check your spelling or browse our popular categories below:"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Browse Category Shortcut Chips
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildBrowseCategoryPill(
                  label: "Browse Workouts",
                  icon: Icons.fitness_center_rounded,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WorkoutLibraryScreen()),
                    );
                  },
                ),
                _buildBrowseCategoryPill(
                  label: "Find Coaches",
                  icon: Icons.sports_rounded,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FindCoachScreen()),
                    );
                  },
                ),
                _buildBrowseCategoryPill(
                  label: "Meal Plan Hub",
                  icon: Icons.restaurant_menu_rounded,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MealPlanHubScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseCategoryPill({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
