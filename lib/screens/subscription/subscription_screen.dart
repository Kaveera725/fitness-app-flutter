import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness/theme/app_theme.dart';
import 'package:fitness/widgets/gradient_button.dart';
import 'payment_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // 0 = monthly, 1 = annual
  int _selectedPlan = 1; // Default to annual

  static const List<Map<String, dynamic>> _benefits = [
    {
      'icon': Icons.person_pin_rounded,
      'text': 'Select and message your personal coach',
    },
    {
      'icon': Icons.analytics_rounded,
      'text': 'Advanced progress analytics & body stats',
    },
    {
      'icon': Icons.lock_open_rounded,
      'text': 'Exclusive premium-only workout plans',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF260D4D), Color(0xFF1A0A33), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      // Crown badge
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      )
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.easeOutBack),

                      const SizedBox(height: 16),

                      Text(
                        'Unlock Premium',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 6),

                      Text(
                        'Take your fitness journey to the next level',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 150.ms),

                      const SizedBox(height: 24),

                      // ── Benefits Checklist ──────────────────────────────
                      ..._benefits.asMap().entries.map((entry) {
                        final i = entry.key;
                        final b = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  b['icon'] as IconData,
                                  color: const Color(0xFFB39DDB),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  b['text'] as String,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF00E676),
                                size: 20,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: Duration(milliseconds: 200 + i * 80));
                      }),

                      const SizedBox(height: 28),

                      // ── Plan Selection ──────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select a plan',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _PlanCard(
                              label: 'Monthly',
                              price: '\$19.99',
                              period: '/month',
                              isSelected: _selectedPlan == 0,
                              badge: null,
                              onTap: () => setState(() => _selectedPlan = 0),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PlanCard(
                              label: 'Annual',
                              price: '\$199.99',
                              period: '/year',
                              isSelected: _selectedPlan == 1,
                              badge: 'Save 33%',
                              onTap: () => setState(() => _selectedPlan = 1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Cancel anytime. 7-day money back guarantee.',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom CTA ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: GradientButton(
                  text: 'Continue to Payment',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          planLabel: _selectedPlan == 0 ? 'Monthly' : 'Annual',
                          planPrice:
                              _selectedPlan == 0 ? '\$19.99/mo' : '\$199.99/yr',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan Card Widget ──────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String period;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? const Color(0xFF5E35B1).withOpacity(0.3)
              : Colors.white.withOpacity(0.06),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C4DFF) : Colors.white24,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C4DFF).withOpacity(0.3),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Badge or Spacer
            if (badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6D00), Color(0xFFFF9100)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              )
            else
              const SizedBox(height: 23),

            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              price,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isSelected ? const Color(0xFFB39DDB) : Colors.white,
              ),
            ),
            Text(
              period,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
