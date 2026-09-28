import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'payment_screen.dart';
import 'subscription_screen.dart';

class ManageSubscriptionScreen extends StatefulWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  State<ManageSubscriptionScreen> createState() => _ManageSubscriptionScreenState();
}

class _ManageSubscriptionScreenState extends State<ManageSubscriptionScreen> {
  // Current active plan state (0 = Monthly, 1 = Annual)
  int _currentPlanIndex = 1;
  String _cardLastFour = '4242';
  String _cardExpiry = '08/28';
  bool _isCancelled = false;

  final List<Map<String, dynamic>> _billingHistory = [
    {
      'date': 'Oct 14, 2025',
      'amount': '\$199.99',
      'plan': 'Pro Athlete Annual',
      'invoice': 'INV-2025-8819',
      'status': 'Paid',
    },
    {
      'date': 'Oct 14, 2024',
      'amount': '\$199.99',
      'plan': 'Pro Athlete Annual',
      'invoice': 'INV-2024-5201',
      'status': 'Paid',
    },
    {
      'date': 'Oct 14, 2023',
      'amount': '\$19.99',
      'plan': 'Pro Athlete Monthly Trial',
      'invoice': 'INV-2023-1104',
      'status': 'Paid',
    },
  ];

  static const List<Map<String, dynamic>> _retentionPerks = [
    {
      'icon': Icons.chat_bubble_outline_rounded,
      'title': '1-on-1 Coach Access',
      'subtitle': 'Direct messaging and form checks with certified trainer Marcus Vance',
    },
    {
      'icon': Icons.restaurant_menu_rounded,
      'title': 'Custom Nutrition & Macros',
      'subtitle': 'Dynamic athlete meal plans calibrated to your body weight goals',
    },
    {
      'icon': Icons.monitor_heart_outlined,
      'title': 'Advanced Biometric Analytics',
      'subtitle': 'Heart rate telemetry, recovery rate tracking, and body composition',
    },
    {
      'icon': Icons.offline_bolt_rounded,
      'title': 'Exclusive Training Programs',
      'subtitle': 'Over 80+ elite hypertrophy, strength, and HIIT programs',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAnnual = _currentPlanIndex == 1;
    final planName = isAnnual ? 'Pro Athlete Annual' : 'Pro Athlete Monthly';
    final planPrice = isAnnual ? '\$199.99' : '\$19.99';
    final billingPeriod = isAnnual ? '/year' : '/month';
    final renewalDate = 'Oct 14, 2026';

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Subscription',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Current Plan Card ──────────────────────────────────────
            _buildSectionHeader('Current Plan', Icons.card_membership_rounded),
            _buildCurrentPlanCard(
              planName: planName,
              planPrice: planPrice,
              billingPeriod: billingPeriod,
              renewalDate: renewalDate,
              isCancelled: _isCancelled,
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),

            const SizedBox(height: 24),

            // ── 2. Payment Method on File ────────────────────────────────
            _buildSectionHeader('Payment Method', Icons.credit_card_rounded),
            _buildPaymentMethodCard().animate().fadeIn(duration: 300.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // ── 3. Billing History ───────────────────────────────────────
            _buildSectionHeader('Billing History', Icons.receipt_long_rounded),
            _buildBillingHistoryCard().animate().fadeIn(duration: 300.ms, delay: 150.ms),

            const SizedBox(height: 28),

            // ── 4. Plan Actions ──────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showChangePlanSheet,
                icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                label: Text('Change Plan (${isAnnual ? "Switch to Monthly" : "Switch to Annual"})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

            const SizedBox(height: 16),

            // ── 5. Cancel Subscription Link ──────────────────────────────
            Center(
              child: TextButton(
                onPressed: _isCancelled ? _handleResumeSubscription : _showCancelRetentionFlow,
                style: TextButton.styleFrom(
                  foregroundColor: _isCancelled ? AppTheme.primary : AppTheme.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  _isCancelled ? 'Resume Auto-Renew' : 'Cancel Subscription',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: _isCancelled ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── 1. Current Plan Card ────────────────────────────────────
  Widget _buildCurrentPlanCard({
    required String planName,
    required String planPrice,
    required String billingPeriod,
    required String renewalDate,
    required bool isCancelled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCancelled
              ? Colors.amber.withValues(alpha: 0.4)
              : AppTheme.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isCancelled
                ? Colors.amber.withValues(alpha: 0.08)
                : AppTheme.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: AppTheme.accentPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        'Full Athletic Access Tier',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? Colors.amber.withValues(alpha: 0.15)
                      : AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCancelled
                        ? Colors.amber.withValues(alpha: 0.5)
                        : AppTheme.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCancelled ? Colors.amber : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCancelled ? 'EXPIRING' : 'ACTIVE',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: isCancelled ? Colors.amber : AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1, color: AppTheme.surfaceBorder),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        planPrice,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        billingPeriod,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isCancelled ? 'Access Until' : 'Renews On',
                    style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    renewalDate,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (isCancelled) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your subscription is scheduled to end on $renewalDate. Tap Resume below to retain uninterrupted benefits.',
                      style: GoogleFonts.manrope(fontSize: 12, color: Colors.white70),
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

  // ── 2. Payment Method Card ──────────────────────────────────
  Widget _buildPaymentMethodCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Masked card icon chip
          Container(
            width: 48,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Center(
              child: Text(
                'VISA',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '••••  $_cardLastFour',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Expires $_cardExpiry',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _handleUpdatePaymentMethod,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text(
              'Update',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Billing History Card ─────────────────────────────────
  Widget _buildBillingHistoryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _billingHistory.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppTheme.surfaceBorder),
        itemBuilder: (context, index) {
          final item = _billingHistory[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_outline_rounded,
                      color: AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['plan'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item['date']} • ${item['invoice']}',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['amount'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Receipt ${item['invoice']} downloaded!'),
                            backgroundColor: AppTheme.surfaceLighter,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.download_rounded, size: 13, color: AppTheme.primary),
                          const SizedBox(width: 3),
                          Text(
                            'Receipt',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Update Payment Method Flow ──────────────────────────────
  void _handleUpdatePaymentMethod() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          planLabel: _currentPlanIndex == 1 ? 'Pro Athlete Annual' : 'Pro Athlete Monthly',
          planPrice: _currentPlanIndex == 1 ? '\$199.99/yr' : '\$19.99/mo',
          isUpdatingPaymentMethod: true,
          onPaymentMethodUpdated: (last4, expiry) {
            setState(() {
              _cardLastFour = last4;
              _cardExpiry = expiry;
            });
          },
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _cardLastFour = result['lastFour'] ?? _cardLastFour;
        _cardExpiry = result['expiry'] ?? _cardExpiry;
      });
    }
  }

  // ── Change Plan Bottom Sheet (Reusing PlanCard) ──────────────
  void _showChangePlanSheet() {
    int tempSelectedPlan = _currentPlanIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 18),
              Text(
                'Change Subscription Plan',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Switch your billing interval anytime. Prorated credits apply automatically.',
                style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              // Reused PlanCard components from Go Premium flow
              Row(
                children: [
                  Expanded(
                    child: PlanCard(
                      label: 'Monthly',
                      price: '\$19.99',
                      period: '/month',
                      isSelected: tempSelectedPlan == 0,
                      badge: null,
                      onTap: () => setSheetState(() => tempSelectedPlan = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PlanCard(
                      label: 'Annual',
                      price: '\$199.99',
                      period: '/year',
                      isSelected: tempSelectedPlan == 1,
                      badge: 'Save 33%',
                      onTap: () => setSheetState(() => tempSelectedPlan = 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPlanIndex = tempSelectedPlan;
                      _isCancelled = false;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Plan updated to ${tempSelectedPlan == 1 ? "Annual" : "Monthly"} successfully!',
                        ),
                        backgroundColor: AppTheme.surfaceLighter,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: const Color(0xFF0D0F0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Confirm Plan Change',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Retention Flow (Cancellation Modal) ───────────────────────
  void _showCancelRetentionFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141714),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sentiment_dissatisfied_rounded,
                      color: Colors.amber, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "We'd hate to see you go!",
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Here's what you will lose access to when your current cycle ends:",
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Retention checklist cards
            ..._retentionPerks.asMap().entries.map((entry) {
              final i = entry.key;
              final perk = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        perk['icon'] as IconData,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            perk['title'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            perk['subtitle'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 80 * i), duration: 250.ms);
            }),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLighter,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available_rounded, size: 18, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your access remains 100% active until Oct 14, 2026.',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: const Color(0xFF0D0F0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Keep My Subscription',
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _isCancelled = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Subscription cancelled. You will retain access until Oct 14, 2026.',
                      ),
                      backgroundColor: Color(0xFF2A1E1E),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Confirm Cancellation',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleResumeSubscription() {
    setState(() => _isCancelled = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Auto-renew resumed! Your subscription will continue seamlessly.'),
        backgroundColor: AppTheme.surfaceLighter,
      ),
    );
  }
}
