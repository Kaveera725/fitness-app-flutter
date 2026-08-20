import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress", style: theme.textTheme.displaySmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeightChart(theme),
            const SizedBox(height: 32),
            Text("Achievements", style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            _buildAchievements(theme),
            const SizedBox(height: 32),
            Text("Streak Calendar", style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            _buildStreakCalendar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weight Trend", style: theme.textTheme.titleLarge),
              Text(
                "Past 30 Days",
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 65,
                maxY: 75,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 72),
                      FlSpot(1, 71.5),
                      FlSpot(2, 70.8),
                      FlSpot(3, 70.5),
                      FlSpot(4, 69.9),
                      FlSpot(5, 69.2),
                      FlSpot(6, 68.5),
                    ],
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBadge(Icons.local_fire_department, "7 Day Streak", Colors.orange, theme),
        _buildBadge(Icons.fitness_center, "100 Workouts", theme.colorScheme.primary, theme),
        _buildBadge(Icons.emoji_events, "Weight Goal", AppTheme.accentGreen, theme),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStreakCalendar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 30, // Days in month
        itemBuilder: (context, index) {
          bool isWorkedOut = index % 3 != 0; // Dummy logic
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isWorkedOut ? AppTheme.accentGreen : theme.colorScheme.surface,
              border: Border.all(
                color: isWorkedOut ? AppTheme.accentGreen : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isWorkedOut ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
