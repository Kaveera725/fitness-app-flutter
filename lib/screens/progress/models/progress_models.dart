import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum TimeRange {
  week('Week', 'Past 7 Days'),
  month('Month', 'Past 30 Days'),
  threeMonths('3 Months', 'Past 12 Weeks'),
  year('Year', 'Past 12 Months');

  final String label;
  final String subtitle;

  const TimeRange(this.label, this.subtitle);
}

class WeightPoint {
  final double x;
  final double weight;
  final String label;
  final String date;
  final String? note;

  const WeightPoint({
    required this.x,
    required this.weight,
    required this.label,
    required this.date,
    this.note,
  });

  FlSpot toSpot() => FlSpot(x, weight);
}

class TimeRangeWeightData {
  final TimeRange range;
  final List<WeightPoint> points;
  final double startWeight;
  final double currentWeight;
  final double goalWeight;
  final double minY;
  final double maxY;
  final double horizontalInterval;

  const TimeRangeWeightData({
    required this.range,
    required this.points,
    required this.startWeight,
    required this.currentWeight,
    required this.goalWeight,
    required this.minY,
    required this.maxY,
    this.horizontalInterval = 2.0,
  });

  double get totalChange => currentWeight - startWeight;
  double get percentageChange => ((currentWeight - startWeight) / startWeight) * 100;
  bool get isLoss => totalChange <= 0;
  double get remainingToGoal => (currentWeight - goalWeight).abs();

  List<FlSpot> get spots => points.map((p) => p.toSpot()).toList();
}

class BodyMeasurement {
  final String id;
  final String name;
  final double currentValue;
  final double previousValue;
  final String unit;
  final DateTime lastUpdated;
  final IconData icon;
  final Color accentColor;

  const BodyMeasurement({
    required this.id,
    required this.name,
    required this.currentValue,
    required this.previousValue,
    this.unit = 'cm',
    required this.lastUpdated,
    required this.icon,
    required this.accentColor,
  });

  double get delta => currentValue - previousValue;
  bool get hasDecreased => delta < 0;
  bool get hasIncreased => delta > 0;

  BodyMeasurement copyWith({
    double? currentValue,
    double? previousValue,
    DateTime? lastUpdated,
  }) {
    return BodyMeasurement(
      id: id,
      name: name,
      currentValue: currentValue ?? this.currentValue,
      previousValue: previousValue ?? this.currentValue,
      unit: unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      icon: icon,
      accentColor: accentColor,
    );
  }
}

class ProgressPhoto {
  final String id;
  final String caption;
  final DateTime date;
  final double weight;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? note;

  const ProgressPhoto({
    required this.id,
    required this.caption,
    required this.date,
    required this.weight,
    this.imageUrl,
    this.imageBytes,
    this.note,
  });
}

class WorkoutCalendarDay {
  final int day;
  final DateTime date;
  final bool isCompleted;
  final bool isToday;
  final int intensity; // 1: light, 2: moderate, 3: intense
  final String? workoutTitle;
  final int? durationMinutes;
  final int? caloriesBurned;

  const WorkoutCalendarDay({
    required this.day,
    required this.date,
    this.isCompleted = false,
    this.isToday = false,
    this.intensity = 1,
    this.workoutTitle,
    this.durationMinutes,
    this.caloriesBurned,
  });
}

class AchievementBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final double progress; // 0.0 to 1.0
  final String progressLabel;
  final String category;

  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedDate,
    this.progress = 1.0,
    required this.progressLabel,
    required this.category,
  });
}
