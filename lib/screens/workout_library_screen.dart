import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/workout_card.dart';
import 'workout_detail_screen.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ["All", "HIIT", "Strength", "Cardio", "Yoga"];

  final List<Map<String, String>> _workouts = [
    {
      "title": "Full Body Burn",
      "duration": "30 min",
      "difficulty": "Intermediate",
      "category": "HIIT",
      "image": "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&q=80",
    },
    {
      "title": "Core Crusher",
      "duration": "15 min",
      "difficulty": "Beginner",
      "category": "Strength",
      "image": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80",
    },
    {
      "title": "Morning Flow",
      "duration": "20 min",
      "difficulty": "Beginner",
      "category": "Yoga",
      "image": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80",
    },
    {
      "title": "Sprint Intervals",
      "duration": "25 min",
      "difficulty": "Advanced",
      "category": "Cardio",
      "image": "https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCategory = _categories[_selectedCategoryIndex];
    
    final filteredWorkouts = selectedCategory == "All" 
        ? _workouts 
        : _workouts.where((w) => w["category"] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workouts",
          style: theme.textTheme.displaySmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategorySelector(theme),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                final workout = filteredWorkouts[index];
                return WorkoutCard(
                  title: workout["title"]!,
                  duration: workout["duration"]!,
                  difficulty: workout["difficulty"]!,
                  imageUrl: workout["image"]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDetailScreen(
                          title: workout["title"]!,
                          imageUrl: workout["image"]!,
                        ),
                      ),
                    );
                  },
                ).animate().fade(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : theme.cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Text(
                _categories[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
