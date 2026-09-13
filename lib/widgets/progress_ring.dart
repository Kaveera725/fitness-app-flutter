import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final Color? trackColor;
  final double size;
  final double strokeWidth;
  final Widget? centerContent;

  const ProgressRing({
    super.key,
    required this.progress,
    this.color,
    this.trackColor,
    this.size = 100,
    this.strokeWidth = 10,
    this.centerContent,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppTheme.primary;
    final darkTrack = trackColor ?? const Color(0xFF202520);
    final clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          // 1. Dark Track Background
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            color: darkTrack,
          ),

          // 2. Subtle Glow Aura behind active progress
          if (clampedProgress > 0)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: CircularProgressIndicator(
                value: clampedProgress,
                strokeWidth: strokeWidth + 4,
                color: activeColor.withValues(alpha: 0.45),
                strokeCap: StrokeCap.round,
              ),
            ),

          // 3. Crisp Foreground Neon Progress Arc
          CircularProgressIndicator(
            value: clampedProgress,
            strokeWidth: strokeWidth,
            color: activeColor,
            strokeCap: StrokeCap.round,
          ),

          // 4. Center Metric Content
          if (centerContent != null)
            Center(child: centerContent!),
        ],
      ),
    );
  }
}
