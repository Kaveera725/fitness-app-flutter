import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

enum MealSlot {
  breakfast,
  lunch,
  dinner,
  snack,
}

extension MealSlotExtension on MealSlot {
  String get title {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.dinner:
        return 'Dinner';
      case MealSlot.snack:
        return 'Snacks';
    }
  }

  IconData get icon {
    switch (this) {
      case MealSlot.breakfast:
        return Icons.wb_sunny_outlined;
      case MealSlot.lunch:
        return Icons.wb_twilight_rounded;
      case MealSlot.dinner:
        return Icons.nightlight_round;
      case MealSlot.snack:
        return Icons.energy_savings_leaf_outlined;
    }
  }
}

class RecipeItem {
  final String id;
  final String name;
  final String category; // High-Protein, Vegetarian, Seafood, Keto, etc.
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String imageUrl;
  final List<MealSlot> suggestedSlots;

  const RecipeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.imageUrl,
    required this.suggestedSlots,
  });
}

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

  // 8 realistic recipes with varied nutrition profiles and photography
  final List<RecipeItem> _allRecipes = const [
    RecipeItem(
      id: "rec_1",
      name: "Power Oats with Whey & Blueberries",
      category: "High-Protein",
      description: "Rolled oats simmered in almond milk, blended with vanilla whey isolate and organic wild berries.",
      calories: 420,
      protein: 34,
      carbs: 52,
      fats: 8,
      imageUrl: "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&q=80",
      suggestedSlots: [MealSlot.breakfast, MealSlot.snack],
    ),
    RecipeItem(
      id: "rec_2",
      name: "Grilled Herb Chicken & Quinoa Bowl",
      category: "High-Protein",
      description: "Marinated free-range chicken breast atop fluffy tri-color quinoa, roasted broccoli, and citrus glaze.",
      calories: 580,
      protein: 52,
      carbs: 48,
      fats: 14,
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
      suggestedSlots: [MealSlot.lunch, MealSlot.dinner],
    ),
    RecipeItem(
      id: "rec_3",
      name: "Pan-Seared Salmon with Asparagus",
      category: "Seafood",
      description: "Wild Alaskan salmon fillet seared in virgin olive oil with tender grilled asparagus and lemon dill sauce.",
      calories: 620,
      protein: 46,
      carbs: 12,
      fats: 32,
      imageUrl: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80",
      suggestedSlots: [MealSlot.dinner],
    ),
    RecipeItem(
      id: "rec_4",
      name: "Greek Yogurt Honey & Roasted Almonds",
      category: "Vegetarian",
      description: "Thick strained whole milk Greek yogurt drizzled with raw mountain honey and crunchy toasted almonds.",
      calories: 240,
      protein: 22,
      carbs: 18,
      fats: 7,
      imageUrl: "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&q=80",
      suggestedSlots: [MealSlot.breakfast, MealSlot.snack],
    ),
    RecipeItem(
      id: "rec_5",
      name: "Avocado Sourdough Toast & Poached Eggs",
      category: "Clean Carbs",
      description: "Artisan toasted sourdough smeared with Haas avocado mash, chili flakes, and two farm-fresh poached eggs.",
      calories: 390,
      protein: 19,
      carbs: 34,
      fats: 21,
      imageUrl: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80",
      suggestedSlots: [MealSlot.breakfast, MealSlot.lunch],
    ),
    RecipeItem(
      id: "rec_6",
      name: "Garlic Butter Tiger Prawns & Wild Rice",
      category: "Seafood",
      description: "Jumbo tiger prawns sautéed with crushed garlic, smoked paprika, parsley, and steamed wild grain blend.",
      calories: 510,
      protein: 44,
      carbs: 42,
      fats: 11,
      imageUrl: "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500&q=80",
      suggestedSlots: [MealSlot.lunch, MealSlot.dinner],
    ),
    RecipeItem(
      id: "rec_7",
      name: "Grass-Fed Ribeye & Sweet Potato Mash",
      category: "Keto",
      description: "Prime grass-fed sirloin grilled to medium-rare served with roasted sweet potato mash and rosemary butter.",
      calories: 690,
      protein: 56,
      carbs: 28,
      fats: 36,
      imageUrl: "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80",
      suggestedSlots: [MealSlot.dinner],
    ),
    RecipeItem(
      id: "rec_8",
      name: "Dark Cacao Peanut Butter Protein Balls",
      category: "Low-Calorie",
      description: "No-bake organic energy bites crafted from medjool dates, natural peanut butter, chia seeds, and 85% cacao.",
      calories: 220,
      protein: 16,
      carbs: 20,
      fats: 9,
      imageUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80",
      suggestedSlots: [MealSlot.snack],
    ),
  ];

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

  // Open slot selection modal
  void _openSlotSelectorModal(RecipeItem recipe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Assign to Meal Slot",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Choose which slot you'd like to assign \"${recipe.name}\"",
                style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ...MealSlot.values.map((slot) {
                final isCurrentSlotFilled = _userPlan.containsKey(slot);
                final assignedItem = _userPlan[slot];
                final isSameItem = assignedItem?.id == recipe.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSameItem
                            ? AppTheme.primary
                            : AppTheme.surfaceBorder,
                        width: isSameItem ? 1.4 : 1.0,
                      ),
                    ),
                    tileColor: isSameItem
                        ? AppTheme.primary.withValues(alpha: 0.12)
                        : const Color(0xFF161916),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(slot.icon, color: AppTheme.primary, size: 20),
                    ),
                    title: Text(
                      slot.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    subtitle: isCurrentSlotFilled
                        ? Text(
                            isSameItem
                                ? "Current assignment"
                                : "Replaces: ${assignedItem!.name}",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: isSameItem ? AppTheme.primary : AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            "Slot empty",
                            style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                    trailing: isSameItem
                        ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20)
                        : const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primary, size: 20),
                    onTap: () {
                      Navigator.pop(ctx);
                      _assignMealToSlot(recipe, slot);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
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
  // 3. Recipe Card
  // ==========================================
  Widget _buildRecipeCard(RecipeItem recipe) {
    // Check if this recipe is already assigned to any slot
    MealSlot? assignedSlot;
    for (final entry in _userPlan.entries) {
      if (entry.value.id == recipe.id) {
        assignedSlot = entry.key;
        break;
      }
    }
    final isAdded = assignedSlot != null;
    final isRecentlyAdded = _recentlyAddedRecipeId == recipe.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAdded
              ? AppTheme.primary.withValues(alpha: 0.45)
              : AppTheme.surfaceBorder,
          width: isAdded ? 1.3 : 1.0,
        ),
        boxShadow: isAdded
            ? [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Thumbnail + Title + Add Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Photo Thumbnail with Rounded Corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF222622),
                        child: const Icon(Icons.restaurant_rounded, color: AppTheme.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Meal Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              recipe.category.toUpperCase(),
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          if (isAdded)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPurple.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "IN ${assignedSlot.title.toUpperCase()}",
                                style: GoogleFonts.manrope(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.accentPurple,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipe.description,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider Line
          Container(
            height: 1,
            color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
          ),

          // Bottom Macro Breakdown Row + "Add to Plan" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Macro Breakdown (Calories, Protein, Carbs, Fat with icons)
                Row(
                  children: [
                    _buildMacroPill(
                      icon: Icons.local_fire_department_rounded,
                      value: "${recipe.calories} kcal",
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 8),
                    _buildMacroPill(
                      icon: Icons.fitness_center_rounded,
                      value: "${recipe.protein}g P",
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _buildMacroPill(
                      icon: Icons.grain_rounded,
                      value: "${recipe.carbs}g C",
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(width: 8),
                    _buildMacroPill(
                      icon: Icons.water_drop_rounded,
                      value: "${recipe.fats}g F",
                      color: Colors.cyanAccent,
                    ),
                  ],
                ),

                // "Add to Plan" button with micro-animation
                ElevatedButton.icon(
                  onPressed: () => _openSlotSelectorModal(recipe),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdded
                        ? AppTheme.primary.withValues(alpha: 0.16)
                        : AppTheme.primary,
                    foregroundColor: isAdded ? AppTheme.primary : const Color(0xFF0D0F0D),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(60, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: isAdded
                          ? const BorderSide(color: AppTheme.primary, width: 1.2)
                          : BorderSide.none,
                    ),
                  ),
                  icon: Icon(
                    isAdded ? Icons.check_circle_rounded : Icons.add_rounded,
                    size: 15,
                    color: isAdded ? AppTheme.primary : const Color(0xFF0D0F0D),
                  ),
                  label: Text(
                    isAdded ? "Added" : "Add",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      color: isAdded ? AppTheme.primary : const Color(0xFF0D0F0D),
                    ),
                  ),
                )
                    .animate(target: isRecentlyAdded ? 1.0 : 0.0)
                    .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 200.ms)
                    .then()
                    .scale(begin: const Offset(1.12, 1.12), end: const Offset(1, 1), duration: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPill({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
      ],
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
