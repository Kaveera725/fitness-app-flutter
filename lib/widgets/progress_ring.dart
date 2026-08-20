import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double size;
  final double strokeWidth;
  final Widget? centerContent;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    this.size = 100,
    this.strokeWidth = 10,
    this.centerContent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            color: color.withOpacity(0.2),
          ),
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            color: color,
            strokeCap: StrokeCap.round,
          ),
          if (centerContent != null)
            Center(child: centerContent!),
        ],
      ),
    );
  }
}
