import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: isPrimary ? const Color(0xFF0D0F0D) : theme.colorScheme.primary,
          ),
        ),
      ],
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: _buildButton(theme, buttonChild),
          )
        : _buildButton(theme, buttonChild);
  }

  Widget _buildButton(ThemeData theme, Widget child) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: const Color(0xFF0D0F0D), // High-contrast black on neon green
            disabledBackgroundColor: Colors.grey.shade800,
            disabledForegroundColor: Colors.grey.shade500,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: child,
        ),
      );
    } else {
      // Secondary: Black/dark button with neon green border & neon text
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF141714),
          foregroundColor: theme.colorScheme.primary,
          disabledForegroundColor: Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(
            color: onPressed != null ? theme.colorScheme.primary : Colors.grey.shade700,
            width: 1.5,
          ),
        ),
        child: child,
      );
    }
  }
}
