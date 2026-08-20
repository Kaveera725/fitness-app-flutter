import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_button.dart';
import 'main_tab_screen.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 100,
                  color: theme.colorScheme.secondary,
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 32),
              Text(
                "Workout Complete!",
                style: theme.textTheme.displaySmall,
              ).animate().fade(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              Text(
                "Great job! You've crushed another workout.",
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryStat("Time", "30:00", theme),
                  _buildSummaryStat("Calories", "350", theme),
                  _buildSummaryStat("Avg HR", "145", theme),
                ],
              ).animate().fade(delay: 500.ms).slideY(begin: 0.2, end: 0),
              const Spacer(),
              CustomButton(
                text: "Back to Home",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainTabScreen()),
                    (route) => false,
                  );
                },
              ).animate().fade(delay: 600.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
