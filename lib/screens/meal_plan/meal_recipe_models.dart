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

/// 8 realistic recipes with rich athletic nutrition profiles and photography
const List<RecipeItem> kSampleRecipes = [
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

/// Reusable Recipe Card Widget shared between Self-Build and Coach Builder screens
class RecipeCardWidget extends StatelessWidget {
  final RecipeItem recipe;
  final MealSlot? assignedSlot;
  final bool isRecentlyAdded;
  final VoidCallback onAddPressed;

  const RecipeCardWidget({
    super.key,
    required this.recipe,
    this.assignedSlot,
    this.isRecentlyAdded = false,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isAdded = assignedSlot != null;

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
          // Top Row: Thumbnail + Title + Tag
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                "IN ${assignedSlot!.title.toUpperCase()}",
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

                ElevatedButton.icon(
                  onPressed: onAddPressed,
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

  static Widget _buildMacroPill({
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
}

/// Reusable Slot Selection Bottom Sheet
void showSlotPickerModal({
  required BuildContext context,
  required RecipeItem recipe,
  required Map<MealSlot, RecipeItem> currentPlan,
  required void Function(MealSlot) onSlotSelected,
}) {
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
              final isCurrentSlotFilled = currentPlan.containsKey(slot);
              final assignedItem = currentPlan[slot];
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
                    onSlotSelected(slot);
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
