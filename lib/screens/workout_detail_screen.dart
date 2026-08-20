import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import 'workout_player_screen.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;

  const WorkoutDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> exercises = [
      {"name": "Jumping Jacks", "duration": "0:45", "image": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&q=80"},
      {"name": "Push Ups", "duration": "0:30", "image": "https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=200&q=80"},
      {"name": "Plank", "duration": "1:00", "image": "https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?w=200&q=80"},
      {"name": "High Knees", "duration": "0:45", "image": "https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=200&q=80"},
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(Icons.timer, "30 min", theme),
                      _buildStat(Icons.local_fire_department, "350 kcal", theme),
                      _buildStat(Icons.fitness_center, "Intense", theme),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text("Exercises", style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              ex["image"]!,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ex["name"]!, style: theme.textTheme.titleLarge),
                                const SizedBox(height: 4),
                                Text(ex["duration"]!, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.play_circle, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 100), // Space for sticky button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: theme.scaffoldBackgroundColor,
        child: CustomButton(
          text: "Start Workout",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutPlayerScreen(title: title),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
