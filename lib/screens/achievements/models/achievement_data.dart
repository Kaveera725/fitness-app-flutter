import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'achievement_model.dart';

class AchievementData {
  static final List<AchievementItem> all = [
    // ─── EARNED ACHIEVEMENTS ─────────────────────────────────────
    AchievementItem(
      id: 'first_workout',
      title: 'First Step',
      description: 'Completed your very first workout on FitPulse.',
      howToEarn: 'Simply log and finish any workout session to unlock this badge.',
      icon: Icons.bolt_rounded,
      color: AppTheme.primary,
      category: AchievementCategory.workouts,
      rarity: AchievementRarity.common,
      isEarned: true,
      earnedDate: DateTime(2026, 1, 16),
      currentProgress: 1,
      targetProgress: 1,
      progressUnit: 'workout',
      xpReward: 25,
    ),

    AchievementItem(
      id: 'streak_7',
      title: '7-Day Streak',
      description: 'Trained consistently every day for a full week without missing a single session.',
      howToEarn: 'Log at least one workout every day for 7 consecutive days.',
      icon: Icons.local_fire_department_rounded,
      color: AppTheme.accentOrange,
      category: AchievementCategory.streaks,
      rarity: AchievementRarity.rare,
      isEarned: true,
      earnedDate: DateTime(2026, 9, 20),
      currentProgress: 7,
      targetProgress: 7,
      progressUnit: 'days',
      xpReward: 75,
    ),

    AchievementItem(
      id: 'workouts_50',
      title: '50 Workouts Club',
      description: 'Crossed the 50-workout milestone — a real sign of dedication and consistency.',
      howToEarn: 'Complete a cumulative total of 50 workout sessions.',
      icon: Icons.fitness_center_rounded,
      color: AppTheme.primary,
      category: AchievementCategory.workouts,
      rarity: AchievementRarity.rare,
      isEarned: true,
      earnedDate: DateTime(2026, 8, 4),
      currentProgress: 50,
      targetProgress: 50,
      progressUnit: 'workouts',
      xpReward: 100,
    ),

    AchievementItem(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Proved that the early morning belongs to the dedicated — 10 workouts before 8 AM.',
      howToEarn: 'Start and complete 10 workout sessions before 8:00 AM.',
      icon: Icons.wb_sunny_rounded,
      color: const Color(0xFFFFD600),
      category: AchievementCategory.consistency,
      rarity: AchievementRarity.epic,
      isEarned: true,
      earnedDate: DateTime(2026, 8, 20),
      currentProgress: 10,
      targetProgress: 10,
      progressUnit: 'early sessions',
      xpReward: 125,
    ),

    AchievementItem(
      id: 'consistency_king',
      title: 'Consistency King',
      description: 'Achieved an 80%+ monthly workout consistency rate for three months in a row.',
      howToEarn: 'Maintain at least 80% weekly workout rate across 3 consecutive months.',
      icon: Icons.auto_awesome_rounded,
      color: AppTheme.accentPurple,
      category: AchievementCategory.consistency,
      rarity: AchievementRarity.legendary,
      isEarned: true,
      earnedDate: DateTime(2026, 9, 1),
      currentProgress: 3,
      targetProgress: 3,
      progressUnit: 'months',
      xpReward: 250,
    ),

    AchievementItem(
      id: 'pr_lifter',
      title: 'Iron PR',
      description: 'Set a personal record on Bench Press, Squat, or Deadlift — proving pure raw strength.',
      howToEarn: 'Log a PR (Personal Record) lift on any of the three major compound movements.',
      icon: Icons.military_tech_rounded,
      color: const Color(0xFFFF5252),
      category: AchievementCategory.milestones,
      rarity: AchievementRarity.epic,
      isEarned: true,
      earnedDate: DateTime(2026, 7, 12),
      currentProgress: 1,
      targetProgress: 1,
      progressUnit: 'PR',
      xpReward: 150,
    ),

    AchievementItem(
      id: 'goal_weight',
      title: 'Goal Crusher',
      description: 'Hit your target body weight milestone through sustained effort over months of hard work.',
      howToEarn: 'Log a weigh-in that meets or beats your set goal weight.',
      icon: Icons.emoji_events_rounded,
      color: AppTheme.accentGreen,
      category: AchievementCategory.milestones,
      rarity: AchievementRarity.legendary,
      isEarned: true,
      earnedDate: DateTime(2026, 9, 21),
      currentProgress: 1,
      targetProgress: 1,
      progressUnit: 'goal reached',
      xpReward: 300,
    ),

    // ─── LOCKED / IN-PROGRESS ACHIEVEMENTS ───────────────────────
    AchievementItem(
      id: 'workouts_100',
      title: 'Century Club',
      description: 'Complete 100 total workouts. Only the most disciplined athletes make it here.',
      howToEarn: 'Complete a cumulative total of 100 workout sessions.',
      icon: Icons.workspace_premium_rounded,
      color: AppTheme.primary,
      category: AchievementCategory.workouts,
      rarity: AchievementRarity.epic,
      isEarned: false,
      currentProgress: 64,
      targetProgress: 100,
      progressUnit: 'workouts',
      xpReward: 200,
    ),

    AchievementItem(
      id: 'weekend_warrior',
      title: 'Weekend Warrior',
      description: 'Train on Saturday or Sunday for 4 consecutive weekends — no off days for the dedicated.',
      howToEarn: 'Complete at least one workout on each weekend (Sat or Sun) for 4 weeks in a row.',
      icon: Icons.shield_rounded,
      color: const Color(0xFF00E5FF),
      category: AchievementCategory.streaks,
      rarity: AchievementRarity.rare,
      isEarned: false,
      currentProgress: 3,
      targetProgress: 4,
      progressUnit: 'weekends',
      xpReward: 80,
    ),

    AchievementItem(
      id: 'calorie_furnace',
      title: 'Calorie Furnace',
      description: 'Burn 10,000 active workout calories in a single calendar month.',
      howToEarn: 'Accumulate 10,000+ kcal burned through logged workouts in any single month.',
      icon: Icons.whatshot_rounded,
      color: AppTheme.accentOrange,
      category: AchievementCategory.milestones,
      rarity: AchievementRarity.rare,
      isEarned: false,
      currentProgress: 7840,
      targetProgress: 10000,
      progressUnit: 'kcal',
      xpReward: 120,
    ),

    AchievementItem(
      id: 'hydration_master',
      title: 'Hydration Hero',
      description: 'Hit your daily water intake goal for 30 days — because gains start with hydration.',
      howToEarn: 'Log your daily hydration goal (≥2.5L) completed for 30 separate days.',
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF29B6F6),
      category: AchievementCategory.consistency,
      rarity: AchievementRarity.rare,
      isEarned: false,
      currentProgress: 18,
      targetProgress: 30,
      progressUnit: 'days',
      xpReward: 90,
    ),

    AchievementItem(
      id: 'zen_mobility',
      title: 'Zen Mobility',
      description: 'Prioritize recovery and flexibility by completing 15 mobility or yoga sessions.',
      howToEarn: 'Log and finish 15 sessions tagged as Mobility, Yoga, or Recovery.',
      icon: Icons.self_improvement_rounded,
      color: const Color(0xFFAB47BC),
      category: AchievementCategory.consistency,
      rarity: AchievementRarity.common,
      isEarned: false,
      currentProgress: 8,
      targetProgress: 15,
      progressUnit: 'sessions',
      xpReward: 60,
    ),
  ];

  static int get totalXpEarned => all
      .where((a) => a.isEarned)
      .fold(0, (sum, a) => sum + a.xpReward);

  static int get earnedCount => all.where((a) => a.isEarned).length;

  static List<AchievementItem> get earned => all.where((a) => a.isEarned).toList();

  static List<AchievementItem> get locked => all.where((a) => !a.isEarned).toList();

  static List<AchievementItem> forCategory(AchievementCategory category) =>
      all.where((a) => a.category == category).toList();
}
