import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import 'meal_recipe_models.dart';
import 'self_build_meal_plan_screen.dart';

enum PlanSource {
  selfBuilt,
  coachAssigned,
}

class MealDetailItem {
  final String id;
  final MealSlot slot;
  final String slotTime;
  final String name;
  final String description;
  final String prepNotes;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String imageUrl;
  bool isEaten;

  MealDetailItem({
    required this.id,
    required this.slot,
    required this.slotTime,
    required this.name,
    required this.description,
    required this.prepNotes,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.imageUrl,
    this.isEaten = false,
  });
}

class DayNutritionSchedule {
  final String dayShort;
  final String dayName;
  final String focus;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFats;
  final List<MealDetailItem> meals;

  const DayNutritionSchedule({
    required this.dayShort,
    required this.dayName,
    required this.focus,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    required this.meals,
  });
}

class MyMealPlanScreen extends StatefulWidget {
  final PlanSource initialSource;
  final String coachName;
  final String coachAvatar;

  const MyMealPlanScreen({
    super.key,
    this.initialSource = PlanSource.coachAssigned,
    this.coachName = "Coach Alex Vance",
    this.coachAvatar =
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
  });

  @override
  State<MyMealPlanScreen> createState() => _MyMealPlanScreenState();
}

class _MyMealPlanScreenState extends State<MyMealPlanScreen> {
  late PlanSource _currentSource;
  late int _selectedDayIndex;
  late int _todayIndex;
  final Set<String> _expandedMealIds = {"meal_b_01"};

  // 7-day schedule data matching M-T-W-T-F-S-S
  late List<DayNutritionSchedule> _weekSchedule;

  @override
  void initState() {
    super.initState();
    _currentSource = widget.initialSource;
    // 0 = Monday ... 6 = Sunday
    _todayIndex = (DateTime.now().weekday - 1).clamp(0, 6);
    _selectedDayIndex = _todayIndex;
    _initSchedule();
  }

  void _initSchedule() {
    // 4 standard meals for each day with realistic athletic variety
    _weekSchedule = [
      DayNutritionSchedule(
        dayShort: "M",
        dayName: "Mon",
        focus: "Heavy Leg Day • High Carb",
        targetCalories: 2250,
        targetProtein: 165,
        targetCarbs: 260,
        targetFats: 60,
        meals: [
          MealDetailItem(
            id: "meal_b_01",
            slot: MealSlot.breakfast,
            slotTime: "8:00 AM",
            name: "Power Oats with Whey & Blueberries",
            description:
                "Rolled oats simmered in unsweetened almond milk, blended with vanilla whey isolate, organic wild berries, and chia seeds.",
            prepNotes:
                "Soak oats 10 mins or microwave 90s. Stir in protein powder after heating to avoid clumping.",
            calories: 440,
            protein: 36,
            carbs: 56,
            fats: 8,
            imageUrl:
                "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&q=80",
            isEaten: true,
          ),
          MealDetailItem(
            id: "meal_l_01",
            slot: MealSlot.lunch,
            slotTime: "1:00 PM",
            name: "Grilled Herb Chicken & Quinoa Bowl",
            description:
                "Marinated free-range chicken breast atop tri-color quinoa, steamed broccoli florets, and a citrus garlic drizzle.",
            prepNotes:
                "Best consumed warm. Squeeze fresh lemon slice over chicken before eating.",
            calories: 620,
            protein: 54,
            carbs: 58,
            fats: 14,
            imageUrl:
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
            isEaten: true,
          ),
          MealDetailItem(
            id: "meal_s_01",
            slot: MealSlot.snack,
            slotTime: "4:30 PM",
            name: "Greek Yogurt Honey & Roasted Almonds",
            description:
                "Strained whole milk Greek yogurt drizzled with raw mountain honey, crushed walnuts, and cinnamon powder.",
            prepNotes:
                "Pre-workout fuel 60-90 minutes prior to your heavy leg training.",
            calories: 280,
            protein: 24,
            carbs: 22,
            fats: 9,
            imageUrl:
                "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_01",
            slot: MealSlot.dinner,
            slotTime: "7:45 PM",
            name: "Pan-Seared Salmon with Asparagus",
            description:
                "Wild Alaskan salmon fillet seared in virgin olive oil with tender grilled asparagus, lemon herb butter, and roasted sweet potatoes.",
            prepNotes:
                "Rich in Omega-3 for joint recovery and reducing DOMS inflammation.",
            calories: 680,
            protein: 48,
            carbs: 38,
            fats: 28,
            imageUrl:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "T",
        dayName: "Tue",
        focus: "Upper Push • Moderate Carb",
        targetCalories: 2100,
        targetProtein: 160,
        targetCarbs: 220,
        targetFats: 58,
        meals: [
          MealDetailItem(
            id: "meal_b_02",
            slot: MealSlot.breakfast,
            slotTime: "8:00 AM",
            name: "Avocado Sourdough Toast & Poached Eggs",
            description:
                "Artisan toasted sourdough smeared with Haas avocado mash, chili flakes, sea salt, and two pasture-raised poached eggs.",
            prepNotes:
                "Sprinkle smoked paprika on eggs. Pair with black espresso.",
            calories: 420,
            protein: 22,
            carbs: 38,
            fats: 20,
            imageUrl:
                "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_02",
            slot: MealSlot.lunch,
            slotTime: "1:15 PM",
            name: "Garlic Butter Tiger Prawns & Wild Rice",
            description:
                "Jumbo tiger prawns sautéed with crushed garlic, smoked paprika, flat parsley, and steamed aromatic wild grain blend.",
            prepNotes:
                "High bioavailable protein with minimal bloat before afternoon tasks.",
            calories: 540,
            protein: 48,
            carbs: 46,
            fats: 13,
            imageUrl:
                "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_02",
            slot: MealSlot.snack,
            slotTime: "4:45 PM",
            name: "Dark Cacao Peanut Butter Protein Balls",
            description:
                "No-bake energy bites crafted from medjool dates, natural peanut butter, chia seeds, and 85% raw dark cacao.",
            prepNotes: "Grab 2 bites directly from fridge container.",
            calories: 240,
            protein: 18,
            carbs: 22,
            fats: 10,
            imageUrl:
                "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_02",
            slot: MealSlot.dinner,
            slotTime: "8:00 PM",
            name: "Grass-Fed Ribeye & Sweet Potato Mash",
            description:
                "Prime grass-fed sirloin grilled medium-rare served with roasted garlic sweet potato mash and rosemary herb butter.",
            prepNotes:
                "Provides creatine, zinc, and leucine for deep muscle synthesis.",
            calories: 720,
            protein: 58,
            carbs: 32,
            fats: 36,
            imageUrl:
                "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "W",
        dayName: "Wed",
        focus: "Active Recovery • Clean Balance",
        targetCalories: 1950,
        targetProtein: 155,
        targetCarbs: 180,
        targetFats: 55,
        meals: [
          MealDetailItem(
            id: "meal_b_03",
            slot: MealSlot.breakfast,
            slotTime: "8:15 AM",
            name: "Power Oats with Whey & Blueberries",
            description:
                "Warm rolled oats with blueberries, plant protein blend, and Ceylon cinnamon.",
            prepNotes: "Great for insulin sensitivity on rest days.",
            calories: 400,
            protein: 32,
            carbs: 50,
            fats: 7,
            imageUrl:
                "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_03",
            slot: MealSlot.lunch,
            slotTime: "1:00 PM",
            name: "Pan-Seared Salmon with Asparagus",
            description:
                "Crispy skin salmon with steamed greens and quinoa cup.",
            prepNotes: "Clean fuel with zero food-coma crash.",
            calories: 590,
            protein: 46,
            carbs: 22,
            fats: 30,
            imageUrl:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_03",
            slot: MealSlot.snack,
            slotTime: "4:30 PM",
            name: "Greek Yogurt Honey & Roasted Almonds",
            description: "Cool strained Greek yogurt with crushed almonds.",
            prepNotes: "High satiety afternoon snack.",
            calories: 230,
            protein: 21,
            carbs: 16,
            fats: 7,
            imageUrl:
                "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_03",
            slot: MealSlot.dinner,
            slotTime: "7:30 PM",
            name: "Grilled Herb Chicken & Quinoa Bowl",
            description:
                "Tender chicken breast with Mediterranean roasted vegetables.",
            prepNotes: "Eat before 8:30 PM for optimal deep sleep score.",
            calories: 550,
            protein: 50,
            carbs: 42,
            fats: 13,
            imageUrl:
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "T",
        dayName: "Thu",
        focus: "Posterior Chain • Power Surplus",
        targetCalories: 2200,
        targetProtein: 165,
        targetCarbs: 250,
        targetFats: 62,
        meals: [
          MealDetailItem(
            id: "meal_b_04",
            slot: MealSlot.breakfast,
            slotTime: "8:00 AM",
            name: "Avocado Sourdough Toast & Poached Eggs",
            description:
                "Toasted country sourdough with double poached eggs and chili flake.",
            prepNotes: "Provides clean sustained energy for lifting.",
            calories: 420,
            protein: 22,
            carbs: 38,
            fats: 20,
            imageUrl:
                "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_04",
            slot: MealSlot.lunch,
            slotTime: "1:00 PM",
            name: "Grilled Herb Chicken & Quinoa Bowl",
            description:
                "Lemon thyme chicken breast with quinoa and broccoli.",
            prepNotes: "Pack in glass container for easy office warming.",
            calories: 600,
            protein: 52,
            carbs: 52,
            fats: 14,
            imageUrl:
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_04",
            slot: MealSlot.snack,
            slotTime: "4:30 PM",
            name: "Dark Cacao Peanut Butter Protein Balls",
            description: "Peanut butter energy balls with whey protein.",
            prepNotes: "Take 30 mins before deadlifts.",
            calories: 240,
            protein: 18,
            carbs: 22,
            fats: 10,
            imageUrl:
                "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_04",
            slot: MealSlot.dinner,
            slotTime: "8:00 PM",
            name: "Garlic Butter Tiger Prawns & Wild Rice",
            description:
                "Sautéed prawns with smoked paprika and brown wild rice blend.",
            prepNotes: "Hydrate with 500ml water alongside meal.",
            calories: 550,
            protein: 48,
            carbs: 48,
            fats: 12,
            imageUrl:
                "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "F",
        dayName: "Fri",
        focus: "Full Body Circuit • Conditioning",
        targetCalories: 2150,
        targetProtein: 160,
        targetCarbs: 240,
        targetFats: 60,
        meals: [
          MealDetailItem(
            id: "meal_b_05",
            slot: MealSlot.breakfast,
            slotTime: "8:00 AM",
            name: "Power Oats with Whey & Blueberries",
            description:
                "Classic muscle oatmeal with whey protein and frozen blueberries.",
            prepNotes: "Quick & ready in under 3 minutes.",
            calories: 430,
            protein: 35,
            carbs: 54,
            fats: 8,
            imageUrl:
                "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_05",
            slot: MealSlot.lunch,
            slotTime: "1:15 PM",
            name: "Garlic Butter Tiger Prawns & Wild Rice",
            description: "Garlic prawns with steamed broccoli and wild rice.",
            prepNotes: "Lean protein powerhouse.",
            calories: 530,
            protein: 46,
            carbs: 45,
            fats: 11,
            imageUrl:
                "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_05",
            slot: MealSlot.snack,
            slotTime: "4:30 PM",
            name: "Greek Yogurt Honey & Roasted Almonds",
            description: "Greek yogurt with crushed almonds and cinnamon.",
            prepNotes: "Keeps energy flat and stable.",
            calories: 250,
            protein: 23,
            carbs: 18,
            fats: 8,
            imageUrl:
                "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_05",
            slot: MealSlot.dinner,
            slotTime: "8:00 PM",
            name: "Pan-Seared Salmon with Asparagus",
            description: "Salmon steak with asparagus and sweet potato wedges.",
            prepNotes: "End of week healthy celebration dinner.",
            calories: 650,
            protein: 48,
            carbs: 34,
            fats: 29,
            imageUrl:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "S",
        dayName: "Sat",
        focus: "Weekend Outdoor Endurance",
        targetCalories: 2400,
        targetProtein: 160,
        targetCarbs: 290,
        targetFats: 65,
        meals: [
          MealDetailItem(
            id: "meal_b_06",
            slot: MealSlot.breakfast,
            slotTime: "8:30 AM",
            name: "Avocado Sourdough Toast & Poached Eggs",
            description:
                "Double avocado toast with poached eggs and tomato relish.",
            prepNotes: "Fuel before long morning outdoor run or hike.",
            calories: 460,
            protein: 24,
            carbs: 44,
            fats: 22,
            imageUrl:
                "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_06",
            slot: MealSlot.lunch,
            slotTime: "1:30 PM",
            name: "Grilled Herb Chicken & Quinoa Bowl",
            description: "Extra large grilled chicken bowl with sweet corn.",
            prepNotes: "Replenish depleted glycogen stores.",
            calories: 660,
            protein: 56,
            carbs: 64,
            fats: 16,
            imageUrl:
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_06",
            slot: MealSlot.snack,
            slotTime: "5:00 PM",
            name: "Dark Cacao Peanut Butter Protein Balls",
            description: "3 protein energy balls with cold oat milk.",
            prepNotes: "Sweet craving crusher.",
            calories: 300,
            protein: 22,
            carbs: 28,
            fats: 12,
            imageUrl:
                "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_06",
            slot: MealSlot.dinner,
            slotTime: "8:15 PM",
            name: "Grass-Fed Ribeye & Sweet Potato Mash",
            description: "Sirloin steak with roasted garlic mash.",
            prepNotes: "Weekend prime recovery meal.",
            calories: 740,
            protein: 58,
            carbs: 34,
            fats: 38,
            imageUrl:
                "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
      DayNutritionSchedule(
        dayShort: "S",
        dayName: "Sun",
        focus: "Rest & Prep • Moderate Carb",
        targetCalories: 1900,
        targetProtein: 150,
        targetCarbs: 180,
        targetFats: 55,
        meals: [
          MealDetailItem(
            id: "meal_b_07",
            slot: MealSlot.breakfast,
            slotTime: "9:00 AM",
            name: "Power Oats with Whey & Blueberries",
            description: "Slow Sunday oatmeal with fresh blueberries.",
            prepNotes: "Enjoy relaxed Sunday morning routine.",
            calories: 400,
            protein: 32,
            carbs: 50,
            fats: 7,
            imageUrl:
                "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_l_07",
            slot: MealSlot.lunch,
            slotTime: "1:30 PM",
            name: "Garlic Butter Tiger Prawns & Wild Rice",
            description: "Sauteed shrimp over warm wild rice bowl.",
            prepNotes: "Meal prep week ahead during or after lunch.",
            calories: 520,
            protein: 46,
            carbs: 44,
            fats: 11,
            imageUrl:
                "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_s_07",
            slot: MealSlot.snack,
            slotTime: "4:30 PM",
            name: "Greek Yogurt Honey & Roasted Almonds",
            description: "Greek yogurt cup with almonds and honey.",
            prepNotes: "Light snack before evening stroll.",
            calories: 230,
            protein: 21,
            carbs: 16,
            fats: 7,
            imageUrl:
                "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&q=80",
            isEaten: false,
          ),
          MealDetailItem(
            id: "meal_d_07",
            slot: MealSlot.dinner,
            slotTime: "7:30 PM",
            name: "Pan-Seared Salmon with Asparagus",
            description: "Tender salmon with asparagus spears.",
            prepNotes: "Light dinner ready for Monday morning kickoff.",
            calories: 590,
            protein: 46,
            carbs: 22,
            fats: 30,
            imageUrl:
                "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80",
            isEaten: false,
          ),
        ],
      ),
    ];
  }

  DayNutritionSchedule get _currentDaySchedule =>
      _weekSchedule[_selectedDayIndex];

  // Eaten Macros
  int get _eatenCalories => _currentDaySchedule.meals
      .where((m) => m.isEaten)
      .fold(0, (sum, m) => sum + m.calories);
  int get _eatenProtein => _currentDaySchedule.meals
      .where((m) => m.isEaten)
      .fold(0, (sum, m) => sum + m.protein);
  int get _eatenCarbs => _currentDaySchedule.meals
      .where((m) => m.isEaten)
      .fold(0, (sum, m) => sum + m.carbs);
  int get _eatenFats => _currentDaySchedule.meals
      .where((m) => m.isEaten)
      .fold(0, (sum, m) => sum + m.fats);

  // Total Planned for Day
  int get _plannedCalories => _currentDaySchedule.meals
      .fold(0, (sum, m) => sum + m.calories);
  int get _plannedProtein => _currentDaySchedule.meals
      .fold(0, (sum, m) => sum + m.protein);
  int get _plannedCarbs => _currentDaySchedule.meals
      .fold(0, (sum, m) => sum + m.carbs);
  int get _plannedFats => _currentDaySchedule.meals
      .fold(0, (sum, m) => sum + m.fats);

  void _toggleMealEaten(MealDetailItem meal) {
    setState(() {
      meal.isEaten = !meal.isEaten;
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              meal.isEaten
                  ? Icons.check_circle_rounded
                  : Icons.remove_circle_outline_rounded,
              color: meal.isEaten ? AppTheme.primary : Colors.amberAccent,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                meal.isEaten
                    ? "Marked \"${meal.name}\" as Eaten (+${meal.calories} kcal)"
                    : "Unchecked \"${meal.name}\"",
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
          side: BorderSide(
            color: meal.isEaten ? AppTheme.primary : AppTheme.surfaceBorder,
          ),
        ),
      ),
    );
  }

  void _toggleMealExpand(String mealId) {
    setState(() {
      if (_expandedMealIds.contains(mealId)) {
        _expandedMealIds.remove(mealId);
      } else {
        _expandedMealIds.add(mealId);
      }
    });
  }

  void _showMessageCoachSheet() {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                  backgroundImage: NetworkImage(widget.coachAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message ${widget.coachName}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        "Dietary adjustments, meal swaps & timing questions",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              maxLines: 4,
              style: GoogleFonts.manrope(
                color: AppTheme.textDark,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText:
                    "E.g., Can I swap salmon for tofu on Friday? Feeling low energy around 4 PM...",
                hintStyle: GoogleFonts.manrope(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: const Color(0xFF131613),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.send_rounded,
                              color: AppTheme.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Message sent to ${widget.coachName}",
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
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  "Send to Coach",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = _currentDaySchedule;
    final isCoach = _currentSource == PlanSource.coachAssigned;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Meal Plan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        actions: [
          // Edit Plan button if self-built
          if (!isCoach)
            IconButton(
              icon: const Icon(Icons.tune_rounded, color: AppTheme.primary),
              tooltip: "Edit Plan",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelfBuildMealPlanScreen(),
                  ),
                );
              },
            ),

          // Demo source toggle (switch between Coach-Assigned and Built-by-You)
          PopupMenuButton<PlanSource>(
            tooltip: "Switch Demo Mode",
            icon: const Icon(Icons.more_vert_rounded,
                color: AppTheme.textSecondary),
            color: AppTheme.surfaceDark,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (source) {
              setState(() {
                _currentSource = source;
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: PlanSource.coachAssigned,
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppTheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Demo: Coach-Assigned",
                      style: GoogleFonts.manrope(
                        color: _currentSource == PlanSource.coachAssigned
                            ? AppTheme.primary
                            : AppTheme.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: PlanSource.selfBuilt,
                child: Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        color: Colors.amberAccent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Demo: Built by You",
                      style: GoogleFonts.manrope(
                        color: _currentSource == PlanSource.selfBuilt
                            ? AppTheme.primary
                            : AppTheme.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header with Title & Source Tag + Message Coach action
              _buildHeaderSourceTag(isCoach)
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: 18),

              // 2. Weekly Day Selector Row (M-T-W-T-F-S-S pattern from Home)
              _buildWeeklyDaySelector()
                  .animate()
                  .fadeIn(delay: 80.ms, duration: 350.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: 20),

              // 3. Daily Macro Summary Stat Cards (matching Steps/Water/Sleep style)
              _buildMacroStatCardsRow(day)
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: 24),

              // 4. Section Title with Day Focus & Eaten Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${day.dayName}'s Meals",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        day.focus,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      "${day.meals.where((m) => m.isEaten).length}/${day.meals.length} Eaten",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 5. Expandable Meal Cards Grouped by Time (Breakfast, Lunch, Snacks, Dinner)
              ...day.meals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
                return _buildExpandableMealCard(meal)
                    .animate()
                    .fadeIn(delay: (200 + index * 70).ms, duration: 350.ms)
                    .slideY(begin: 0.06, end: 0);
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. Header: Source Tag ("Assigned by Coach" vs "Built by You")
  // ===========================================================================
  Widget _buildHeaderSourceTag(bool isCoach) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCoach
              ? AppTheme.primary.withValues(alpha: 0.4)
              : AppTheme.surfaceBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isCoach
                ? AppTheme.primary.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isCoach) ...[
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primary, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF222622),
                backgroundImage: NetworkImage(widget.coachAvatar),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
          ],
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Meal Plan",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isCoach ? Icons.verified_rounded : Icons.tune_rounded,
                      color: AppTheme.primary,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isCoach
                      ? "Assigned by ${widget.coachName}"
                      : "Built by You • Custom Macros",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (isCoach) ...[
            ElevatedButton.icon(
              onPressed: _showMessageCoachSheet,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
              label: Text(
                "Message",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(60, 34),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. Weekly Day Selector Row (M - T - W - T - F - S - S)
  // ===========================================================================
  Widget _buildWeeklyDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Weekly Schedule",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              _selectedDayIndex == _todayIndex
                  ? "Showing Today"
                  : "Showing ${_weekSchedule[_selectedDayIndex].dayName}",
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _selectedDayIndex == _todayIndex
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_weekSchedule.length, (index) {
              final dayItem = _weekSchedule[index];
              final isToday = index == _todayIndex;
              final isSelected = index == _selectedDayIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary
                          : (isToday
                              ? AppTheme.primary.withValues(alpha: 0.12)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : (isToday
                                ? AppTheme.primary.withValues(alpha: 0.5)
                                : Colors.transparent),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayItem.dayShort,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF0D0F0D)
                                : (isToday ? AppTheme.primary : AppTheme.textDark),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dayItem.dayName,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF0D0F0D).withValues(alpha: 0.8)
                                : AppTheme.textSecondary,
                          ),
                        ),
                        if (isToday && !isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 3. Daily Macro Stat Cards (matching Home Dashboard Steps/Water/Sleep style)
  // ===========================================================================
  Widget _buildMacroStatCardsRow(DayNutritionSchedule day) {
    // Current vs planned / target values
    final calProgress = (day.targetCalories > 0
            ? _plannedCalories / day.targetCalories
            : 0.0)
        .clamp(0.0, 1.0);
    final proteinProgress = (day.targetProtein > 0
            ? _plannedProtein / day.targetProtein
            : 0.0)
        .clamp(0.0, 1.0);
    final carbsProgress =
        (day.targetCarbs > 0 ? _plannedCarbs / day.targetCarbs : 0.0)
            .clamp(0.0, 1.0);
    final fatsProgress =
        (day.targetFats > 0 ? _plannedFats / day.targetFats : 0.0)
            .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Calorie Summary Header Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF181D18), AppTheme.surfaceDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9100).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFFF9100).withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFFF9100),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Calorie Target",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "$_plannedCalories",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "/ ${day.targetCalories} kcal",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          "$_eatenCalories kcal eaten",
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${(calProgress * 100).toInt()}% planned",
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: calProgress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFF222722),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal StatCard Row (Protein, Carbs, Fats)
        // Direct consistency with Steps, Water, Sleep cards on Home
        Row(
          children: [
            // Metric 1: Protein (Dumbbell icon, Neon green accent)
            Expanded(
              child: StatCard(
                title: "Protein",
                value: "${_plannedProtein}g",
                target: "$_plannedProtein/${day.targetProtein}g",
                progress: proteinProgress,
                trend: "${_eatenProtein}g",
                trendPositive: true,
                icon: Icons.fitness_center_rounded,
                color: AppTheme.primary,
                progressColor: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 10),

            // Metric 2: Carbs (Grain icon, Amber accent)
            Expanded(
              child: StatCard(
                title: "Carbs",
                value: "${_plannedCarbs}g",
                target: "$_plannedCarbs/${day.targetCarbs}g",
                progress: carbsProgress,
                trend: "${_eatenCarbs}g",
                trendPositive: true,
                icon: Icons.grain_rounded,
                color: Colors.amberAccent,
                progressColor: Colors.amberAccent,
              ),
            ),
            const SizedBox(width: 10),

            // Metric 3: Fats (Water drop icon, Cyan accent)
            Expanded(
              child: StatCard(
                title: "Fats",
                value: "${_plannedFats}g",
                target: "$_plannedFats/${day.targetFats}g",
                progress: fatsProgress,
                trend: "${_eatenFats}g",
                trendPositive: true,
                icon: Icons.water_drop_rounded,
                color: Colors.cyanAccent,
                progressColor: Colors.cyanAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 5. Expandable Meal Card
  // ===========================================================================
  Widget _buildExpandableMealCard(MealDetailItem meal) {
    final isExpanded = _expandedMealIds.contains(meal.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: meal.isEaten
              ? AppTheme.primary.withValues(alpha: 0.5)
              : (isExpanded
                  ? AppTheme.primary.withValues(alpha: 0.3)
                  : AppTheme.surfaceBorder),
          width: meal.isEaten ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: meal.isEaten
                ? AppTheme.primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Meal Slot Header (Breakfast, Lunch, Dinner, Snack + Time)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        meal.slot.icon,
                        color: AppTheme.primary,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      meal.slot.title.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "• ${meal.slotTime}",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),

                // "Mark as Eaten" Quick Checkbox / Pill
                GestureDetector(
                  onTap: () => _toggleMealEaten(meal),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: meal.isEaten
                          ? AppTheme.primary
                          : const Color(0xFF222622),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: meal.isEaten
                            ? AppTheme.primary
                            : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          meal.isEaten
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 14,
                          color: meal.isEaten
                              ? const Color(0xFF0D0F0D)
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          meal.isEaten ? "Eaten" : "Mark as Eaten",
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: meal.isEaten
                                ? const Color(0xFF0D0F0D)
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: AppTheme.surfaceBorder.withValues(alpha: 0.5),
          ),

          // Core Meal Content (Tap to Expand)
          InkWell(
            onTap: () => _toggleMealExpand(meal.id),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Photo Thumbnail (Rounded corners)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Image.network(
                            meal.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFF222622),
                              child: const Icon(Icons.restaurant_rounded,
                                  color: AppTheme.primary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name + Macro Summary Row
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                                decoration: meal.isEaten
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: AppTheme.primary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Macro pills row
                            Row(
                              children: [
                                _buildMiniMacroBadge(
                                  "${meal.calories} kcal",
                                  const Color(0xFFFF9100),
                                  Icons.local_fire_department_rounded,
                                ),
                                const SizedBox(width: 6),
                                _buildMiniMacroBadge(
                                  "${meal.protein}g P",
                                  AppTheme.primary,
                                  Icons.fitness_center_rounded,
                                ),
                                const SizedBox(width: 6),
                                _buildMiniMacroBadge(
                                  "${meal.carbs}g C",
                                  Colors.amberAccent,
                                  Icons.grain_rounded,
                                ),
                                const SizedBox(width: 6),
                                _buildMiniMacroBadge(
                                  "${meal.fats}g F",
                                  Colors.cyanAccent,
                                  Icons.water_drop_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Expand Chevron
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF222622),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),

                  // Expanded Information: Description, Macro Breakdown, Prep Notes
                  if (isExpanded) ...[
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      meal.description,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textDark.withValues(alpha: 0.9),
                        height: 1.45,
                      ),
                    ),

                    // Preparation note / Coach tip
                    if (meal.prepNotes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141714),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.surfaceBorder,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 16,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                meal.prepNotes,
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Large "Mark as Eaten" Toggle Button in Expanded view
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleMealEaten(meal),
                        icon: Icon(
                          meal.isEaten
                              ? Icons.check_circle_rounded
                              : Icons.check_rounded,
                          size: 16,
                          color: meal.isEaten
                              ? const Color(0xFF0D0F0D)
                              : AppTheme.primary,
                        ),
                        label: Text(
                          meal.isEaten
                              ? "Marked as Eaten"
                              : "Mark ${meal.slot.title} as Eaten",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: meal.isEaten
                                ? const Color(0xFF0D0F0D)
                                : AppTheme.primary,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: meal.isEaten
                              ? AppTheme.primary
                              : AppTheme.primary.withValues(alpha: 0.12),
                          foregroundColor: meal.isEaten
                              ? const Color(0xFF0D0F0D)
                              : AppTheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppTheme.primary.withValues(alpha: 0.5),
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMacroBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
