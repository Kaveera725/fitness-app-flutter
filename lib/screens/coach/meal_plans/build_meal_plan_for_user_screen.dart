import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../meal_plan/meal_recipe_models.dart';
import 'meal_plan_request_model.dart';

class BuildMealPlanForUserScreen extends StatefulWidget {
  final MealPlanRequest request;
  final ValueChanged<MealPlanRequest>? onPlanAssigned;

  const BuildMealPlanForUserScreen({
    super.key,
    required this.request,
    this.onPlanAssigned,
  });

  @override
  State<BuildMealPlanForUserScreen> createState() =>
      _BuildMealPlanForUserScreenState();
}

class _BuildMealPlanForUserScreenState
    extends State<BuildMealPlanForUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";

  // Collapsible summary card toggle
  bool _isSummaryExpanded = false;

  // Meal plan slots mapping
  final Map<MealSlot, RecipeItem> _userPlan = {};

  // For animation feedback
  String? _recentlyAddedRecipeId;
  bool _isPlanDrawerExpanded = false;

  // Categories
  final List<String> _categories = [
    "All",
    "High-Protein",
    "Vegetarian",
    "Seafood",
    "Keto",
    "Clean Carbs",
    "Low-Calorie",
  ];

  final List<RecipeItem> _allRecipes = kSampleRecipes;

  @override
  void initState() {
    super.initState();
    // If request already had a plan, preload it
    if (widget.request.assignedPlan != null) {
      _userPlan.addAll(widget.request.assignedPlan!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered recipes
  List<RecipeItem> get _filteredRecipes {
    return _allRecipes.where((recipe) {
      final matchesCategory = _selectedCategory == "All" ||
          recipe.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Current Plan Nutritional Totals
  int get _totalCalories =>
      _userPlan.values.fold(0, (sum, item) => sum + item.calories);
  int get _totalProtein =>
      _userPlan.values.fold(0, (sum, item) => sum + item.protein);
  int get _totalCarbs =>
      _userPlan.values.fold(0, (sum, item) => sum + item.carbs);
  int get _totalFats =>
      _userPlan.values.fold(0, (sum, item) => sum + item.fats);

  bool get _hasAnyMealsAdded => _userPlan.isNotEmpty;
  bool get _hasAllSlotsFilled => _userPlan.length == MealSlot.values.length;

  void _assignMealToSlot(RecipeItem recipe, MealSlot slot) {
    setState(() {
      _userPlan[slot] = recipe;
      _recentlyAddedRecipeId = recipe.id;
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Added \"${recipe.name}\" to ${slot.title}",
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.primary),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _recentlyAddedRecipeId = null;
        });
      }
    });
  }

  void _removeMealFromSlot(MealSlot slot) {
    setState(() {
      _userPlan.remove(slot);
    });
  }

  void _openSlotSelector(RecipeItem recipe) {
    showSlotPickerModal(
      context: context,
      recipe: recipe,
      currentPlan: _userPlan,
      onSlotSelected: (slot) => _assignMealToSlot(recipe, slot),
    );
  }

  void _handleAssignPlan() {
    if (!_hasAnyMealsAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please add at least one meal to build the plan!"),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Animate & Show confirmation modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildConfirmationDialog(ctx),
    );
  }

  Widget _buildConfirmationDialog(BuildContext dialogContext) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.primary, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.25),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primary, width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 44,
                color: AppTheme.primary,
              ),
            )
                .animate()
                .scale(begin: const Offset(0.3, 0.3), end: const Offset(1, 1), duration: 400.ms, curve: Curves.easeOutBack)
                .then()
                .shimmer(duration: 700.ms, color: Colors.white60),
            const SizedBox(height: 20),
            Text(
              "Meal Plan Sent!",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Meal plan successfully assigned and sent to ${widget.request.userName}.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF131613),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dialogStatItem("Calories", "$_totalCalories", "kcal"),
                  _dialogStatItem("Protein", "${_totalProtein}g", "macro"),
                  _dialogStatItem("Meals", "${_userPlan.length}/4", "slots"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.request.status = RequestStatus.completed;
                  widget.request.assignedPlan = Map.from(_userPlan);
                  widget.onPlanAssigned?.call(widget.request);

                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pop(context, widget.request); // Return to requests list

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.send_rounded, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Meal plan sent to ${widget.request.userName}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Done",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogStatItem(String label, String val, String sub) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Build Meal Plan",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              "for ${widget.request.userName}",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPlanDrawerExpanded ? Icons.tune_rounded : Icons.pie_chart_outline_rounded,
              color: AppTheme.primary,
            ),
            tooltip: "View Plan Breakdown",
            onPressed: () {
              setState(() {
                _isPlanDrawerExpanded = !_isPlanDrawerExpanded;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Collapsible User Profile & Submitted Details Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
                  child: _buildCollapsibleUserHeader(),
                ),
              ),

              // 2. Running Macro & Calorie Goal Comparison Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                  child: _buildMacroComparisonCard(),
                ),
              ),

              // 3. Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: _buildSearchBar(),
                ),
              ),

              // 4. Category Filter Chips (Horizontal Scroll)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryChips(),
                ),
              ),

              // 5. Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Meals (${recipes.length})",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        "Tap + to assign to slot",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Recipe Cards List (reusing RecipeCardWidget)
              if (recipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 50, color: AppTheme.textSecondary),
                        const SizedBox(height: 10),
                        Text(
                          "No matching recipes",
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Try searching for other protein or carbohydrate sources",
                          style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 180),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = recipes[index];
                        MealSlot? assignedSlot;
                        for (final entry in _userPlan.entries) {
                          if (entry.value.id == recipe.id) {
                            assignedSlot = entry.key;
                            break;
                          }
                        }

                        return RecipeCardWidget(
                          recipe: recipe,
                          assignedSlot: assignedSlot,
                          isRecentlyAdded: _recentlyAddedRecipeId == recipe.id,
                          onAddPressed: () => _openSlotSelector(recipe),
                        )
                            .animate()
                            .fadeIn(delay: (index * 40).ms, duration: 300.ms)
                            .slideY(begin: 0.05, end: 0);
                      },
                      childCount: recipes.length,
                    ),
                  ),
                ),
            ],
          ),

          // 7. Persistent Organized Plan Drawer & CTA Button
          _buildPersistentPlanDrawer(),
        ],
      ),
    );
  }

  // ===========================================================================
  // 1. Collapsible User Header Card (Details, stats, preferences, notes)
  // ===========================================================================
  Widget _buildCollapsibleUserHeader() {
    final req = widget.request;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collapsed summary preview
          InkWell(
            onTap: () {
              setState(() {
                _isSummaryExpanded = !_isSummaryExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                    backgroundImage: NetworkImage(req.userAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              req.userName,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                req.fitnessGoal,
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${req.age} yrs • ${req.height} • ${req.weight} • ${req.bodyFat} BF",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222622),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isSummaryExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Full Details Card
          if (_isSummaryExpanded) ...[
            Container(
              height: 1,
              color: AppTheme.surfaceBorder,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full stats grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailBadge("AGE", "${req.age}"),
                      _buildDetailBadge("HEIGHT", req.height),
                      _buildDetailBadge("WEIGHT", req.weight),
                      _buildDetailBadge("BODY FAT", req.bodyFat),
                      _buildDetailBadge("MEALS/DAY", "${req.mealsPerDay}"),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Dietary Preferences chips
                  Text(
                    "DIETARY PREFERENCES",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...req.dietaryPreferences.map((pref) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              pref,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          )),
                      if (req.allergies.isNotEmpty && req.allergies.toLowerCase() != "none")
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Text(
                                "Allergy: ${req.allergies}",
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  // User Notes
                  if (req.userNotes.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      "USER NOTES & GOALS",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131513),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.format_quote_rounded, size: 18, color: AppTheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req.userNotes,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppTheme.textDark.withValues(alpha: 0.9),
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 200.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141714),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. Running Macro & Calorie Comparison Card
  // ===========================================================================
  Widget _buildMacroComparisonCard() {
    final targetCal = widget.request.targetCalories;
    final targetP = widget.request.targetProtein;
    final targetC = widget.request.targetCarbs;
    final targetF = widget.request.targetFats;

    final calProgress = (_totalCalories / targetCal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF171B17),
            AppTheme.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Running Day Total",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _totalCalories >= targetCal - 150 && _totalCalories <= targetCal + 150
                      ? AppTheme.primary.withValues(alpha: 0.18)
                      : const Color(0xFF242724),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${(_totalCalories - targetCal > 0 ? '+' : '')}${_totalCalories - targetCal} kcal diff",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _totalCalories >= targetCal - 150 && _totalCalories <= targetCal + 150
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Calorie target progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$_totalCalories ",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    TextSpan(
                      text: "/ $targetCal kcal target",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${(calProgress * 100).toInt()}%",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: calProgress,
              minHeight: 6,
              backgroundColor: const Color(0xFF222622),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 14),

          // Macro Breakdown bars: Protein, Carbs, Fats
          Row(
            children: [
              Expanded(
                child: _buildMacroCompareBar(
                  label: "Protein",
                  current: _totalProtein,
                  target: targetP,
                  color: AppTheme.primary,
                  unit: "g",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroCompareBar(
                  label: "Carbs",
                  current: _totalCarbs,
                  target: targetC,
                  color: Colors.amberAccent,
                  unit: "g",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroCompareBar(
                  label: "Fats",
                  current: _totalFats,
                  target: targetF,
                  color: Colors.cyanAccent,
                  unit: "g",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCompareBar({
    required String label,
    required int current,
    required int target,
    required Color color,
    required String unit,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF131513),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                "$current/$target$unit",
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: const Color(0xFF222622),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. Search Bar
  // ===========================================================================
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 14),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: "Search meal name, ingredients...",
          hintStyle: GoogleFonts.manrope(color: AppTheme.textSecondary, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  // ===========================================================================
  // 4. Category Filter Chips
  // ===========================================================================
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory.toLowerCase() == category.toLowerCase();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                  width: 1,
                ),
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
              child: Text(
                category,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // 5. Persistent "Organized by Slot" Drawer & Assign CTA
  // ===========================================================================
  Widget _buildPersistentPlanDrawer() {
    final filledSlotsCount = _userPlan.length;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141714),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: _hasAllSlotsFilled
                  ? AppTheme.primary.withValues(alpha: 0.5)
                  : AppTheme.surfaceBorder,
              width: 1.4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.75),
              blurRadius: 30,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drawer Drag/Toggle Handle
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPlanDrawerExpanded = !_isPlanDrawerExpanded;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Top Header: Slot overview toggle
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlanDrawerExpanded = !_isPlanDrawerExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.assignment_turned_in_rounded, color: AppTheme.primary, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Assigned Slots",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _hasAllSlotsFilled
                                        ? AppTheme.primary
                                        : const Color(0xFF242924),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "$filledSlotsCount/4",
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: _hasAllSlotsFilled ? const Color(0xFF0D0F0D) : AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _isPlanDrawerExpanded ? "Tap to collapse slots" : "Tap to expand slots",
                              style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Macro summary badge
                  Text(
                    "$_totalCalories kcal • ${_totalProtein}g P",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Expanded 4 Meal Slots List (Breakfast, Lunch, Dinner, Snacks)
            if (_isPlanDrawerExpanded)
              Container(
                constraints: const BoxConstraints(maxHeight: 260),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: MealSlot.values.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final slot = MealSlot.values[index];
                    final item = _userPlan[slot];

                    if (item != null) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1E1B),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.restaurant, color: AppTheme.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(slot.icon, size: 12, color: AppTheme.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        slot.title.toUpperCase(),
                                        style: GoogleFonts.manrope(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${item.calories} kcal • ${item.protein}g P • ${item.carbs}g C",
                                    style: GoogleFonts.manrope(fontSize: 10, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent, size: 18),
                              tooltip: "Remove from ${slot.title}",
                              onPressed: () => _removeMealFromSlot(slot),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161916),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(slot.icon, size: 16, color: AppTheme.textSecondary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${slot.title}: Empty (Tap + on any meal)",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),

            // Bottom "Assign Plan to [User Name]" CTA Button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasAnyMealsAdded ? _handleAssignPlan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: const Color(0xFF242824),
                    foregroundColor: const Color(0xFF0D0F0D),
                    disabledForegroundColor: AppTheme.textSecondary.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: _hasAnyMealsAdded ? 4 : 0,
                    shadowColor: AppTheme.primary.withValues(alpha: 0.35),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: _hasAnyMealsAdded ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Assign Plan to ${widget.request.userName}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: _hasAnyMealsAdded
                              ? const Color(0xFF0D0F0D)
                              : AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
