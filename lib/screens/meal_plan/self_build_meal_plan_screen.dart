import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'meal_recipe_models.dart';

class BuildMealPlanScreen extends StatefulWidget {
  final VoidCallback? onPlanCreated;

  const BuildMealPlanScreen({super.key, this.onPlanCreated});

  @override
  State<BuildMealPlanScreen> createState() => _BuildMealPlanScreenState();
}

/// Backwards compatibility alias
typedef SelfBuildMealPlanScreen = BuildMealPlanScreen;

class _BuildMealPlanScreenState extends State<BuildMealPlanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";

  // Category filter chips
  final List<String> _categories = [
    "All",
    "High-Protein",
    "Vegetarian",
    "Seafood",
    "Keto",
    "Clean Carbs",
    "Low-Calorie",
  ];

  // Realistic recipes shared across FitPulse meal builder screens
  final List<RecipeItem> _allRecipes = kSampleRecipes;

  // User's added plan mapped by slot
  final Map<MealSlot, RecipeItem> _userPlan = {};

  // Track recent added item for confirmation micro-animation
  String? _recentlyAddedRecipeId;

  // Bottom sheet expansion state
  bool _isPlanDrawerExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered recipes getter
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

  // Running totals calculations
  int get _totalCalories =>
      _userPlan.values.fold(0, (sum, item) => sum + item.calories);
  int get _totalProtein =>
      _userPlan.values.fold(0, (sum, item) => sum + item.protein);
  int get _totalCarbs =>
      _userPlan.values.fold(0, (sum, item) => sum + item.carbs);
  int get _totalFats =>
      _userPlan.values.fold(0, (sum, item) => sum + item.fats);

  // Check if all 4 meal slots are populated
  bool get _hasAllSlotsFilled {
    return _userPlan.containsKey(MealSlot.breakfast) &&
        _userPlan.containsKey(MealSlot.lunch) &&
        _userPlan.containsKey(MealSlot.dinner) &&
        _userPlan.containsKey(MealSlot.snack);
  }

  // Assign meal to a specific slot
  void _assignMealToSlot(RecipeItem recipe, MealSlot slot) {
    setState(() {
      _userPlan[slot] = recipe;
      _recentlyAddedRecipeId = recipe.id;
    });

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

    // Reset animation state after micro duration
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _recentlyAddedRecipeId = null;
        });
      }
    });
  }

  // Remove meal from slot
  void _removeMealFromSlot(MealSlot slot) {
    setState(() {
      _userPlan.remove(slot);
    });
  }

  // Open slot selection modal using shared slot picker
  void _openSlotSelectorModal(RecipeItem recipe) {
    showSlotPickerModal(
      context: context,
      recipe: recipe,
      currentPlan: _userPlan,
      onSlotSelected: (slot) => _assignMealToSlot(recipe, slot),
    );
  }

  // Handle Save Plan
  void _handleSavePlan() {
    if (!_hasAllSlotsFilled) {
      final missingSlots = MealSlot.values
          .where((s) => !_userPlan.containsKey(s))
          .map((s) => s.title)
          .join(", ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please add meals for: $missingSlots before saving!"),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.stars_rounded, color: AppTheme.primary, size: 20),
            SizedBox(width: 8),
            Text("Meal Plan saved successfully!"),
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

    widget.onPlanCreated?.call();
    Navigator.pop(context, true);
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Build Your Meal Plan",
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        actions: [
          // Quick view of currently added count
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isPlanDrawerExpanded = !_isPlanDrawerExpanded;
                });
              },
              icon: const Icon(Icons.restaurant_menu_rounded, color: AppTheme.primary, size: 16),
              label: Text(
                "${_userPlan.length}/4 Filled",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Scrollable Recipe Search & Results Feed ──
          CustomScrollView(
            slivers: [
              // 1. Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                  child: _buildSearchBar(),
                ),
              ),

              // 2. Category Filter Chips (Horizontal Scroll)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildCategoryChips(),
                ),
              ),

              // 3. Results count summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recipes (${recipes.length})",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        "Tap card or + to add to slot",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Recipe Cards List
              if (recipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 54, color: AppTheme.textSecondary),
                        const SizedBox(height: 12),
                        Text(
                          "No recipes found",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Try searching for chicken, salmon, oats, or clear filters",
                          style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 160),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = recipes[index];
                        return _buildRecipeCard(recipe)
                            .animate()
                            .fadeIn(delay: (index * 50).ms, duration: 350.ms)
                            .slideY(begin: 0.05, end: 0);
                      },
                      childCount: recipes.length,
                    ),
                  ),
                ),
            ],
          ),

          // ── Persistent "My Plan" Bottom Sheet / Summary Drawer ──
          _buildPersistentPlanDrawer(),
        ],
      ),
    );
  }

  // ==========================================
  // 1. Search Bar
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim();
          });
        },
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
        decoration: InputDecoration(
          hintText: "Search for Meal (e.g. Oats, Salmon, Quinoa)",
          hintStyle: GoogleFonts.manrope(
            fontSize: 13,
            color: AppTheme.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 18),
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

  // ==========================================
  // 2. Category Filter Chips (Horizontal Scroll)
  // ==========================================
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

  // ==========================================
  // 3. Recipe Card (Using shared RecipeCardWidget)
  // ==========================================
  Widget _buildRecipeCard(RecipeItem recipe) {
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
      onAddPressed: () => _openSlotSelectorModal(recipe),
    );
  }

  // ==========================================
  // 4. Persistent "My Plan" Bottom Sheet / Tab
  // ==========================================
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
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 28,
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

            // Running Daily Totals Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
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
                            color: AppTheme.primary.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bookmark_added_rounded, color: AppTheme.primary, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "My Plan",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
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
                              _isPlanDrawerExpanded ? "Tap to collapse" : "Tap to view meal slots",
                              style: GoogleFonts.manrope(fontSize: 10, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Running Macro Summary
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$_totalCalories kcal",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            "P: ${_totalProtein}g • C: ${_totalCarbs}g • F: ${_totalFats}g",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          _isPlanDrawerExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlanDrawerExpanded = !_isPlanDrawerExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expanded Slot Breakdown Content
            if (_isPlanDrawerExpanded)
              Container(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shrinkWrap: true,
                  itemCount: MealSlot.values.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final slot = MealSlot.values[idx];
                    final item = _userPlan[slot];

                    if (item != null) {
                      // Populated Slot Card
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.imageUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
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
                                    "${item.calories} kcal • ${item.protein}g P • ${item.carbs}g C • ${item.fats}g F",
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
                      // Empty Slot Placeholder
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161916),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(slot.icon, size: 18, color: AppTheme.textSecondary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${slot.title}: Empty (Tap + on any recipe above)",
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

            // Bottom "Save Plan" CTA Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasAllSlotsFilled ? _handleSavePlan : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: const Color(0xFF242824),
                    foregroundColor: const Color(0xFF0D0F0D),
                    disabledForegroundColor: AppTheme.textSecondary.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: _hasAllSlotsFilled ? 4 : 0,
                    shadowColor: AppTheme.primary.withValues(alpha: 0.35),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _hasAllSlotsFilled ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                        size: 18,
                        color: _hasAllSlotsFilled ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _hasAllSlotsFilled
                            ? "Save Plan (${_userPlan.length}/4 Filled)"
                            : "Fill All 4 Slots to Save (${_userPlan.length}/4)",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: _hasAllSlotsFilled
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
