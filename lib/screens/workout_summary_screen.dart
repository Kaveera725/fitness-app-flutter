import 'package:flutter/material.dart';
import 'workout_player/workout_complete_screen.dart';

export 'workout_player/workout_complete_screen.dart';

/// Legacy alias / wrapper for WorkoutCompleteScreen
class WorkoutSummaryScreen extends StatelessWidget {
  final String? workoutName;
  final String? workoutCategory;
  final int? durationSeconds;
  final int? caloriesBurned;
  final int? exercisesCompleted;
  final int? totalExercises;
  final int? personalRecordsHit;

  const WorkoutSummaryScreen({
    super.key,
    this.workoutName,
    this.workoutCategory,
    this.durationSeconds,
    this.caloriesBurned,
    this.exercisesCompleted,
    this.totalExercises,
    this.personalRecordsHit,
  });

  @override
  Widget build(BuildContext context) {
    return WorkoutCompleteScreen(
      workoutName: workoutName ?? "Upper Body Hypertrophy & Power",
      workoutCategory: workoutCategory ?? "Strength · Biceps & Chest",
      durationSeconds: durationSeconds ?? 2548,
      caloriesBurned: caloriesBurned ?? 384,
      exercisesCompleted: exercisesCompleted ?? 8,
      totalExercises: totalExercises ?? 8,
      personalRecordsHit: personalRecordsHit ?? 2,
    );
  }
}
