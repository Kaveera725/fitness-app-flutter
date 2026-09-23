import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/progress_models.dart';

class WeightTrendChart extends StatefulWidget {
  final TimeRangeWeightData data;

  const WeightTrendChart({
    super.key,
    required this.data,
  });

  @override
  State<WeightTrendChart> createState() => _WeightTrendChartState();
}

class _WeightTrendChartState extends State<WeightTrendChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final isLoss = data.isLoss;
    final changeSign = isLoss ? '-' : '+';
    final changeValue = data.totalChange.abs().toStringAsFixed(1);
    final percentValue = data.percentageChange.abs().toStringAsFixed(1);

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
          // Header Row: Title & Net Trend Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.show_chart_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Weight Trend',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.range.subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              // Subtle Trend Arrow & Percentage Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (isLoss ? AppTheme.primary : AppTheme.accentOrange).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isLoss ? AppTheme.primary : AppTheme.accentOrange).withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                      size: 16,
                      color: isLoss ? AppTheme.primary : AppTheme.accentOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$changeSign$changeValue kg ($changeSign$percentValue%)',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLoss ? AppTheme.primary : AppTheme.accentOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Primary Stats Row
          Row(
            children: [
              _buildStatColumn('Current', '${data.currentWeight.toStringAsFixed(1)} kg', AppTheme.primary),
              _buildDivider(),
              _buildStatColumn('Starting', '${data.startWeight.toStringAsFixed(1)} kg', AppTheme.textDark),
              _buildDivider(),
              _buildStatColumn('Goal', '${data.goalWeight.toStringAsFixed(1)} kg', AppTheme.accentOrange),
              _buildDivider(),
              _buildStatColumn('Remaining', '${data.remainingToGoal.toStringAsFixed(1)} kg', AppTheme.textSecondary),
            ],
          ),

          const SizedBox(height: 24),

          // fl_chart Line Chart with flutter_animate draw-in
          SizedBox(
            height: 220,
            child: LineChart(
              _buildLineChartData(data),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppTheme.surfaceBorder,
    );
  }

  LineChartData _buildLineChartData(TimeRangeWeightData data) {
    final spots = data.spots;

    return LineChartData(
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: data.minY,
      maxY: data.maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: data.horizontalInterval,
        getDrawingHorizontalLine: (val) => FlLine(
          color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 34,
            interval: data.horizontalInterval,
            getTitlesWidget: (val, meta) {
              return Text(
                '${val.toStringAsFixed(val % 1 == 0 ? 0 : 1)}k',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 26,
            interval: 1,
            getTitlesWidget: (val, meta) {
              final idx = val.toInt();
              if (idx >= 0 && idx < data.points.length) {
                // If there are many points, skip some labels to keep clean
                if (data.points.length > 8 && idx % 2 != 0 && idx != data.points.length - 1) {
                  return const SizedBox.shrink();
                }

                final isLatest = idx == data.points.length - 1;
                final isTouched = _touchedIndex == idx;

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data.points[idx].label,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: (isLatest || isTouched) ? FontWeight.w800 : FontWeight.w500,
                      color: isTouched
                          ? AppTheme.primary
                          : (isLatest ? AppTheme.primary : AppTheme.textSecondary),
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
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchCallback: (event, response) {
          if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
            setState(() {
              _touchedIndex = response.lineBarSpots!.first.spotIndex;
            });
          } else {
            setState(() {
              _touchedIndex = null;
            });
          }
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppTheme.surfaceLighter,
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final idx = spot.spotIndex;
              final point = data.points[idx];
              final note = point.note != null ? '\n${point.note}' : '';

              return LineTooltipItem(
                '${point.date}: ${point.weight.toStringAsFixed(1)} kg$note',
                GoogleFonts.poppins(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 1.3,
                ),
                children: [
                  if (point.note != null)
                    TextSpan(
                      text: '\n${point.note}',
                      style: GoogleFonts.manrope(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                ],
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppTheme.primary,
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, idx) {
              final isLatest = idx == spots.length - 1;
              final isTouched = _touchedIndex == idx;

              if (isLatest || isTouched) {
                return FlDotCirclePainter(
                  radius: isTouched ? 6.5 : 5,
                  color: AppTheme.primary,
                  strokeWidth: 2.5,
                  strokeColor: AppTheme.backgroundDark,
                );
              }
              return FlDotCirclePainter(
                radius: 3,
                color: AppTheme.primary.withValues(alpha: 0.5),
                strokeWidth: 1.5,
                strokeColor: AppTheme.backgroundDark,
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
    );
  }
}
