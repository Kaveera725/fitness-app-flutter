import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/progress_models.dart';

class BodyMeasurementsSection extends StatelessWidget {
  final List<BodyMeasurement> measurements;
  final Function(String id, double newValue) onMeasurementLogged;

  const BodyMeasurementsSection({
    super.key,
    required this.measurements,
    required this.onMeasurementLogged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with "+" Log Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.straighten_rounded,
                    color: AppTheme.accentOrange,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Body Measurements',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),

            // Quick "+" Log Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showLogMeasurementModal(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Log',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Horizontal Scrollable Cards
        SizedBox(
          height: 156,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: measurements.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index < measurements.length) {
                final item = measurements[index];
                return _buildMeasurementCard(context, item, index);
              } else {
                // Trailing "+" Card
                return _buildAddMeasurementTile(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementCard(BuildContext context, BodyMeasurement item, int index) {
    final delta = item.delta;
    final isZero = delta == 0;
    final isLoss = delta < 0;
    // For waist/chest reduction is usually green, for arms/legs hypertrophy might be green
    final isPositiveTone = item.id == 'waist' ? isLoss : (item.id == 'arms' || item.id == 'legs' ? !isLoss : isLoss);
    final deltaColor = isZero
        ? AppTheme.textSecondary
        : (isPositiveTone ? AppTheme.primary : AppTheme.accentOrange);

    final sign = delta > 0 ? '+' : '';

    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.surfaceBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: item.accentColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon & Delta Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.accentColor, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: deltaColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isZero)
                      Icon(
                        delta < 0 ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                        size: 11,
                        color: deltaColor,
                      ),
                    Text(
                      '$sign${delta.toStringAsFixed(1)} ${item.unit}',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Measurement Value & Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    item.currentValue.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.unit,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),

          // Last entry date
          Text(
            'Prev: ${item.previousValue.toStringAsFixed(1)} ${item.unit}',
            style: GoogleFonts.manrope(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 60).ms, duration: 350.ms).slideX(begin: 0.08, end: 0);
  }

  Widget _buildAddMeasurementTile(BuildContext context) {
    return InkWell(
      onTap: () => _showLogMeasurementModal(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF131613),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.35),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              'Add New\nLog',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogMeasurementModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return _LogMeasurementModalContent(
          measurements: measurements,
          onSave: (id, val) {
            onMeasurementLogged(id, val);
            Navigator.pop(sheetContext);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Logged $val cm successfully!',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                    ),
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
        );
      },
    );
  }
}

class _LogMeasurementModalContent extends StatefulWidget {
  final List<BodyMeasurement> measurements;
  final Function(String id, double val) onSave;

  const _LogMeasurementModalContent({
    required this.measurements,
    required this.onSave,
  });

  @override
  State<_LogMeasurementModalContent> createState() => _LogMeasurementModalContentState();
}

class _LogMeasurementModalContentState extends State<_LogMeasurementModalContent> {
  late String _selectedId;
  final _valController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.measurements.first.id;
    _valController.text = widget.measurements.first.currentValue.toString();
  }

  @override
  void dispose() {
    _valController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.measurements.firstWhere((m) => m.id == _selectedId);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Log Body Measurement',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Update your progress metrics to accurately track tape changes.',
            style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 18),

          // Segmented selector for body part
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.measurements.map((m) {
                final isSelected = m.id == _selectedId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(m.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedId = m.id;
                          _valController.text = m.currentValue.toString();
                        });
                      }
                    },
                    selectedColor: AppTheme.primary,
                    backgroundColor: const Color(0xFF141714),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF141714),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Icon(selectedItem.icon, color: AppTheme.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _valController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter ${selectedItem.name}',
                      hintStyle: GoogleFonts.manrope(
                        fontSize: 15,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                Text(
                  selectedItem.unit,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final double? parsed = double.tryParse(_valController.text.trim());
                if (parsed != null && parsed > 0) {
                  widget.onSave(_selectedId, parsed);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Save Measurement',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
