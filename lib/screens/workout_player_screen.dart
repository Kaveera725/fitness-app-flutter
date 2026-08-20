import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/progress_ring.dart';
import '../widgets/custom_button.dart';
import 'workout_summary_screen.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final String title;

  const WorkoutPlayerScreen({super.key, required this.title});

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  bool _isPlaying = true;
  double _progress = 0.45; // dummy progress

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Jumping Jacks",
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Next: Push Ups",
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  ProgressRing(
                    progress: _progress,
                    color: theme.colorScheme.primary,
                    size: 250,
                    strokeWidth: 20,
                    centerContent: Text(
                      "00:24",
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: Icons.skip_previous,
                  onPressed: () {},
                  theme: theme,
                ),
                _buildPlayButton(theme),
                _buildControlButton(
                  icon: Icons.skip_next,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WorkoutSummaryScreen(),
                      ),
                    );
                  },
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed, required ThemeData theme}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 28),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPlayButton(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = !_isPlaying;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 40,
          color: Colors.white,
        ),
      ).animate(target: _isPlaying ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(0.9, 0.9)),
    );
  }
}
