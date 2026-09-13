import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final List<Color>? gradientColors;
  final Color? textColor;
  final double borderRadius;
  final double height;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradientColors,
    this.textColor,
    this.borderRadius = 16.0,
    this.height = 56.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    // Default: High-energy athletic neon lime gradient
    final colors = gradientColors ??
        const [
          Color(0xFFC6FF00), // Vibrant Neon Lime
          Color(0xFFB4F81C), // Primary Lime Accent
          Color(0xFF9DE00B), // Deep Lime
        ];

    final isEnabled = onPressed != null && !isLoading;

    // By default, text on neon green is high-contrast near-black
    final effectiveTextColor = textColor ??
        (colors.first.computeLuminance() > 0.4
            ? const Color(0xFF0D0F0D)
            : Colors.white);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                ],
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.black.withValues(alpha: 0.12),
          highlightColor: Colors.black.withValues(alpha: 0.06),
          child: Padding(
            padding: padding,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 10),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: effectiveTextColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
