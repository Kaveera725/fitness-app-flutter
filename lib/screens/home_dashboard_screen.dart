import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/workout_card.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 32),
              _buildTodayProgress(theme),
              const SizedBox(height: 32),
              _buildQuickStats(),
              const SizedBox(height: 32),
              _buildWeeklyActivity(theme),
              const SizedBox(height: 32),
              _buildTodayWorkout(theme),
              const SizedBox(height: 32),
            ],
          ).animate().fade().slideY(begin: 0.1, end: 0, duration: 400.ms),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final currentUser = ApiService.instance.currentUser;
    final displayName = currentUser?.name?.isNotEmpty == true
        ? currentUser!.name!
        : (currentUser != null ? currentUser.email.split('@')[0] : "Alex Morgan");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning,",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
            Text(
              displayName,
              style: theme.textTheme.displaySmall,
            ),
          ],
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
          backgroundImage: const NetworkImage(
            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
          ),
        ),
      ],
    );
  }

  Widget _buildTodayProgress(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Goal",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "1,250",
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "/ 2,000 kcal",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ProgressRing(
            progress: 0.65,
            color: AppTheme.accentGreen,
            size: 100,
            strokeWidth: 12,
            centerContent: Icon(
              Icons.local_fire_department,
              color: AppTheme.accentGreen,
              size: 32,
            ),
          ).animate().scale(delay: 200.ms, duration: 500.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            title: "Steps",
            value: "8,432",
            icon: Icons.directions_walk,
            color: AppTheme.accentOrange,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: "Water",
            value: "1.2 L",
            icon: Icons.water_drop,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Activity",
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                _makeGroupData(0, 40, theme),
                _makeGroupData(1, 70, theme),
                _makeGroupData(2, 50, theme),
                _makeGroupData(3, 90, theme),
                _makeGroupData(4, 60, theme),
                _makeGroupData(5, 30, theme),
                _makeGroupData(6, 80, theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, ThemeData theme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: theme.colorScheme.primary,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayWorkout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Plan",
              style: theme.textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        WorkoutCard(
          title: "Full Body HIIT",
          duration: "45 min",
          difficulty: "Advanced",
          imageUrl: "https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=800&q=80",
          onTap: () {
            // Navigate to detail
          },
        ),
      ],
    );
  }
}
