import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import 'meal_plans/build_meal_plan_for_user_screen.dart';
import 'meal_plans/meal_plan_request_model.dart';
import 'assign_workout_plan_screen.dart';
import 'my_clients_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Client Detail Screen
// ─────────────────────────────────────────────────────────────────────────────

class ClientDetailScreen extends StatefulWidget {
  final ClientItem? client;
  final String? clientId;

  const ClientDetailScreen({
    super.key,
    this.client,
    this.clientId,
  });

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late TextEditingController _notesController;
  bool _isNoteSaved = false;

  // Selected time frame for weight trend chart: 0: 4W, 1: 8W, 2: 12W
  int _selectedTimeFrame = 1;

  // Mutable state for the client's plans so edits reflect in real time
  late String _currentWorkoutPlan;
  late String _currentWorkoutSplit;
  late String _currentMealPlan;
  late String _currentMealPlanStatus;
  late bool _hasMealPlan;

  // Sample weight tracking points for 8 weeks (kg)
  final List<FlSpot> _weightSpots8W = const [
    FlSpot(0, 66.0), // W1
    FlSpot(1, 65.4), // W2
    FlSpot(2, 64.8), // W3
    FlSpot(3, 64.3), // W4
    FlSpot(4, 63.9), // W5
    FlSpot(5, 63.2), // W6
    FlSpot(6, 62.8), // W7
    FlSpot(7, 62.5), // W8 (Current)
  ];

  final List<String> _weekLabels8W = const [
    'W1',
    'W2',
    'W3',
    'W4',
    'W5',
    'W6',
    'W7',
    'W8',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _currentWorkoutPlan = c?.plan ?? '12-Week Hypertrophy Protocol';
    _currentWorkoutSplit = '4 Days/wk • Push/Pull/Legs';

    // If client is Tom Reeves or has empty plan demo, we can adapt, else provide active meal plan
    if (c?.id == 'c6') {
      _hasMealPlan = false;
      _currentMealPlan = 'No meal plan yet';
      _currentMealPlanStatus = 'Pending Request';
    } else {
      _hasMealPlan = true;
      _currentMealPlan = 'High-Protein Clean Bulk (2,250 kcal)';
      _currentMealPlanStatus = 'Active • Week 4';
    }

    _notesController = TextEditingController(
      text:
          'Struggles with morning workouts, prefers evening sessions. Form on Romanian deadlifts is solid, focus on hip hinge depth and controlled eccentric tempo. Hit personal record on barbell bench press (52.5 kg x 6). Target 2.0g protein/kg bodyweight.',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ── Client Profile Getters ──────────────────────────────────────────────────
  String get _name => widget.client?.name ?? 'Sarah Jenkins';
  String get _avatarUrl =>
      widget.client?.avatarUrl ?? 'https://i.pravatar.cc/150?img=47';
  String get _goal => widget.client?.goal ?? 'Muscle Hypertrophy';
  String get _weight => widget.client?.weight ?? '62.5 kg';
  String get _targetWeight => widget.client?.targetWeight ?? '60.0 kg';
  String get _height => '168 cm';
  int get _age => 26;
  String get _bodyFat => '21.5%';

  // ── Handlers ────────────────────────────────────────────────────────────────

  void _openMessageSheet() {
    final msgController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(_avatarUrl),
                    backgroundColor: AppTheme.surfaceLighter,
                    onBackgroundImageError: (_, _) {},
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Message',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        'Sending to $_name',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppTheme.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: msgController,
                maxLines: 4,
                autofocus: true,
                style: GoogleFonts.manrope(
                    color: AppTheme.textDark, fontSize: 13),
                decoration: InputDecoration(
                  hintText:
                      'Type an accountability message, form feedback, or nutrition tip...',
                  hintStyle: GoogleFonts.manrope(
                      color: AppTheme.textSecondary, fontSize: 12),
                  filled: true,
                  fillColor: AppTheme.surfaceLighter,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final txt = msgController.text.trim();
                    Navigator.pop(ctx);
                    if (txt.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Message delivered to $_name!'),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_rounded,
                      size: 16, color: AppTheme.backgroundDark),
                  label: Text(
                    'Send Message',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAssignWorkoutPlanBuilder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignWorkoutPlanScreen(
          clientName: _name,
          clientAvatar: _avatarUrl,
          currentPlanTitle: _currentWorkoutPlan,
          onPlanSaved: (newTitle) {
            setState(() {
              _currentWorkoutPlan = newTitle;
            });
          },
        ),
      ),
    );
  }

  void _openMealPlanBuilder() {
    // Look up or construct a sample request matching this client
    final allRequests = getSampleMealPlanRequests();
    MealPlanRequest targetRequest = allRequests.firstWhere(
      (r) => r.userName.toLowerCase() == _name.toLowerCase(),
      orElse: () => MealPlanRequest(
        id: "req_custom_${_name.toLowerCase().replaceAll(' ', '_')}",
        userName: _name,
        userAvatar: _avatarUrl,
        age: _age,
        height: _height,
        weight: _weight,
        bodyFat: _bodyFat,
        fitnessGoal: _goal,
        targetCalories: 2250,
        targetProtein: 165,
        targetCarbs: 230,
        targetFats: 65,
        dietaryPreferences: ["High-Protein", "Clean Carbs"],
        allergies: "None",
        mealsPerDay: 4,
        userNotes:
            "Goal is to build lean muscle mass while keeping body fat low. Training 4 days per week.",
        timestamp: "Recently",
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildMealPlanForUserScreen(
          request: targetRequest,
          onPlanAssigned: (updatedReq) {
            setState(() {
              _hasMealPlan = true;
              _currentMealPlan =
                  '${updatedReq.fitnessGoal} Plan (${updatedReq.targetCalories} kcal)';
              _currentMealPlanStatus = 'Active • Just Updated';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Meal plan successfully assigned to $_name!'),
                backgroundColor: AppTheme.accentGreen,
              ),
            );
          },
        ),
      ),
    );
  }

  void _saveNotes() {
    setState(() {
      _isNoteSaved = true;
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Private coach notes saved!'),
        backgroundColor: AppTheme.accentGreen,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isNoteSaved = false);
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Client Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Message Trainee',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentGreen.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppTheme.accentGreen,
                size: 18,
              ),
            ),
            onPressed: _openMessageSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Card (Avatar, Name, Compact Stats)
              _buildHeaderCard()
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: -0.05, end: 0),
              const SizedBox(height: 20),

              // 2. Progress Section (Weight Line Chart & Adherence Cards)
              _buildProgressSection()
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 350.ms),
              const SizedBox(height: 24),

              // 3. Current Plans Section (Workout Plan & Meal Plan side-by-side)
              _buildCurrentPlansSection()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 350.ms),
              const SizedBox(height: 16),

              // 4. Quick Actions Row (Assign Workout / Assign Meal Plan)
              _buildPlanActionsRow()
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 350.ms),
              const SizedBox(height: 24),

              // 5. Private Notes Section
              _buildNotesSection()
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 350.ms),
              const SizedBox(height: 24),

              // 6. Ratings Left by Client (if any)
              _buildRatingSection()
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 350.ms),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. Header Card ──────────────────────────────────────────────────────────
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with active dot
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentGreen, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppTheme.surfaceLighter,
                          child: const Icon(Icons.person_rounded,
                              color: AppTheme.textSecondary, size: 32),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.backgroundDark, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name + Member Type + Goal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded,
                            color: AppTheme.accentGreen, size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Goal: $_goal',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge.active(label: 'Active Trainee'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Compact Stats Row (Age / Weight / Height / Goal / Body Fat)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLighter,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _headerMetric('Age', '$_age yrs'),
                _divider(),
                _headerMetric('Weight', _weight),
                _divider(),
                _headerMetric('Height', _height),
                _divider(),
                _headerMetric('Target', _targetWeight),
                _divider(),
                _headerMetric('Body Fat', _bodyFat),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      color: AppTheme.surfaceBorder,
    );
  }

  // ── 2. Progress Section ─────────────────────────────────────────────────────
  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress & Compliance',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_down_rounded,
                      color: AppTheme.accentGreen, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '-3.5 kg total',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Weight Trend Line Chart Card (fl_chart)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.surfaceBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Trend (kg)',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        'Weekly weigh-in measurements',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Time frame pills
                  Row(
                    children: [
                      _timeFramePill('4W', 0),
                      const SizedBox(width: 6),
                      _timeFramePill('8W', 1),
                      const SizedBox(width: 6),
                      _timeFramePill('12W', 2),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // fl_chart LineChart
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 7,
                    minY: 60,
                    maxY: 68,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 34,
                          interval: 2,
                          getTitlesWidget: (val, _) {
                            return Text(
                              '${val.toInt()}k',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 1,
                          getTitlesWidget: (val, _) {
                            final idx = val.toInt();
                            if (idx >= 0 && idx < _weekLabels8W.length) {
                              final isCurrent =
                                  idx == _weekLabels8W.length - 1;
                              return Text(
                                _weekLabels8W[idx],
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: isCurrent
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: isCurrent
                                      ? AppTheme.accentGreen
                                      : AppTheme.textSecondary,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y} kg',
                              GoogleFonts.poppins(
                                color: AppTheme.backgroundDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _weightSpots8W,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: AppTheme.accentGreen,
                        barWidth: 3.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, idx) {
                            final isLast = idx == _weightSpots8W.length - 1;
                            return FlDotCirclePainter(
                              radius: isLast ? 5 : 3,
                              color: isLast
                                  ? AppTheme.accentGreen
                                  : AppTheme.surfaceDark,
                              strokeWidth: 2,
                              strokeColor: AppTheme.accentGreen,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.accentGreen.withValues(alpha: 0.25),
                              AppTheme.accentGreen.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Two Compliance Stat Cards Side by Side
        Row(
          children: [
            // Workout Completion %
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.surfaceBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.fitness_center_rounded,
                              size: 16, color: AppTheme.accentGreen),
                        ),
                        Text(
                          '88%',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accentGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Workout Adherence',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4/4 sessions completed',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.88,
                        minHeight: 5,
                        backgroundColor: AppTheme.surfaceLighter,
                        valueColor:
                            AlwaysStoppedAnimation(AppTheme.accentGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Meal Plan Adherence %
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.surfaceBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.restaurant_rounded,
                              size: 16, color: AppTheme.accentOrange),
                        ),
                        Text(
                          '92%',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accentOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Meal Plan Compliance',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '22/24 logged meals',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.92,
                        minHeight: 5,
                        backgroundColor: AppTheme.surfaceLighter,
                        valueColor:
                            AlwaysStoppedAnimation(AppTheme.accentOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _timeFramePill(String label, int index) {
    final isSelected = _selectedTimeFrame == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeFrame = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentGreen
              : AppTheme.surfaceLighter,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppTheme.backgroundDark
                : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── 3. Current Plans Section ────────────────────────────────────────────────
  Widget _buildCurrentPlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Assigned Plans',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Plan Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.surfaceBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.fitness_center_rounded,
                              size: 16, color: AppTheme.accentGreen),
                        ),
                        GestureDetector(
                          onTap: _openAssignWorkoutPlanBuilder,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLighter,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: AppTheme.surfaceBorder),
                            ),
                            child: Text(
                              'Edit',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Workout Plan',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentWorkoutPlan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentWorkoutSplit,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Meal Plan Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _hasMealPlan
                        ? AppTheme.surfaceBorder
                        : AppTheme.accentOrange.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.restaurant_menu_rounded,
                              size: 16, color: AppTheme.accentOrange),
                        ),
                        GestureDetector(
                          onTap: _openMealPlanBuilder,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _hasMealPlan
                                  ? AppTheme.surfaceLighter
                                  : AppTheme.accentOrange,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _hasMealPlan
                                    ? AppTheme.surfaceBorder
                                    : AppTheme.accentOrange,
                              ),
                            ),
                            child: Text(
                              _hasMealPlan ? 'Edit' : 'Create',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _hasMealPlan
                                    ? AppTheme.accentOrange
                                    : AppTheme.backgroundDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Meal Plan',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentMealPlan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _hasMealPlan
                            ? AppTheme.textDark
                            : AppTheme.accentOrange,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentMealPlanStatus,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: _hasMealPlan
                            ? AppTheme.textSecondary
                            : AppTheme.accentOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 4. Plan Actions Row ─────────────────────────────────────────────────────
  Widget _buildPlanActionsRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppTheme.surfaceBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _openAssignWorkoutPlanBuilder,
            icon: const Icon(Icons.fitness_center_rounded,
                size: 16, color: AppTheme.textDark),
            label: Text(
              'Assign Workout',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _openMealPlanBuilder,
            icon: const Icon(Icons.restaurant_menu_rounded,
                size: 16, color: AppTheme.backgroundDark),
            label: Text(
              _hasMealPlan ? 'Edit Meal Plan' : 'Assign Meal Plan',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.backgroundDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 5. Private Notes Section ────────────────────────────────────────────────
  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 16, color: AppTheme.accentGreen),
                  const SizedBox(width: 6),
                  Text(
                    'Private Coach Notes',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Only visible to you',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppTheme.textDark,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText:
                  'Track client observations, form notes, schedule preferences...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              filled: true,
              fillColor: AppTheme.surfaceLighter,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.accentGreen),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isNoteSaved
                    ? Colors.green
                    : AppTheme.accentGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: _saveNotes,
              icon: Icon(
                _isNoteSaved ? Icons.check_rounded : Icons.save_rounded,
                size: 15,
                color: AppTheme.backgroundDark,
              ),
              label: Text(
                _isNoteSaved ? 'Saved' : 'Save Notes',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.backgroundDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 6. Client Rating & Feedback Section ─────────────────────────────────────
  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Client Review & Rating',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (_) => const Icon(Icons.star_rounded,
                        color: Color(0xFFFFD700), size: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '5.0',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLighter,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"Marcus tailored my routine perfectly around my busy schedule. Down 4% body fat in 8 weeks and feeling stronger than ever!"',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textDark,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- $_name',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                    Text(
                      'Reviewed 2 weeks ago',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
