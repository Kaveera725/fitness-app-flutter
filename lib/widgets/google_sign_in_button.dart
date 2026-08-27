import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable Google Sign-In button designed for FitPulse.
///
/// Can be used on both Login and Signup screens.
class GoogleSignInButton extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String text;
  final bool isFullWidth;

  const GoogleSignInButton({
    super.key,
    this.onSuccess,
    this.text = 'Continue with Google',
    this.isFullWidth = true,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  /// Placeholder function for Google OAuth / Firebase Auth integration.
  ///
  /// NOTE: Backend must check if this Google account ID already exists as a
  /// user before creating a new one, to prevent duplicate accounts per Google account.
  ///
  /// Future integration steps:
  /// 1. Use `google_sign_in` or `firebase_auth` package to trigger Google popup / native intent.
  /// 2. Obtain Google ID token & email.
  /// 3. Call backend `/auth/google` endpoint passing the token and Google user ID.
  /// 4. Backend verifies token with Google API and either logs in existing user or registers a new user.
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Simulate OAuth network hand-shake latency
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      // TODO: Replace with real GoogleSignIn / FirebaseAuth authentication flow
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // final response = await ApiService.instance.loginWithGoogle(googleAuth?.idToken);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Google Sign-In ready! (OAuth placeholder connected)',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF5E35B1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      widget.onSuccess?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final child = OutlinedButton(
      onPressed: _isLoading ? null : _signInWithGoogle,
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1F1F1F),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.15) : Colors.grey.shade300,
          width: 1.2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black.withOpacity(0.04),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E35B1)),
              ),
            )
          : Row(
              mainAxisSize:
                  widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleLogo(size: 20),
                const SizedBox(width: 12),
                Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2D2D2D),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
    );

    return widget.isFullWidth
        ? SizedBox(width: double.infinity, child: child)
        : child;
  }
}

/// Custom painted authentic 4-color Google "G" logo
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final greenPaint = Paint()..color = const Color(0xFF34A853);

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final innerRadius = radius * 0.55;

    // Red arc (top)
    final redPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 * 0.75,
        3.14159 * 0.5,
        false,
      )
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Yellow arc (left)
    final yellowPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 * 1.25,
        3.14159 * 0.5,
        false,
      )
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Green arc (bottom)
    final greenPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        3.14159 * 0.25,
        3.14159 * 0.5,
        false,
      )
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Blue arc + bar (right & crossbar)
    final bluePath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 * 0.25,
        3.14159 * 0.5,
        false,
      )
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // White center cutout to make the "G" ring
    final whiteHole = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, whiteHole);

    // Blue horizontal bar for the "G"
    final barRect = Rect.fromLTRB(
      center.dx,
      center.dy - innerRadius * 0.45,
      center.dx + radius * 0.95,
      center.dy + innerRadius * 0.45,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(2)),
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
