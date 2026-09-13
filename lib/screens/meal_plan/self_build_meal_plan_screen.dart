import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class SelfBuildMealPlanScreen extends StatefulWidget {
  final VoidCallback? onPlanCreated;

  const SelfBuildMealPlanScreen({super.key, this.onPlanCreated});

  @override
  State<SelfBuildMealPlanScreen> createState() => _SelfBuildMealPlanScreenState();
}

class _SelfBuildMealPlanScreenState extends State<SelfBuildMealPlanScreen> {
  String _selectedGoal = "High Protein / Muscle Building";
  int _targetCalories = 2200;
  String _dietaryPreference = "Balanced Clean";

  final List<String> _goals = [
    "High Protein / Muscle Building",
    "Fat Loss & Calorie Deficit",
    "Endurance & High Energy",
    "Maintenance & Recovery",
  ];

  final List<String> _preferences = [
    "Balanced Clean",
    "Keto / Low Carb",
    "Vegetarian",
    "Pescatarian",
    "Vegan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: Text(
          "Build Meal Plan",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.surfaceBorder, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant_menu_rounded, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Custom Nutrition Architecture",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Tailor your daily calories and macro splits to match your fitness targets.",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Goal Selection
            Text(
              "Nutritional Goal",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
            ),
            const SizedBox(height: 10),
            Column(
              children: _goals.map((goal) {
                final isSelected = _selectedGoal == goal;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGoal = goal),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary.withValues(alpha: 0.12) : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          goal,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppTheme.primary : AppTheme.textDark,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Daily Calorie Target
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Target Calories",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                ),
                Text(
                  "$_targetCalories kcal",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.primary,
                inactiveTrackColor: const Color(0xFF242824),
                thumbColor: AppTheme.primary,
                overlayColor: AppTheme.primary.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _targetCalories.toDouble(),
                min: 1500,
                max: 3500,
                divisions: 20,
                onChanged: (val) => setState(() => _targetCalories = val.toInt()),
              ),
            ),
            const SizedBox(height: 20),

            // Dietary Preference Chips
            Text(
              "Dietary Preference",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _preferences.map((pref) {
                final isSelected = _dietaryPreference == pref;
                return ChoiceChip(
                  label: Text(pref),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _dietaryPreference = pref),
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.surfaceDark,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                  ),
                  labelStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onPlanCreated?.call();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  "Generate My Meal Plan",
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
      ),
    );
  }
}
