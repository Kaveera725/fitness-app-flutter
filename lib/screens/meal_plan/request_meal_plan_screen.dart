import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

/// User profile data model for auto-fetching metabolic and fitness attributes
class MockUserProfile {
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final double? bodyFatPercent;
  final String? fitnessGoal;

  const MockUserProfile({
    this.age = 26,
    this.heightCm = 178.0,
    this.weightKg = 76.5,
    this.bodyFatPercent = 14.5,
    this.fitnessGoal = "Hypertrophy / Muscle Gain",
  });
}

class RequestMealPlanScreen extends StatefulWidget {
  final String coachName;
  final String coachSpecialty;
  final String coachAvatarUrl;
  final MockUserProfile? userProfile;
  final VoidCallback? onRequestSubmitted;

  const RequestMealPlanScreen({
    super.key,
    this.coachName = 'Alex Strong',
    this.coachSpecialty = 'Strength & Sports Nutrition',
    this.coachAvatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    this.userProfile,
    this.onRequestSubmitted,
  });

  @override
  State<RequestMealPlanScreen> createState() => _RequestMealPlanScreenState();
}

class _RequestMealPlanScreenState extends State<RequestMealPlanScreen> {
  // Form controllers for auto-fetched profile fields
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _bodyFatController;

  // Form controllers for new fields
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Fitness goal dropdown
  late String _selectedFitnessGoal;
  final List<String> _fitnessGoals = [
    "Hypertrophy / Muscle Gain",
    "Fat Loss & Caloric Deficit",
    "Body Recomposition",
    "Athletic Performance & Endurance",
    "Strength & Powerlifting",
    "Clean Maintenance & Longevity",
  ];

  // Dietary preferences multi-select chips
  final List<String> _dietaryOptions = [
    "No Restrictions",
    "Vegetarian",
    "Vegan",
    "Halal",
    "Keto / Low Carb",
    "Pescatarian",
    "High Protein Clean",
  ];
  final Set<String> _selectedDietaryPreferences = {};

  // Meals per day stepper
  int _mealsPerDay = 4;

  // Validation tracking
  bool _submittedOnce = false;
  final Map<String, String?> _errors = {};

  // Success state flag
  bool _isSuccess = false;

  // Track which profile attributes were auto-filled originally
  bool _autoFilledAge = false;
  bool _autoFilledHeight = false;
  bool _autoFilledWeight = false;
  bool _autoFilledBodyFat = false;
  bool _autoFilledGoal = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.userProfile ?? const MockUserProfile();

    // Auto-fill Age
    if (profile.age != null && profile.age! > 0) {
      _ageController = TextEditingController(text: profile.age.toString());
      _autoFilledAge = true;
    } else {
      _ageController = TextEditingController();
    }

    // Auto-fill Height
    if (profile.heightCm != null && profile.heightCm! > 0) {
      _heightController = TextEditingController(
        text: profile.heightCm! % 1 == 0
            ? profile.heightCm!.toInt().toString()
            : profile.heightCm!.toString(),
      );
      _autoFilledHeight = true;
    } else {
      _heightController = TextEditingController();
    }

    // Auto-fill Weight
    if (profile.weightKg != null && profile.weightKg! > 0) {
      _weightController = TextEditingController(
        text: profile.weightKg! % 1 == 0
            ? profile.weightKg!.toInt().toString()
            : profile.weightKg!.toString(),
      );
      _autoFilledWeight = true;
    } else {
      _weightController = TextEditingController();
    }

    // Auto-fill Body Fat %
    if (profile.bodyFatPercent != null && profile.bodyFatPercent! > 0) {
      _bodyFatController = TextEditingController(text: "${profile.bodyFatPercent}%");
      _autoFilledBodyFat = true;
    } else {
      _bodyFatController = TextEditingController();
    }

    // Auto-fill Fitness Goal
    if (profile.fitnessGoal != null && _fitnessGoals.contains(profile.fitnessGoal)) {
      _selectedFitnessGoal = profile.fitnessGoal!;
      _autoFilledGoal = true;
    } else {
      _selectedFitnessGoal = _fitnessGoals.first;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bodyFatController.dispose();
    _allergiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _submittedOnce = true;
      _errors.clear();

      if (_ageController.text.trim().isEmpty) {
        _errors['age'] = "Age is required";
      } else {
        final age = int.tryParse(_ageController.text.trim());
        if (age == null || age < 12 || age > 100) {
          _errors['age'] = "Enter a realistic age (12-100)";
        }
      }

      if (_heightController.text.trim().isEmpty) {
        _errors['height'] = "Height is required";
      } else {
        final h = double.tryParse(_heightController.text.trim().replaceAll(RegExp(r'[^0-9.]'), ''));
        if (h == null || h < 90 || h > 250) {
          _errors['height'] = "Enter valid height (90-250 cm)";
        }
      }

      if (_weightController.text.trim().isEmpty) {
        _errors['weight'] = "Weight is required";
      } else {
        final w = double.tryParse(_weightController.text.trim().replaceAll(RegExp(r'[^0-9.]'), ''));
        if (w == null || w < 30 || w > 300) {
          _errors['weight'] = "Enter valid weight (30-300 kg)";
        }
      }

      if (_selectedDietaryPreferences.isEmpty) {
        _errors['diet'] = "Please select at least one dietary preference";
      }
    });

    return _errors.isEmpty;
  }

  void _handleSubmit() {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Please fix highlighted fields before sending your request",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Trigger success state animation
    setState(() {
      _isSuccess = true;
    });

    // Notify caller and return back to hub after short delay
    widget.onRequestSubmitted?.call();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Request a Meal Plan",
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
      ),
      body: _isSuccess ? _buildSuccessView() : _buildFormView(),
    );
  }

  // ==========================================
  // Form Content View
  // ==========================================
  Widget _buildFormView() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Coach Target Card Header
              _buildCoachHeaderCard()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),
              const SizedBox(height: 24),

              // 2. Section Header: Auto-Fetched Profile Data
              _buildSectionTitle(
                title: "Your Metabolic Profile",
                subtitle: "Auto-synced from your profile. You can edit any value for this request.",
                badgeText: "PRE-FILLED",
              ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
              const SizedBox(height: 14),

              // Age & Body Fat % Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProfileInputField(
                      label: "Age",
                      controller: _ageController,
                      hint: "e.g. 26",
                      suffixText: "yrs",
                      keyboardType: TextInputType.number,
                      isAutoFilled: _autoFilledAge,
                      errorText: _errors['age'],
                      onChanged: (val) {
                        if (_submittedOnce) _validateForm();
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildProfileInputField(
                      label: "Body Fat %",
                      controller: _bodyFatController,
                      hint: "e.g. 14.5%",
                      suffixText: "%",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      isAutoFilled: _autoFilledBodyFat,
                      isOptional: true,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
              const SizedBox(height: 14),

              // Height & Weight Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProfileInputField(
                      label: "Height",
                      controller: _heightController,
                      hint: "e.g. 178",
                      suffixText: "cm",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      isAutoFilled: _autoFilledHeight,
                      errorText: _errors['height'],
                      onChanged: (val) {
                        if (_submittedOnce) _validateForm();
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildProfileInputField(
                      label: "Weight",
                      controller: _weightController,
                      hint: "e.g. 76.5",
                      suffixText: "kg",
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      isAutoFilled: _autoFilledWeight,
                      errorText: _errors['weight'],
                      onChanged: (val) {
                        if (_submittedOnce) _validateForm();
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 160.ms, duration: 400.ms),
              const SizedBox(height: 14),

              // Current Fitness Goal (Dropdown pre-selected from profile)
              _buildFitnessGoalDropdown()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 28),

              // 3. Section Header: Additional Nutrition Specifications (Not in Profile)
              _buildSectionTitle(
                title: "Nutrition & Diet Preferences",
                subtitle: "Specify restrictions and meal schedule so your coach can craft accurate recipes.",
                badgeText: "REQUIRED",
                badgeColor: AppTheme.primary,
              ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
              const SizedBox(height: 14),

              // Dietary Preferences Multi-Select Chips
              _buildDietaryPreferencesChips()
                  .animate()
                  .fadeIn(delay: 280.ms, duration: 400.ms),
              const SizedBox(height: 18),

              // Allergies & Disliked Ingredients
              _buildStandardTextField(
                label: "Allergies & Intolerances",
                controller: _allergiesController,
                hint: "e.g. Shellfish, peanuts, lactose intolerant, cilantro...",
                icon: Icons.no_food_outlined,
                helperText: "Leave blank if you have no dietary sensitivities",
              ).animate().fadeIn(delay: 320.ms, duration: 400.ms),
              const SizedBox(height: 20),

              // Meals Per Day Stepper
              _buildMealsPerDayStepper()
                  .animate()
                  .fadeIn(delay: 360.ms, duration: 400.ms),
              const SizedBox(height: 20),

              // Additional Notes For Coach (Multiline, Optional)
              _buildStandardTextField(
                label: "Notes for ${widget.coachName} (Optional)",
                controller: _notesController,
                hint: "Share upcoming schedule changes, workout timing preferences, supplements you take, or target completion dates...",
                icon: Icons.edit_note_rounded,
                maxLines: 4,
                minLines: 3,
                helperText: "Helps your coach fine-tune timing around your workouts",
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // Sticky Bottom CTA Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark.withValues(alpha: 0.95),
              border: Border(
                top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18, color: Color(0xFF0D0F0D)),
                    const SizedBox(width: 8),
                    Text(
                      "Send Request to ${widget.coachName}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: const Color(0xFF0D0F0D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 1. Coach Target Card Header
  // ==========================================
  Widget _buildCoachHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coach Avatar with glowing ring
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                widget.coachAvatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF222622),
                  child: const Icon(Icons.person, color: AppTheme.primary),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "ASSIGNED COACH",
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, size: 14, color: AppTheme.primary),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Requesting from ${widget.coachName}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  widget.coachSpecialty,
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
    );
  }

  // ==========================================
  // Section Title with Badge
  // ==========================================
  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    required String badgeText,
    Color? badgeColor,
  }) {
    final effectiveColor = badgeColor ?? AppTheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: effectiveColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: effectiveColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            fontSize: 12,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Profile Input Field (Visual Auto-Fill Indicator)
  // ==========================================
  Widget _buildProfileInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String suffixText,
    TextInputType keyboardType = TextInputType.text,
    bool isAutoFilled = false,
    bool isOptional = false,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    final isNotEmpty = controller.text.trim().isNotEmpty;
    final hasError = errorText != null;

    // Visual distinction:
    // If auto-filled: small "from your profile" badge
    // If empty & required: subtle highlight/border prompting user to fill
    final isCurrentlyPrompted = !isNotEmpty && !isOptional;

    Color borderColor;
    if (hasError) {
      borderColor = Colors.redAccent;
    } else if (isCurrentlyPrompted && _submittedOnce) {
      borderColor = Colors.redAccent.withValues(alpha: 0.8);
    } else if (isCurrentlyPrompted) {
      borderColor = AppTheme.primary.withValues(alpha: 0.45);
    } else if (isAutoFilled) {
      borderColor = AppTheme.surfaceBorder;
    } else {
      borderColor = AppTheme.surfaceBorder;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            if (isAutoFilled && isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_pin_circle_outlined, size: 12, color: AppTheme.primary),
                  const SizedBox(width: 3),
                  Text(
                    "from profile",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              )
            else if (isCurrentlyPrompted)
              Text(
                "Please fill in",
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: (hasError || (isCurrentlyPrompted && !_submittedOnce)) ? 1.4 : 1.0,
            ),
            boxShadow: isCurrentlyPrompted
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(fontSize: 14, color: AppTheme.textSecondary.withValues(alpha: 0.6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
              suffixText: suffixText,
              suffixStyle: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isNotEmpty ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: GoogleFonts.manrope(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // Fitness Goal Dropdown
  // ==========================================
  Widget _buildFitnessGoalDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Fitness Goal",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            if (_autoFilledGoal)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_pin_circle_outlined, size: 12, color: AppTheme.primary),
                  const SizedBox(width: 3),
                  Text(
                    "from profile",
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.surfaceBorder, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFitnessGoal,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceDark,
              icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primary, size: 28),
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              items: _fitnessGoals.map((goal) {
                return DropdownMenuItem<String>(
                  value: goal,
                  child: Text(goal),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedFitnessGoal = val;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Dietary Preferences Multi-Select Chips
  // ==========================================
  Widget _buildDietaryPreferencesChips() {
    final hasError = _errors.containsKey('diet');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dietary Preference (Select all that apply)",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              "${_selectedDietaryPreferences.length} selected",
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _selectedDietaryPreferences.isNotEmpty ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError ? Colors.redAccent : AppTheme.surfaceBorder,
              width: hasError ? 1.4 : 1.0,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dietaryOptions.map((diet) {
              final isSelected = _selectedDietaryPreferences.contains(diet);
              return FilterChip(
                label: Text(
                  diet,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primary,
                backgroundColor: const Color(0xFF222622),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                    width: 1,
                  ),
                ),
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    if (diet == "No Restrictions") {
                      if (selected) {
                        _selectedDietaryPreferences.clear();
                        _selectedDietaryPreferences.add("No Restrictions");
                      } else {
                        _selectedDietaryPreferences.remove("No Restrictions");
                      }
                    } else {
                      _selectedDietaryPreferences.remove("No Restrictions");
                      if (selected) {
                        _selectedDietaryPreferences.add(diet);
                      } else {
                        _selectedDietaryPreferences.remove(diet);
                      }
                    }
                    if (_submittedOnce) _validateForm();
                  });
                },
              );
            }).toList(),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            _errors['diet']!,
            style: GoogleFonts.manrope(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // Meals Per Day Stepper
  // ==========================================
  Widget _buildMealsPerDayStepper() {
    String scheduleDescription;
    if (_mealsPerDay == 3) {
      scheduleDescription = "Standard: Breakfast, Lunch, Dinner";
    } else if (_mealsPerDay == 4) {
      scheduleDescription = "Optimal: Breakfast, Lunch, Post-Workout Snack, Dinner";
    } else if (_mealsPerDay == 5) {
      scheduleDescription = "High Frequency: Breakfast, Snack 1, Lunch, Snack 2, Dinner";
    } else if (_mealsPerDay == 6) {
      scheduleDescription = "Bodybuilding Split: 6 small protein-rich meals";
    } else {
      scheduleDescription = "Intermittent Fasting / 2 Main Feeds";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meals Per Day",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scheduleDescription,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Decrement Button
                  IconButton(
                    onPressed: _mealsPerDay > 2
                        ? () {
                            setState(() {
                              _mealsPerDay--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    color: _mealsPerDay > 2 ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.3),
                    iconSize: 28,
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      "$_mealsPerDay",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  // Increment Button
                  IconButton(
                    onPressed: _mealsPerDay < 6
                        ? () {
                            setState(() {
                              _mealsPerDay++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    color: _mealsPerDay < 6 ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.3),
                    iconSize: 28,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Standard Custom Text Field
  // ==========================================
  Widget _buildStandardTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int minLines = 1,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.surfaceBorder, width: 1),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary.withValues(alpha: 0.6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
              border: InputBorder.none,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // Success Confirmation Animation View
  // ==========================================
  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing Checkmark with scale and rotate animation
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 58,
                color: AppTheme.primary,
              ),
            )
                .animate()
                .scale(duration: 500.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 28),

            Text(
              "Request Sent to ${widget.coachName}!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 450.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 12),

            Text(
              "You'll be notified once your meal plan is ready. Your coach has received your metabolic stats, $_mealsPerDay-meal schedule, and dietary preferences.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            )
                .animate()
                .fadeIn(delay: 350.ms, duration: 450.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 32),

            // Subtle Loading Progress Indicator
            SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                backgroundColor: AppTheme.surfaceBorder,
                strokeWidth: 3,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            const SizedBox(height: 14),

            Text(
              "Returning to Meal Hub...",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
