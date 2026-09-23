import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/progress_models.dart';

class StreakCalendarSection extends StatefulWidget {
  final List<WorkoutCalendarDay> days;

  const StreakCalendarSection({
    super.key,
    required this.days,
  });

  @override
  State<StreakCalendarSection> createState() => _StreakCalendarSectionState();
}

class _StreakCalendarSectionState extends State<StreakCalendarSection> {
  WorkoutCalendarDay? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Default selected day is today or the latest completed day
    _selectedDay = widget.days.firstWhere(
      (d) => d.isToday,
      orElse: () => widget.days.lastWhere((d) => d.isCompleted, orElse: () => widget.days.first),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.days.where((d) => d.isCompleted).length;
    final totalDays = widget.days.length;
    final completionRate = ((completedCount / totalDays) * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.surfaceBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & Month Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Workout Streak',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF141714),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Text(
                  'September 2026',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Summary Metric Pills: Streak, Workouts, Consistency
          Row(
            children: [
              _buildSummaryPill('🔥 Active Streak', '12 Days', AppTheme.accentOrange),
              const SizedBox(width: 8),
              _buildSummaryPill('🏋️ Completed', '$completedCount Days', AppTheme.primary),
              const SizedBox(width: 8),
              _buildSummaryPill('📈 Consistency', '$completionRate%', const Color(0xFF00E5FF)),
            ],
          ),

          const SizedBox(height: 20),

          // Days of Week Header (M, T, W, T, F, S, S)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return SizedBox(
                width: 34,
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Month Calendar Grid (7 columns)
          // September 2026 starts on Tuesday (offset 1 day)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30 + 1, // 1 leading empty slot for Tuesday start + 30 days
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Leading blank slot for September 1 (Tuesday)
                return const SizedBox.shrink();
              }

              final dayIndex = index - 1;
              final dayItem = widget.days[dayIndex];
              final isSelected = _selectedDay?.day == dayItem.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = dayItem;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _getDayBackgroundColor(dayItem, isSelected),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getDayBorderColor(dayItem, isSelected),
                      width: isSelected ? 2.0 : (dayItem.isToday ? 1.5 : 1.0),
                    ),
                    boxShadow: dayItem.isCompleted
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(
                                alpha: dayItem.intensity == 3 ? 0.35 : 0.2,
                              ),
                              blurRadius: isSelected ? 8 : 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${dayItem.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: dayItem.isCompleted || dayItem.isToday
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _getDayTextColor(dayItem),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Selected Day Detail Drawer/Card
          if (_selectedDay != null) ...[
            const SizedBox(height: 18),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF141714),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedDay!.isCompleted
                      ? AppTheme.primary.withValues(alpha: 0.3)
                      : AppTheme.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _selectedDay!.isCompleted
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : AppTheme.surfaceDark,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedDay!.isCompleted
                            ? AppTheme.primary.withValues(alpha: 0.4)
                            : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _selectedDay!.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.bedtime_rounded,
                        color: _selectedDay!.isCompleted
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDay!.isCompleted
                              ? (_selectedDay!.workoutTitle ?? 'Completed Workout')
                              : 'Rest & Recovery Day',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedDay!.isCompleted
                              ? '${_selectedDay!.durationMinutes} min • ${_selectedDay!.caloriesBurned} kcal burned'
                              : 'Muscles rebuilt & body restored',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sep ${_selectedDay!.day}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryPill(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDayBackgroundColor(WorkoutCalendarDay day, bool isSelected) {
    if (day.isCompleted) {
      if (day.intensity == 3) {
        return AppTheme.primary;
      } else if (day.intensity == 2) {
        return AppTheme.primary.withValues(alpha: 0.85);
      } else {
        return AppTheme.primary.withValues(alpha: 0.65);
      }
    }
    if (day.isToday) {
      return AppTheme.surfaceLighter;
    }
    return const Color(0xFF141714);
  }

  Color _getDayBorderColor(WorkoutCalendarDay day, bool isSelected) {
    if (isSelected) {
      return Colors.white;
    }
    if (day.isToday) {
      return AppTheme.primary;
    }
    if (day.isCompleted) {
      return AppTheme.primary;
    }
    return AppTheme.surfaceBorder.withValues(alpha: 0.6);
  }

  Color _getDayTextColor(WorkoutCalendarDay day) {
    if (day.isCompleted) {
      return const Color(0xFF0D0F0D); // High contrast dark text on neon green
    }
    if (day.isToday) {
      return AppTheme.primary;
    }
    return AppTheme.textSecondary;
  }
}
