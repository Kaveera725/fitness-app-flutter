import 'package:flutter/material.dart';

/// Achievement category enum
enum AchievementCategory {
  streaks('Streaks'),
  workouts('Workouts'),
  consistency('Consistency'),
  milestones('Milestones');

  final String label;
  const AchievementCategory(this.label);
}

/// Rarity tier for badge visual treatment
enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

/// A single achievement/badge definition with earned state & progress
class AchievementItem {
  final String id;
  final String title;
  final String description;
  final String howToEarn;
  final IconData icon;
  final Color color;
  final AchievementCategory category;
  final AchievementRarity rarity;

  final bool isEarned;
  final DateTime? earnedDate;

  final int currentProgress;
  final int targetProgress;
  final String progressUnit;
  final int xpReward;

  const AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.howToEarn,
    required this.icon,
    required this.color,
    required this.category,
    this.rarity = AchievementRarity.common,
    this.isEarned = false,
    this.earnedDate,
    required this.currentProgress,
    required this.targetProgress,
    required this.progressUnit,
    this.xpReward = 50,
  });

  double get progressFraction =>
      (currentProgress / targetProgress).clamp(0.0, 1.0);

  String get progressLabel => '$currentProgress / $targetProgress $progressUnit';

  /// A shorter version of earned date like "Sep 23, 2026"
  String get earnedDateFormatted {
    if (earnedDate == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[earnedDate!.month - 1]} ${earnedDate!.day}, ${earnedDate!.year}';
  }

  String get rarityLabel {
    switch (rarity) {
      case AchievementRarity.legendary:
        return 'Legendary';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.common:
        return 'Common';
    }
  }

  Color get rarityGlowColor {
    switch (rarity) {
      case AchievementRarity.legendary:
        return const Color(0xFFFFD700); // Gold
      case AchievementRarity.epic:
        return const Color(0xFF7C4DFF); // Purple
      case AchievementRarity.rare:
        return const Color(0xFF00E5FF); // Cyan
      case AchievementRarity.common:
        return color;
    }
  }
}
