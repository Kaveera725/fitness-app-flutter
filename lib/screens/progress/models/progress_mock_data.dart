import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'progress_models.dart';

class ProgressMockData {
  static final Map<TimeRange, TimeRangeWeightData> weightDataByRange = {
    TimeRange.week: const TimeRangeWeightData(
      range: TimeRange.week,
      startWeight: 74.6,
      currentWeight: 73.8,
      goalWeight: 72.0,
      minY: 72.5,
      maxY: 75.5,
      horizontalInterval: 1.0,
      points: [
        WeightPoint(x: 0, weight: 74.6, label: 'Mon', date: 'Sep 17', note: 'Post-weekend weigh-in'),
        WeightPoint(x: 1, weight: 74.4, label: 'Tue', date: 'Sep 18', note: 'Morning fasting'),
        WeightPoint(x: 2, weight: 74.7, label: 'Wed', date: 'Sep 19', note: 'High carb refeed day'),
        WeightPoint(x: 3, weight: 74.2, label: 'Thu', date: 'Sep 20', note: 'Post-HIIT hydration flush'),
        WeightPoint(x: 4, weight: 74.0, label: 'Fri', date: 'Sep 21', note: 'Steady deficit'),
        WeightPoint(x: 5, weight: 74.1, label: 'Sat', date: 'Sep 22', note: 'Pre-workout weigh-in'),
        WeightPoint(x: 6, weight: 73.8, label: 'Sun', date: 'Sep 23', note: 'Weekly lowest weight! 🎉'),
      ],
    ),
    TimeRange.month: const TimeRangeWeightData(
      range: TimeRange.month,
      startWeight: 75.8,
      currentWeight: 73.8,
      goalWeight: 72.0,
      minY: 73.0,
      maxY: 76.5,
      horizontalInterval: 1.0,
      points: [
        WeightPoint(x: 0, weight: 75.8, label: 'Sep 1', date: 'Sep 01', note: 'Month opening baseline'),
        WeightPoint(x: 1, weight: 75.5, label: 'Sep 5', date: 'Sep 05'),
        WeightPoint(x: 2, weight: 75.7, label: 'Sep 10', date: 'Sep 10', note: 'Slight fluctuation'),
        WeightPoint(x: 3, weight: 75.1, label: 'Sep 14', date: 'Sep 14'),
        WeightPoint(x: 4, weight: 74.9, label: 'Sep 18', date: 'Sep 18'),
        WeightPoint(x: 5, weight: 74.5, label: 'Sep 22', date: 'Sep 22'),
        WeightPoint(x: 6, weight: 74.2, label: 'Sep 26', date: 'Sep 26'),
        WeightPoint(x: 7, weight: 73.8, label: 'Sep 30', date: 'Sep 30', note: 'Goal trajectory on track'),
      ],
    ),
    TimeRange.threeMonths: const TimeRangeWeightData(
      range: TimeRange.threeMonths,
      startWeight: 77.4,
      currentWeight: 73.8,
      goalWeight: 72.0,
      minY: 72.0,
      maxY: 78.5,
      horizontalInterval: 1.5,
      points: [
        WeightPoint(x: 0, weight: 77.4, label: 'W1', date: 'Jul 05', note: 'Start of 12-week cut'),
        WeightPoint(x: 1, weight: 77.0, label: 'W2', date: 'Jul 12'),
        WeightPoint(x: 2, weight: 76.6, label: 'W3', date: 'Jul 19'),
        WeightPoint(x: 3, weight: 76.9, label: 'W4', date: 'Jul 26', note: 'Vacation weekend blip'),
        WeightPoint(x: 4, weight: 76.3, label: 'W5', date: 'Aug 02'),
        WeightPoint(x: 5, weight: 75.8, label: 'W6', date: 'Aug 09', note: 'Halfway milestone reached'),
        WeightPoint(x: 6, weight: 75.9, label: 'W7', date: 'Aug 16'),
        WeightPoint(x: 7, weight: 75.2, label: 'W8', date: 'Aug 23'),
        WeightPoint(x: 8, weight: 74.8, label: 'W9', date: 'Aug 30'),
        WeightPoint(x: 9, weight: 74.4, label: 'W10', date: 'Sep 06'),
        WeightPoint(x: 10, weight: 74.1, label: 'W11', date: 'Sep 13'),
        WeightPoint(x: 11, weight: 73.8, label: 'W12', date: 'Sep 20', note: 'Consistent fat loss!'),
      ],
    ),
    TimeRange.year: const TimeRangeWeightData(
      range: TimeRange.year,
      startWeight: 81.2,
      currentWeight: 73.8,
      goalWeight: 72.0,
      minY: 71.0,
      maxY: 82.5,
      horizontalInterval: 2.5,
      points: [
        WeightPoint(x: 0, weight: 81.2, label: 'Jan', date: 'Jan 15', note: 'New year fitness journey start'),
        WeightPoint(x: 1, weight: 80.3, label: 'Feb', date: 'Feb 15'),
        WeightPoint(x: 2, weight: 79.5, label: 'Mar', date: 'Mar 15'),
        WeightPoint(x: 3, weight: 79.8, label: 'Apr', date: 'Apr 15', note: 'Muscle building phase'),
        WeightPoint(x: 4, weight: 78.6, label: 'May', date: 'May 15'),
        WeightPoint(x: 5, weight: 77.4, label: 'Jun', date: 'Jun 15'),
        WeightPoint(x: 6, weight: 76.2, label: 'Jul', date: 'Jul 15'),
        WeightPoint(x: 7, weight: 75.0, label: 'Aug', date: 'Aug 15'),
        WeightPoint(x: 8, weight: 73.8, label: 'Sep', date: 'Sep 15', note: '-7.4 kg total transformation'),
      ],
    ),
  };

  static List<BodyMeasurement> get initialMeasurements => [
    BodyMeasurement(
      id: 'chest',
      name: 'Chest',
      currentValue: 102.5,
      previousValue: 104.0,
      unit: 'cm',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.accessibility_new_rounded,
      accentColor: AppTheme.accentOrange,
    ),
    BodyMeasurement(
      id: 'waist',
      name: 'Waist',
      currentValue: 81.2,
      previousValue: 83.0,
      unit: 'cm',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.airline_seat_legroom_reduced_rounded,
      accentColor: AppTheme.primary,
    ),
    BodyMeasurement(
      id: 'arms',
      name: 'Arms',
      currentValue: 37.5,
      previousValue: 36.8,
      unit: 'cm',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.fitness_center_rounded,
      accentColor: AppTheme.accentPurple,
    ),
    BodyMeasurement(
      id: 'legs',
      name: 'Legs',
      currentValue: 58.6,
      previousValue: 57.8,
      unit: 'cm',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.directions_run_rounded,
      accentColor: const Color(0xFF00E5FF),
    ),
  ];

  static List<ProgressPhoto> get initialPhotos => [
    ProgressPhoto(
      id: 'photo_1',
      caption: 'Starting Point',
      date: DateTime.now().subtract(const Duration(days: 75)),
      weight: 77.4,
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400&q=80',
      note: 'Week 1 baseline. Target: lean definition and athletic mobility.',
    ),
    ProgressPhoto(
      id: 'photo_2',
      caption: 'Month 1 Check-in',
      date: DateTime.now().subtract(const Duration(days: 48)),
      weight: 75.8,
      imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&q=80',
      note: 'Noticeable core tightening and improved back shoulder posture.',
    ),
    ProgressPhoto(
      id: 'photo_3',
      caption: 'Week 8 Definition',
      date: DateTime.now().subtract(const Duration(days: 22)),
      weight: 74.5,
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&q=80',
      note: 'Upper chest and deltoid separation showing under lighting.',
    ),
    ProgressPhoto(
      id: 'photo_4',
      caption: 'Current Form',
      date: DateTime.now().subtract(const Duration(days: 1)),
      weight: 73.8,
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&q=80',
      note: 'Best vascularity yet! Waist trimmed 1.8 cm down.',
    ),
  ];

  static List<WorkoutCalendarDay> getSeptemberCalendar() {
    final now = DateTime.now();
    final todayDay = now.day.clamp(1, 30);

    // Realistic workout schedule with rest days and variable intensities
    final workoutSchedule = <int, Map<String, dynamic>?>{
      1: {'title': 'Full Body Strength', 'dur': 55, 'cal': 480, 'int': 3},
      2: {'title': 'HIIT Cardio Blast', 'dur': 35, 'cal': 390, 'int': 2},
      3: null, // Rest day
      4: {'title': 'Upper Body Push', 'dur': 50, 'cal': 440, 'int': 3},
      5: {'title': 'Legs & Core Burner', 'dur': 60, 'cal': 520, 'int': 3},
      6: {'title': 'Active Recovery Mobility', 'dur': 30, 'cal': 180, 'int': 1},
      7: null, // Rest
      8: {'title': 'Back & Biceps Power', 'dur': 50, 'cal': 460, 'int': 3},
      9: {'title': 'Zone 2 Running & Core', 'dur': 45, 'cal': 410, 'int': 2},
      10: {'title': 'Chest & Triceps Hypertrophy', 'dur': 55, 'cal': 475, 'int': 3},
      11: null, // Rest
      12: {'title': 'Lower Body Strength', 'dur': 65, 'cal': 540, 'int': 3},
      13: {'title': 'HIIT Tabata Circuits', 'dur': 40, 'cal': 420, 'int': 3},
      14: {'title': 'Yoga & Deep Stretch', 'dur': 30, 'cal': 160, 'int': 1},
      15: null, // Rest
      16: {'title': 'Shoulders & Arms Pump', 'dur': 48, 'cal': 430, 'int': 2},
      17: {'title': 'Deadlift & Posterior Chain', 'dur': 58, 'cal': 510, 'int': 3},
      18: {'title': 'Conditioning & Sprints', 'dur': 35, 'cal': 380, 'int': 3},
      19: null, // Rest
      20: {'title': 'Chest & Core Focus', 'dur': 52, 'cal': 470, 'int': 3},
      21: {'title': 'Leg Day Hypertrophy', 'dur': 60, 'cal': 530, 'int': 3},
      22: {'title': 'Active Walk & Foam Roll', 'dur': 35, 'cal': 210, 'int': 1},
      23: {'title': 'Pull Day + Calves', 'dur': 50, 'cal': 450, 'int': 2},
      24: {'title': 'Morning HIIT Burn', 'dur': 30, 'cal': 360, 'int': 2},
      25: null, // Scheduled Rest
      26: {'title': 'Upper Body Power', 'dur': 55, 'cal': 490, 'int': 3},
      27: {'title': 'Legs & Glutes Focus', 'dur': 60, 'cal': 525, 'int': 3},
      28: {'title': 'Recovery & Core', 'dur': 30, 'cal': 175, 'int': 1},
      29: {'title': 'Full Body MetCon', 'dur': 45, 'cal': 460, 'int': 3},
      30: {'title': 'Monthly Benchmark Test', 'dur': 60, 'cal': 550, 'int': 3},
    };

    return List.generate(30, (index) {
      final dayNum = index + 1;
      final schedule = workoutSchedule[dayNum];
      final isPastOrToday = dayNum <= todayDay;
      final hasCompleted = isPastOrToday && schedule != null;

      return WorkoutCalendarDay(
        day: dayNum,
        date: DateTime(now.year, now.month, dayNum),
        isCompleted: hasCompleted,
        isToday: dayNum == todayDay,
        intensity: (schedule?['int'] as int?) ?? 1,
        workoutTitle: schedule?['title'] as String?,
        durationMinutes: schedule?['dur'] as int?,
        caloriesBurned: schedule?['cal'] as int?,
      );
    });
  }

  static List<AchievementBadge> get allAchievements => [
    AchievementBadge(
      id: 'streak_7',
      title: '7-Day Streak',
      description: 'Worked out consistently for 7 consecutive active days.',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.accentOrange,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 3)),
      progress: 1.0,
      progressLabel: '7 / 7 Days',
      category: 'Streaks',
    ),
    AchievementBadge(
      id: 'workouts_100',
      title: 'Century Club',
      description: 'Completed 100 total workouts across all programs.',
      icon: Icons.fitness_center_rounded,
      color: AppTheme.primary,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 12)),
      progress: 1.0,
      progressLabel: '100 / 100 Workouts',
      category: 'Workouts',
    ),
    AchievementBadge(
      id: 'weight_goal',
      title: 'Goal Crusher',
      description: 'Dropped below 74 kg milestone towards final target.',
      icon: Icons.emoji_events_rounded,
      color: AppTheme.accentGreen,
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 1)),
      progress: 1.0,
      progressLabel: '73.8 / 74.0 kg',
      category: 'Body',
    ),
    AchievementBadge(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Completed 10 workouts before 8:00 AM.',
      icon: Icons.wb_sunny_rounded,
      color: const Color(0xFFFFD600),
      isUnlocked: true,
      unlockedDate: DateTime.now().subtract(const Duration(days: 18)),
      progress: 1.0,
      progressLabel: '10 / 10 Sessions',
      category: 'Streaks',
    ),
    AchievementBadge(
      id: 'streak_30',
      title: 'Iron Consistency',
      description: 'Maintain a 30-day active workout streak.',
      icon: Icons.bolt_rounded,
      color: AppTheme.accentPurple,
      isUnlocked: false,
      progress: 0.60,
      progressLabel: '18 / 30 Days',
      category: 'Streaks',
    ),
    AchievementBadge(
      id: 'heavy_lifter',
      title: 'Titan Strength',
      description: 'Log a personal record lift on Bench, Squat, or Deadlift.',
      icon: Icons.military_tech_rounded,
      color: const Color(0xFFFF5252),
      isUnlocked: false,
      progress: 0.85,
      progressLabel: '135 / 150 kg',
      category: 'Workouts',
    ),
    AchievementBadge(
      id: 'calorie_burner',
      title: 'Furnace Mode',
      description: 'Burn 10,000 total active calories in a single month.',
      icon: Icons.whatshot_rounded,
      color: AppTheme.accentOrange,
      isUnlocked: false,
      progress: 0.78,
      progressLabel: '7,840 / 10,000 kcal',
      category: 'Milestones',
    ),
    AchievementBadge(
      id: 'master_flexibility',
      title: 'Zen Mobility',
      description: 'Complete 15 mobility or recovery sessions.',
      icon: Icons.self_improvement_rounded,
      color: const Color(0xFF00E5FF),
      isUnlocked: false,
      progress: 0.53,
      progressLabel: '8 / 15 Sessions',
      category: 'Milestones',
    ),
  ];

  static List<AchievementBadge> get recentAchievements =>
      allAchievements.where((a) => a.isUnlocked).take(4).toList();
}
