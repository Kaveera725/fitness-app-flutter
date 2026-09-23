import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'achievements_screen.dart';
import 'models/progress_mock_data.dart';
import 'models/progress_models.dart';
import 'widgets/achievements_preview_section.dart';
import 'widgets/body_measurements_section.dart';
import 'widgets/progress_photos_section.dart';
import 'widgets/streak_calendar_section.dart';
import 'widgets/time_range_selector.dart';
import 'widgets/weight_trend_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  TimeRange _selectedRange = TimeRange.month;
  late List<BodyMeasurement> _measurements;
  late List<ProgressPhoto> _photos;
  late List<WorkoutCalendarDay> _calendarDays;
  late List<AchievementBadge> _recentAchievements;

  @override
  void initState() {
    super.initState();
    _measurements = List.from(ProgressMockData.initialMeasurements);
    _photos = List.from(ProgressMockData.initialPhotos);
    _calendarDays = ProgressMockData.getSeptemberCalendar();
    _recentAchievements = ProgressMockData.recentAchievements;
  }

  void _onTimeRangeChanged(TimeRange range) {
    setState(() {
      _selectedRange = range;
    });
  }

  void _onMeasurementLogged(String id, double newValue) {
    setState(() {
      _measurements = _measurements.map((m) {
        if (m.id == id) {
          return m.copyWith(
            previousValue: m.currentValue,
            currentValue: newValue,
            lastUpdated: DateTime.now(),
          );
        }
        return m;
      }).toList();
    });
  }

  void _onPhotoAdded(ProgressPhoto newPhoto) {
    setState(() {
      _photos.insert(0, newPhoto);
    });
  }

  void _navigateToAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AchievementsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWeightData = ProgressMockData.weightDataByRange[_selectedRange]!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          backgroundColor: AppTheme.surfaceDark,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            setState(() {
              // Quick refresh
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar / Header
                _buildHeader(context),

                const SizedBox(height: 20),

                // 1. Time Range Selector (Week / Month / 3 Months / Year)
                TimeRangeSelector(
                  selectedRange: _selectedRange,
                  onRangeChanged: _onTimeRangeChanged,
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 18),

                // 2. Weight Trend Line Chart (fl_chart)
                WeightTrendChart(
                  data: currentWeightData,
                ),

                const SizedBox(height: 28),

                // 3. Body Measurements Section (Chest, Waist, Arms, Legs + Log)
                BodyMeasurementsSection(
                  measurements: _measurements,
                  onMeasurementLogged: _onMeasurementLogged,
                ),

                const SizedBox(height: 28),

                // 4. Progress Photos (Thumbnails + "Add Photo" via image_picker)
                ProgressPhotosSection(
                  photos: _photos,
                  onPhotoAdded: _onPhotoAdded,
                ),

                const SizedBox(height: 28),

                // 5. Streak Calendar (Month view, completed days)
                StreakCalendarSection(
                  days: _calendarDays,
                ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),

                const SizedBox(height: 28),

                // 6. Achievements Preview (Horizontal row of 3-4 badges + "See All")
                AchievementsPreviewSection(
                  achievements: _recentAchievements,
                  onSeeAllTap: _navigateToAchievements,
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Analytics',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Track your body recomposition & milestones',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),

        // Export/Share Summary Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.share_rounded, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Progress report exported to clipboard!'),
                    ],
                  ),
                  backgroundColor: AppTheme.surfaceLighter,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: const Icon(
                Icons.ios_share_rounded,
                color: AppTheme.textDark,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
