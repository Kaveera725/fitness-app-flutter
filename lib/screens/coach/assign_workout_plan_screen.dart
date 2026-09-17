import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Exercise & Routine Models
// ─────────────────────────────────────────────────────────────────────────────

class ExerciseDefinition {
  final String id;
  final String name;
  final String category; // Chest, Back, Legs, Shoulders, Arms, Core, Cardio
  final String targetMuscle;
  final String secondaryMuscle;
  final String equipment;
  final String difficulty;
  final String imageUrl;
  final int defaultSets;
  final String defaultReps;
  final String defaultRest;

  const ExerciseDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.targetMuscle,
    required this.secondaryMuscle,
    required this.equipment,
    required this.difficulty,
    required this.imageUrl,
    this.defaultSets = 3,
    this.defaultReps = '10-12',
    this.defaultRest = '60s',
  });
}

class AssignedExercise {
  final String id;
  final ExerciseDefinition exercise;
  int sets;
  String reps;
  String rest;

  AssignedExercise({
    required this.id,
    required this.exercise,
    this.sets = 3,
    this.reps = '10-12',
    this.rest = '60s',
  });
}

class DaySchedule {
  final String dayName; // Monday, Tuesday...
  final String shortName; // Mon, Tue...
  String focusTitle; // e.g. "Chest & Triceps Hypertrophy"
  bool isRestDay;
  final List<AssignedExercise> exercises;

  DaySchedule({
    required this.dayName,
    required this.shortName,
    required this.focusTitle,
    this.isRestDay = false,
    required this.exercises,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Exercise Library Database (25+ Realistic Exercises)
// ─────────────────────────────────────────────────────────────────────────────

final List<ExerciseDefinition> kExerciseLibrary = [
  // Chest
  const ExerciseDefinition(
    id: 'ex_bench_press',
    name: 'Barbell Bench Press',
    category: 'Chest',
    targetMuscle: 'Pectoralis Major',
    secondaryMuscle: 'Triceps, Anterior Deltoid',
    equipment: 'Barbell & Flat Bench',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&q=80',
    defaultSets: 4,
    defaultReps: '8-10',
    defaultRest: '90s',
  ),
  const ExerciseDefinition(
    id: 'ex_incline_db_press',
    name: 'Incline Dumbbell Press',
    category: 'Chest',
    targetMuscle: 'Upper Pectorals',
    secondaryMuscle: 'Front Delts, Triceps',
    equipment: 'Dumbbells & Incline Bench',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '60s',
  ),
  const ExerciseDefinition(
    id: 'ex_cable_flyes',
    name: 'Cable Chest Flyes',
    category: 'Chest',
    targetMuscle: 'Sternal Pectorals',
    secondaryMuscle: 'Anterior Delts',
    equipment: 'Dual Cable Pulley',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&q=80',
    defaultSets: 3,
    defaultReps: '12-15',
    defaultRest: '45s',
  ),
  const ExerciseDefinition(
    id: 'ex_pushups',
    name: 'Deficit Push-Ups',
    category: 'Chest',
    targetMuscle: 'Chest & Core',
    secondaryMuscle: 'Serratus, Triceps',
    equipment: 'Bodyweight / Parallettes',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=400&q=80',
    defaultSets: 3,
    defaultReps: '15-20',
    defaultRest: '45s',
  ),

  // Back
  const ExerciseDefinition(
    id: 'ex_deadlift',
    name: 'Conventional Barbell Deadlift',
    category: 'Back',
    targetMuscle: 'Posterior Chain',
    secondaryMuscle: 'Lats, Glutes, Hamstrings',
    equipment: 'Olympic Barbell',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1521804906057-1df8fdb718b7?w=400&q=80',
    defaultSets: 4,
    defaultReps: '5-6',
    defaultRest: '120s',
  ),
  const ExerciseDefinition(
    id: 'ex_lat_pulldown',
    name: 'Wide-Grip Lat Pulldown',
    category: 'Back',
    targetMuscle: 'Latissimus Dorsi',
    secondaryMuscle: 'Biceps, Rear Delts',
    equipment: 'Cable Lat Machine',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&q=80',
    defaultSets: 4,
    defaultReps: '10-12',
    defaultRest: '60s',
  ),
  const ExerciseDefinition(
    id: 'ex_seated_cable_row',
    name: 'Seated Cable Row',
    category: 'Back',
    targetMuscle: 'Rhomboids & Mid-Back',
    secondaryMuscle: 'Lats, Biceps',
    equipment: 'Low Cable Pulley',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '60s',
  ),
  const ExerciseDefinition(
    id: 'ex_db_single_row',
    name: 'Single-Arm Dumbbell Row',
    category: 'Back',
    targetMuscle: 'Latissimus Dorsi',
    secondaryMuscle: 'Posterior Deltoids',
    equipment: 'Dumbbell & Bench',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '60s',
  ),

  // Legs
  const ExerciseDefinition(
    id: 'ex_back_squat',
    name: 'Barbell Back Squat',
    category: 'Legs',
    targetMuscle: 'Quadriceps & Glutes',
    secondaryMuscle: 'Hamstrings, Core',
    equipment: 'Squat Rack & Barbell',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&q=80',
    defaultSets: 4,
    defaultReps: '8-10',
    defaultRest: '90s',
  ),
  const ExerciseDefinition(
    id: 'ex_romanian_deadlift',
    name: 'Romanian Deadlift (RDL)',
    category: 'Legs',
    targetMuscle: 'Hamstrings & Gluteus Max',
    secondaryMuscle: 'Lower Back, Forearms',
    equipment: 'Barbell or Dumbbells',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '75s',
  ),
  const ExerciseDefinition(
    id: 'ex_bulgarian_split_squat',
    name: 'Bulgarian Split Squat',
    category: 'Legs',
    targetMuscle: 'Quads & Glute Medius',
    secondaryMuscle: 'Calves, Core Balance',
    equipment: 'Dumbbells & Bench',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1434682881908-b43d0467b798?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10 per leg',
    defaultRest: '60s',
  ),
  const ExerciseDefinition(
    id: 'ex_calf_raise',
    name: 'Standing Calf Raise',
    category: 'Legs',
    targetMuscle: 'Gastrocnemius & Soleus',
    secondaryMuscle: 'Achilles Tendon',
    equipment: 'Calf Raise Machine / Step',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&q=80',
    defaultSets: 4,
    defaultReps: '15-20',
    defaultRest: '45s',
  ),

  // Shoulders
  const ExerciseDefinition(
    id: 'ex_overhead_press',
    name: 'Standing Overhead Press',
    category: 'Shoulders',
    targetMuscle: 'Anterior & Lateral Delts',
    secondaryMuscle: 'Upper Chest, Triceps',
    equipment: 'Barbell',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&q=80',
    defaultSets: 4,
    defaultReps: '6-8',
    defaultRest: '90s',
  ),
  const ExerciseDefinition(
    id: 'ex_lateral_raise',
    name: 'Dumbbell Lateral Raise',
    category: 'Shoulders',
    targetMuscle: 'Lateral Deltoid (Cap)',
    secondaryMuscle: 'Trapezius',
    equipment: 'Dumbbells',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&q=80',
    defaultSets: 4,
    defaultReps: '12-15',
    defaultRest: '45s',
  ),
  const ExerciseDefinition(
    id: 'ex_face_pull',
    name: 'Cable Face Pull with External Rotation',
    category: 'Shoulders',
    targetMuscle: 'Posterior Delts & Rotators',
    secondaryMuscle: 'Rhomboids, Mid-Traps',
    equipment: 'Rope Attachment & Cable',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=400&q=80',
    defaultSets: 3,
    defaultReps: '15-18',
    defaultRest: '45s',
  ),

  // Arms
  const ExerciseDefinition(
    id: 'ex_bicep_curl',
    name: 'EZ-Bar Bicep Curl',
    category: 'Arms',
    targetMuscle: 'Biceps Brachii',
    secondaryMuscle: 'Brachialis, Forearms',
    equipment: 'EZ-Curl Bar',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '60s',
  ),
  const ExerciseDefinition(
    id: 'ex_tricep_pushdown',
    name: 'Rope Tricep Pushdown',
    category: 'Arms',
    targetMuscle: 'Triceps (Lateral Head)',
    secondaryMuscle: 'Anconeus',
    equipment: 'Cable Pulley & Rope',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&q=80',
    defaultSets: 3,
    defaultReps: '12-15',
    defaultRest: '45s',
  ),
  const ExerciseDefinition(
    id: 'ex_hammer_curl',
    name: 'Dumbbell Hammer Curl',
    category: 'Arms',
    targetMuscle: 'Brachialis & Brachioradialis',
    secondaryMuscle: 'Biceps Peak',
    equipment: 'Dumbbells',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1521804906057-1df8fdb718b7?w=400&q=80',
    defaultSets: 3,
    defaultReps: '10-12',
    defaultRest: '45s',
  ),

  // Core
  const ExerciseDefinition(
    id: 'ex_hanging_leg_raise',
    name: 'Hanging Leg / Knee Raise',
    category: 'Core',
    targetMuscle: 'Lower Rectus Abdominis',
    secondaryMuscle: 'Hip Flexors, Grip',
    equipment: 'Pull-up Bar',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&q=80',
    defaultSets: 3,
    defaultReps: '12-15',
    defaultRest: '45s',
  ),
  const ExerciseDefinition(
    id: 'ex_plank',
    name: 'RKC Tension Plank',
    category: 'Core',
    targetMuscle: 'Transverse Abdominis',
    secondaryMuscle: 'Glutes, Shoulders',
    equipment: 'Exercise Mat',
    difficulty: 'Beginner',
    imageUrl:
        'https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?w=400&q=80',
    defaultSets: 3,
    defaultReps: '45-60s hold',
    defaultRest: '45s',
  ),

  // Cardio / Conditioning
  const ExerciseDefinition(
    id: 'ex_kettlebell_swing',
    name: 'Kettlebell Russian Swings',
    category: 'Cardio',
    targetMuscle: 'Hips & Posterior Power',
    secondaryMuscle: 'Cardio Endurance, Core',
    equipment: 'Competition Kettlebell',
    difficulty: 'Intermediate',
    imageUrl:
        'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&q=80',
    defaultSets: 4,
    defaultReps: '20 swings',
    defaultRest: '45s',
  ),
  const ExerciseDefinition(
    id: 'ex_assault_bike',
    name: 'Air Bike High-Intensity Intervals',
    category: 'Cardio',
    targetMuscle: 'Cardiovascular Capacity',
    secondaryMuscle: 'Full Body Aerobic',
    equipment: 'Assault / Echo Bike',
    difficulty: 'Advanced',
    imageUrl:
        'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=400&q=80',
    defaultSets: 5,
    defaultReps: '20s sprint / 40s rest',
    defaultRest: '40s',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// AssignWorkoutPlanScreen
// ─────────────────────────────────────────────────────────────────────────────

class AssignWorkoutPlanScreen extends StatefulWidget {
  final String clientName;
  final String? clientAvatar;
  final String currentPlanTitle;
  final ValueChanged<String>? onPlanSaved;

  const AssignWorkoutPlanScreen({
    super.key,
    this.clientName = 'Sarah Jenkins',
    this.clientAvatar,
    this.currentPlanTitle = '12-Week Hypertrophy Protocol',
    this.onPlanSaved,
  });

  @override
  State<AssignWorkoutPlanScreen> createState() =>
      _AssignWorkoutPlanScreenState();
}

class _AssignWorkoutPlanScreenState extends State<AssignWorkoutPlanScreen> {
  late TextEditingController _planTitleController;
  int _selectedDayIndex = 0;
  String _selectedProgramDuration = '12 Weeks';

  // 7-day schedule pre-loaded with athletic defaults
  late List<DaySchedule> _weekSchedule;

  @override
  void initState() {
    super.initState();
    _planTitleController =
        TextEditingController(text: widget.currentPlanTitle);

    _weekSchedule = [
      DaySchedule(
        dayName: 'Monday',
        shortName: 'Mon',
        focusTitle: 'Chest & Triceps Hypertrophy',
        isRestDay: false,
        exercises: [
          AssignedExercise(
            id: 'ae_1',
            exercise: kExerciseLibrary.firstWhere((e) => e.id == 'ex_bench_press'),
            sets: 4,
            reps: '8-10',
            rest: '90s',
          ),
          AssignedExercise(
            id: 'ae_2',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_incline_db_press'),
            sets: 3,
            reps: '10-12',
            rest: '60s',
          ),
          AssignedExercise(
            id: 'ae_3',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_tricep_pushdown'),
            sets: 3,
            reps: '12-15',
            rest: '45s',
          ),
        ],
      ),
      DaySchedule(
        dayName: 'Tuesday',
        shortName: 'Tue',
        focusTitle: 'Back & Biceps Power',
        isRestDay: false,
        exercises: [
          AssignedExercise(
            id: 'ae_4',
            exercise: kExerciseLibrary.firstWhere((e) => e.id == 'ex_deadlift'),
            sets: 4,
            reps: '5-6',
            rest: '120s',
          ),
          AssignedExercise(
            id: 'ae_5',
            exercise: kExerciseLibrary.firstWhere((e) => e.id == 'ex_lat_pulldown'),
            sets: 4,
            reps: '10-12',
            rest: '60s',
          ),
          AssignedExercise(
            id: 'ae_6',
            exercise: kExerciseLibrary.firstWhere((e) => e.id == 'ex_bicep_curl'),
            sets: 3,
            reps: '10-12',
            rest: '60s',
          ),
        ],
      ),
      DaySchedule(
        dayName: 'Wednesday',
        shortName: 'Wed',
        focusTitle: 'Active Recovery & Mobility',
        isRestDay: true,
        exercises: [],
      ),
      DaySchedule(
        dayName: 'Thursday',
        shortName: 'Thu',
        focusTitle: 'Lower Body Quad & Posterior',
        isRestDay: false,
        exercises: [
          AssignedExercise(
            id: 'ae_7',
            exercise: kExerciseLibrary.firstWhere((e) => e.id == 'ex_back_squat'),
            sets: 4,
            reps: '8-10',
            rest: '90s',
          ),
          AssignedExercise(
            id: 'ae_8',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_romanian_deadlift'),
            sets: 3,
            reps: '10-12',
            rest: '75s',
          ),
          AssignedExercise(
            id: 'ae_9',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_calf_raise'),
            sets: 4,
            reps: '15-20',
            rest: '45s',
          ),
        ],
      ),
      DaySchedule(
        dayName: 'Friday',
        shortName: 'Fri',
        focusTitle: 'Shoulders & Core Stability',
        isRestDay: false,
        exercises: [
          AssignedExercise(
            id: 'ae_10',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_overhead_press'),
            sets: 4,
            reps: '6-8',
            rest: '90s',
          ),
          AssignedExercise(
            id: 'ae_11',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_lateral_raise'),
            sets: 4,
            reps: '12-15',
            rest: '45s',
          ),
          AssignedExercise(
            id: 'ae_12',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_hanging_leg_raise'),
            sets: 3,
            reps: '12-15',
            rest: '45s',
          ),
        ],
      ),
      DaySchedule(
        dayName: 'Saturday',
        shortName: 'Sat',
        focusTitle: 'Conditioning & HIIT Aerobics',
        isRestDay: false,
        exercises: [
          AssignedExercise(
            id: 'ae_13',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_kettlebell_swing'),
            sets: 4,
            reps: '20 swings',
            rest: '45s',
          ),
          AssignedExercise(
            id: 'ae_14',
            exercise:
                kExerciseLibrary.firstWhere((e) => e.id == 'ex_assault_bike'),
            sets: 5,
            reps: '20s/40s intervals',
            rest: '40s',
          ),
        ],
      ),
      DaySchedule(
        dayName: 'Sunday',
        shortName: 'Sun',
        focusTitle: 'Full Rest & Parasympathetic Reset',
        isRestDay: true,
        exercises: [],
      ),
    ];
  }

  @override
  void dispose() {
    _planTitleController.dispose();
    super.dispose();
  }

  // ── Metrics ────────────────────────────────────────────────────────────────
  int get _totalTrainingDays =>
      _weekSchedule.where((d) => !d.isRestDay).length;

  int get _totalRestDays => _weekSchedule.where((d) => d.isRestDay).length;

  int get _totalExercises {
    int count = 0;
    for (var day in _weekSchedule) {
      if (!day.isRestDay) count += day.exercises.length;
    }
    return count;
  }

  DaySchedule get _currentDay => _weekSchedule[_selectedDayIndex];

  // ── Handlers ────────────────────────────────────────────────────────────────

  void _openAddExerciseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ExerciseLibraryPicker(
        onExerciseSelected: (selectedEx) {
          setState(() {
            _currentDay.exercises.add(
              AssignedExercise(
                id: 'ae_${DateTime.now().millisecondsSinceEpoch}',
                exercise: selectedEx,
                sets: selectedEx.defaultSets,
                reps: selectedEx.defaultReps,
                rest: selectedEx.defaultRest,
              ),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${selectedEx.name} to ${_currentDay.dayName}!'),
              backgroundColor: AppTheme.accentGreen,
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  void _saveAndAssignPlan() {
    final title = _planTitleController.text.trim().isEmpty
        ? 'Custom Training Split'
        : _planTitleController.text.trim();

    widget.onPlanSaved?.call(title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentGreen.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppTheme.accentGreen, size: 36),
            ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            Text(
              'Workout Plan Assigned!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$title" has been successfully synced to ${widget.clientName}\'s profile with $_totalTrainingDays training days.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context, true); // Pop back with success
                },
                child: Text(
                  'Back to Client Details',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.backgroundDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign Workout Plan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              'Building plan for ${widget.clientName}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.accentGreen,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                widget.clientAvatar ?? 'https://i.pravatar.cc/150?img=47',
              ),
              backgroundColor: AppTheme.surfaceLighter,
              onBackgroundImageError: (_, _) {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Plan Overview Card (Title & Duration)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: _buildPlanHeaderCard(),
            ),

            // 2. 7-Day Selector Row (Mon - Sun)
            _build7DaySelector(),
            const SizedBox(height: 12),

            // 3. Active Day Workout Detail Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildActiveDayView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Plan Overview Header Card ───────────────────────────────────────────────
  Widget _buildPlanHeaderCard() {
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
            children: [
              Expanded(
                child: TextField(
                  controller: _planTitleController,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'e.g., 12-Week Hypertrophy Protocol',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Icon(Icons.edit_rounded,
                  size: 16, color: AppTheme.accentGreen),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_totalTrainingDays Training Days • $_totalRestDays Rest Days',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              // Duration dropdown/pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProgramDuration,
                    dropdownColor: AppTheme.surfaceDark,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: AppTheme.textSecondary, size: 18),
                    items: ['4 Weeks', '8 Weeks', '12 Weeks', '16 Weeks']
                        .map(
                          (val) => DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedProgramDuration = v);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 7-Day Horizontal Selector ───────────────────────────────────────────────
  Widget _build7DaySelector() {
    return SizedBox(
      height: 62,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _weekSchedule.length,
        itemBuilder: (_, i) {
          final day = _weekSchedule[i];
          final isSelected = _selectedDayIndex == i;

          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentGreen
                    : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.accentGreen
                      : AppTheme.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.shortName,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.backgroundDark
                          : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  day.isRestDay
                      ? Icon(
                          Icons.nightlife_rounded,
                          size: 12,
                          color: isSelected
                              ? AppTheme.backgroundDark
                              : AppTheme.accentOrange,
                        )
                      : Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.backgroundDark
                                : AppTheme.accentGreen,
                            shape: BoxShape.circle,
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

  // ── Active Day View (Exercises or Rest Day Banner) ───────────────────────────
  Widget _buildActiveDayView() {
    final day = _currentDay;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: [
          // Day Header & Rest Day Toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.dayName} Workout',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        day.isRestDay
                            ? 'Marked as Rest & Recovery'
                            : '${day.exercises.length} Exercises • ~${day.exercises.length * 12} min duration',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: day.isRestDay
                              ? AppTheme.accentOrange
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rest Day Toggle
                Row(
                  children: [
                    Text(
                      'Rest Day',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: day.isRestDay
                            ? AppTheme.accentOrange
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Switch.adaptive(
                      value: day.isRestDay,
                      activeTrackColor: AppTheme.accentOrange.withValues(alpha: 0.5),
                      activeThumbColor: AppTheme.accentOrange,
                      onChanged: (val) {
                        setState(() {
                          day.isRestDay = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.surfaceBorder),

          // Body: Rest Day Notice or Reorderable Exercise List
          Expanded(
            child: day.isRestDay
                ? _buildRestDayPlaceholder(day)
                : _buildExerciseList(day),
          ),
        ],
      ),
    );
  }

  // ── Rest Day Banner ─────────────────────────────────────────────────────────
  Widget _buildRestDayPlaceholder(DaySchedule day) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentOrange.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.spa_rounded,
                size: 34,
                color: AppTheme.accentOrange,
              ),
            ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              'Scheduled Recovery Day',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Muscles grow during rest! Recommended focus on 8+ hours of sleep, light mobility foam rolling, and target protein synthesis.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.surfaceBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() => day.isRestDay = false);
              },
              icon: const Icon(Icons.fitness_center_rounded,
                  size: 15, color: AppTheme.accentGreen),
              label: Text(
                'Convert to Workout Day',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reorderable Exercise List & Add Button ───────────────────────────────────
  Widget _buildExerciseList(DaySchedule day) {
    return Column(
      children: [
        // Add Exercise CTA Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Drag handle to reorder exercise sequence:',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: _openAddExerciseModal,
                icon: const Icon(Icons.add,
                    size: 16, color: AppTheme.backgroundDark),
                label: Text(
                  'Add Exercise',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.backgroundDark,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Exercises List
        Expanded(
          child: day.exercises.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.fitness_center_rounded,
                          size: 32, color: AppTheme.textSecondary),
                      const SizedBox(height: 10),
                      Text(
                        'No exercises added for ${day.dayName}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Exercise" to select from the exercise library.',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                  itemCount: day.exercises.length,
                  // ignore: deprecated_member_use
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = day.exercises.removeAt(oldIndex);
                      day.exercises.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (ctx, idx) {
                    final item = day.exercises[idx];
                    return _AssignedExerciseRowCard(
                      key: ValueKey(item.id),
                      assigned: item,
                      index: idx,
                      onDelete: () {
                        setState(() {
                          day.exercises.removeAt(idx);
                        });
                      },
                      onChanged: () => setState(() {}),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Bottom Summary & CTA Bar ────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Plan Summary',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '$_totalTrainingDays Days • $_totalExercises Exercises',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: _saveAndAssignPlan,
              icon: const Icon(Icons.check_circle_rounded,
                  color: AppTheme.backgroundDark, size: 20),
              label: Text(
                'Save & Assign Plan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.backgroundDark,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reorderable Exercise Row Card with Quick-Edit Fields
// ─────────────────────────────────────────────────────────────────────────────

class _AssignedExerciseRowCard extends StatelessWidget {
  final AssignedExercise assigned;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _AssignedExerciseRowCard({
    super.key,
    required this.assigned,
    required this.index,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ex = assigned.exercise;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Reorder drag handle
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.drag_indicator_rounded,
                      color: AppTheme.textSecondary, size: 22),
                ),
              ),
              const SizedBox(width: 8),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ex.imageUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 52,
                    height: 52,
                    color: AppTheme.surfaceDark,
                    child: const Icon(Icons.fitness_center,
                        color: AppTheme.textSecondary, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name + Target Muscle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ex.targetMuscle} • ${ex.equipment}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 18, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Remove exercise',
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: AppTheme.surfaceBorder),
          const SizedBox(height: 10),

          // Quick-Edit fields: Sets, Reps, Rest
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Sets stepper
              _stepperInput(
                label: 'Sets',
                value: '${assigned.sets}',
                onMinus: () {
                  if (assigned.sets > 1) {
                    assigned.sets--;
                    onChanged();
                  }
                },
                onPlus: () {
                  if (assigned.sets < 10) {
                    assigned.sets++;
                    onChanged();
                  }
                },
              ),

              _divider(),

              // Reps dropdown/picker
              _pillSelector(
                context: context,
                title: 'Reps',
                currentValue: assigned.reps,
                options: ['6-8', '8-10', '10-12', '12-15', '15-20', 'To Failure'],
                onSelected: (val) {
                  assigned.reps = val;
                  onChanged();
                },
              ),

              _divider(),

              // Rest time selector
              _pillSelector(
                context: context,
                title: 'Rest',
                currentValue: assigned.rest,
                options: ['30s', '45s', '60s', '90s', '120s', '3 min'],
                onSelected: (val) {
                  assigned.rest = val;
                  onChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepperInput({
    required String label,
    required String value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            GestureDetector(
              onTap: onMinus,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.remove,
                    size: 14, color: AppTheme.textDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            GestureDetector(
              onTap: onPlus,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child:
                    const Icon(Icons.add, size: 14, color: AppTheme.textDark),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pillSelector({
    required BuildContext context,
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppTheme.surfaceDark,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select $title',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSel = opt == currentValue;
                    return GestureDetector(
                      onTap: () {
                        onSelected(opt);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppTheme.accentGreen
                              : AppTheme.surfaceLighter,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel
                                ? AppTheme.accentGreen
                                : AppTheme.surfaceBorder,
                          ),
                        ),
                        child: Text(
                          opt,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel
                                ? AppTheme.backgroundDark
                                : AppTheme.textDark,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Text(
                  currentValue,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down,
                    size: 14, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      color: AppTheme.surfaceBorder,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Exercise Library Modal Picker (Search + Category Filter)
// ─────────────────────────────────────────────────────────────────────────────

class _ExerciseLibraryPicker extends StatefulWidget {
  final ValueChanged<ExerciseDefinition> onExerciseSelected;

  const _ExerciseLibraryPicker({required this.onExerciseSelected});

  @override
  State<_ExerciseLibraryPicker> createState() => _ExerciseLibraryPickerState();
}

class _ExerciseLibraryPickerState extends State<_ExerciseLibraryPicker> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Cardio',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExerciseDefinition> get _filteredExercises {
    final query = _searchController.text.trim().toLowerCase();
    return kExerciseLibrary.where((e) {
      final matchesCat =
          _selectedCategory == 'All' || e.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          e.name.toLowerCase().contains(query) ||
          e.targetMuscle.toLowerCase().contains(query) ||
          e.equipment.toLowerCase().contains(query);
      return matchesCat && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredExercises;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercise Library',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    '${kExerciseLibrary.length} Exercises',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.manrope(
                      color: AppTheme.textDark, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search by exercise name, muscle, equipment...',
                    hintStyle: GoogleFonts.manrope(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppTheme.textSecondary, size: 18),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 16, color: AppTheme.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Category horizontal filter chips
              SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    final isSel = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppTheme.accentGreen
                              : AppTheme.surfaceLighter,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel
                                ? AppTheme.accentGreen
                                : AppTheme.surfaceBorder,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel
                                ? AppTheme.backgroundDark
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Exercise List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No exercises found matching "${_searchController.text}"',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (ctx, idx) {
                          final ex = filtered[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLighter,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppTheme.surfaceBorder, width: 1),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    ex.imageUrl,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 64,
                                      height: 64,
                                      color: AppTheme.surfaceDark,
                                      child: const Icon(
                                        Icons.fitness_center,
                                        color: AppTheme.textSecondary,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title + Muscle Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${ex.targetMuscle} • ${ex.equipment}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentGreen
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${ex.defaultSets} sets • ${ex.defaultReps}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.accentGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Add Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accentGreen,
                                    foregroundColor: AppTheme.backgroundDark,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    widget.onExerciseSelected(ex);
                                    Navigator.pop(ctx);
                                  },
                                  child: Text(
                                    '+ Add',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.backgroundDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
