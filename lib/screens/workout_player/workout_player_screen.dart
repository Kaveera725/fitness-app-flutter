import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../workout_summary_screen.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  final String? title;
  final String? exerciseName;
  final String? equipment;
  final String? targetMuscle;
  final String? imageUrl;

  const WorkoutPlayerScreen({
    super.key,
    this.title,
    this.exerciseName,
    this.equipment,
    this.targetMuscle,
    this.imageUrl,
  });

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  bool _isPlaying = true;
  bool _isMuted = false;
  int _elapsedSeconds = 105; // 1:45 default start
  final int _totalSeconds = 340; // 5:40 total duration
  Timer? _ticker;

  // Realistic weight progression data
  final List<FlSpot> _progressionSpots = const [
    FlSpot(0, 37.5),
    FlSpot(1, 40.0),
    FlSpot(2, 42.5),
    FlSpot(3, 47.5),
  ];

  final List<String> _dayLabels = const ["Mon", "Wed", "Thu", "Sun"];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          if (_elapsedSeconds < _totalSeconds) {
            _elapsedSeconds++;
          } else {
            _isPlaying = false;
            timer.cancel();
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "$mins:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final exerciseTitle = widget.exerciseName ?? widget.title ?? "Concentration Curl — Seated Dumbbell";
    final equipmentLabel = widget.equipment ?? "Dumbbell";
    final muscleLabel = widget.targetMuscle ?? "Biceps & Forearms";
    final heroImage = widget.imageUrl ??
        "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=1000&q=80";

    final progressRatio = (_elapsedSeconds / _totalSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Full-Bleed Exercise Hero Image with Dark Gradient & Center Play Button
                _buildHeroImageSection(heroImage),

                // 2. Exercise Title, Sub-label & Timer Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-label pill (Equipment & Target Muscle)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.fitness_center_rounded, size: 12, color: AppTheme.primary),
                                const SizedBox(width: 4),
                                Text(
                                  equipmentLabel.toUpperCase(),
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "•   $muscleLabel",
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Large Bold White Exercise Name
                      Text(
                        exerciseTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Timer & Interactive Progress Bar
                      _buildTimerSection(progressRatio),
                      const SizedBox(height: 22),

                      // 3. Weight/Rep Progression Graph (fl_chart)
                      _buildProgressGraphCard(),
                      const SizedBox(height: 20),

                      // 4. Form Instruction Text Block
                      _buildFormInstructions(),
                      const SizedBox(height: 100), // Spacing for bottom controls
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          // Floating Top Bar (Back Arrow & Options)
          _buildFloatingTopBar(context),

          // Bottom Bar Controls (Mute, Cast, Finish)
          _buildBottomControls(context),
        ],
      ),
    );
  }

  // ==========================================
  // Hero Section with Play Button
  // ==========================================
  Widget _buildHeroImageSection(String imageUrl) {
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed exercise photo/video placeholder
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF181C18),
                child: const Center(
                  child: Icon(Icons.fitness_center_rounded, color: AppTheme.primary, size: 56),
                ),
              );
            },
          ),

          // Top and Bottom Dark Gradient Overlays for Text Legibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.transparent,
                  Colors.transparent,
                  AppTheme.backgroundDark.withValues(alpha: 0.6),
                  AppTheme.backgroundDark,
                ],
                stops: const [0.0, 0.25, 0.6, 0.88, 1.0],
              ),
            ),
          ),

          // Center Large Circular Play/Pause Button (Neon Green Glowing)
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: _isPlaying ? 0.6 : 0.3),
                      blurRadius: _isPlaying ? 28 : 16,
                      spreadRadius: _isPlaying ? 6 : 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 46,
                  color: const Color(0xFF0D0F0D),
                ),
              )
                  .animate(
                    target: _isPlaying ? 1 : 0,
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.06, 1.06),
                    duration: 1200.ms,
                    curve: Curves.easeInOut,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Floating Top Navigation Bar
  // ==========================================
  Widget _buildFloatingTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Arrow Button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0F0D).withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),

            // Live status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F0D).withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _isPlaying ? AppTheme.primary : AppTheme.textSecondary,
                      shape: BoxShape.circle,
                      boxShadow: _isPlaying
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.8),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isPlaying ? "ACTIVE SET" : "PAUSED",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _isPlaying ? AppTheme.primary : AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Options "..." Icon Button
            InkWell(
              onTap: () {
                _showWorkoutOptions(context);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0F0D).withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Timer & Progress Track Section
  // ==========================================
  Widget _buildTimerSection(double progressRatio) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "ELAPSED / TOTAL",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Text(
                "${_formatTime(_elapsedSeconds)} - ${_formatTime(_totalSeconds)}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Neon Green Progress Track with Glow
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 6,
              backgroundColor: const Color(0xFF222622),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Progress Graph Card (fl_chart)
  // ==========================================
  Widget _buildProgressGraphCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Metric Readout & Trend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "My Progress:",
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "47.5 kg",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "+10.0 kg over last 4 sessions",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 14, color: AppTheme.primary),
                    const SizedBox(width: 3),
                    Text(
                      "+26.6%",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Smooth Wavy Neon Green Line Chart
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: 30,
                maxY: 55,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xFF252A25),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < _dayLabels.length) {
                          final isLatest = idx == _dayLabels.length - 1;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _dayLabels[idx],
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: isLatest ? FontWeight.w800 : FontWeight.w600,
                                color: isLatest ? AppTheme.primary : AppTheme.textSecondary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _progressionSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.primary,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final isLast = index == _progressionSpots.length - 1;
                        return FlDotCirclePainter(
                          radius: isLast ? 6 : 4,
                          color: isLast ? AppTheme.primary : const Color(0xFF141714),
                          strokeWidth: 2.5,
                          strokeColor: AppTheme.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.28),
                          AppTheme.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF161A16),
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        return LineTooltipItem(
                          "${barSpot.y} kg",
                          GoogleFonts.poppins(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Form Instruction Text Block
  // ==========================================
  Widget _buildFormInstructions() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                "FORM & TECHNIQUE",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Sit on a sturdy bench and rest your elbow against your inner thigh. Curl the dumbbell smoothly toward your chest without swinging. Squeeze your bicep at peak contraction for 1 second, then lower with deliberate 3-second negative control.",
            style: GoogleFonts.manrope(
              fontSize: 13,
              height: 1.55,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Bottom Controls (Mute, Cast, Complete)
  // ==========================================
  Widget _buildBottomControls(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F0D).withValues(alpha: 0.94),
          border: Border(
            top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Speaker / Mute Icon Button
            IconButton(
              onPressed: _toggleMute,
              icon: Icon(
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: _isMuted ? AppTheme.textSecondary : Colors.white,
                size: 22,
              ),
              tooltip: _isMuted ? "Unmute" : "Mute",
            ),
            const SizedBox(width: 4),

            // Fullscreen / Cast Icon Button
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "AirPlay / Cast ready: Streaming to TV",
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: AppTheme.surfaceDark,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.surfaceBorder, width: 1),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.cast_rounded,
                color: Colors.white,
                size: 20,
              ),
              tooltip: "Cast Screen",
            ),
            const Spacer(),

            // Finish Workout Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkoutSummaryScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Finish Set",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      color: const Color(0xFF0D0F0D),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF0D0F0D)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.edit_note_rounded, color: AppTheme.primary),
                  title: Text("Log Custom Reps & Weight", style: GoogleFonts.poppins(color: AppTheme.textDark)),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.speed_rounded, color: AppTheme.primary),
                  title: Text("Adjust Playback Speed", style: GoogleFonts.poppins(color: AppTheme.textDark)),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.close_rounded, color: Colors.redAccent),
                  title: Text("Quit Workout", style: GoogleFonts.poppins(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
