import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness/theme/app_theme.dart';
import 'package:fitness/widgets/gradient_button.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planLabel;
  final String planPrice;

  const PaymentScreen({
    super.key,
    required this.planLabel,
    required this.planPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Integrate Stripe (or other payment gateway) here.
    // Example with Stripe Flutter SDK:
    // final paymentMethod = await Stripe.instance.createPaymentMethod(
    //   params: PaymentMethodParams.card(
    //     paymentMethodData: PaymentMethodData(
    //       billingDetails: BillingDetails(name: _nameController.text),
    //     ),
    //   ),
    // );
    // Then send paymentMethod.id to your backend to create a PaymentIntent.

    // Simulate network delay for UI demo
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0533), Color(0xFF311B92), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── App Bar ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Payment',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Plan Summary ──────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppTheme.primary.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.workspace_premium_rounded,
                                  color: Color(0xFFFFD700), size: 28),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FitPulse ${widget.planLabel} Plan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.planPrice,
                                    style: GoogleFonts.manrope(
                                        fontSize: 13, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.2),

                        const SizedBox(height: 28),

                        // ── Quick Pay Buttons ─────────────────────────────
                        // TODO: Replace with real provider buttons (Apple Pay / Google Pay)
                        // using the pay package: https://pub.dev/packages/pay
                        _QuickPayButton(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Continue with Google Pay',
                          onTap: () {
                            // TODO: Integrate Google Pay
                          },
                        ).animate().fadeIn(delay: 100.ms),

                        const SizedBox(height: 12),

                        _QuickPayButton(
                          icon: Icons.apple_rounded,
                          label: 'Continue with Apple Pay',
                          onTap: () {
                            // TODO: Integrate Apple Pay
                          },
                        ).animate().fadeIn(delay: 160.ms),

                        const SizedBox(height: 24),

                        // ── Divider ───────────────────────────────────────
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or pay with card',
                                  style: GoogleFonts.manrope(
                                      fontSize: 12, color: Colors.white38)),
                            ),
                            const Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Card Fields ───────────────────────────────────
                        _CardField(
                          controller: _nameController,
                          label: 'Cardholder Name',
                          hint: 'John Doe',
                          icon: Icons.person_outline_rounded,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ).animate().fadeIn(delay: 220.ms),

                        const SizedBox(height: 16),

                        _CardField(
                          controller: _cardNumberController,
                          label: 'Card Number',
                          hint: '1234 5678 9012 3456',
                          icon: Icons.credit_card_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                            _CardNumberFormatter(),
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.replaceAll(' ', '').length != 16) {
                              return 'Enter a valid 16-digit card number';
                            }
                            return null;
                          },
                        ).animate().fadeIn(delay: 280.ms),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _CardField(
                                controller: _expiryController,
                                label: 'Expiry',
                                hint: 'MM/YY',
                                icon: Icons.calendar_today_rounded,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  _ExpiryFormatter(),
                                ],
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ).animate().fadeIn(delay: 340.ms),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _CardField(
                                controller: _cvvController,
                                label: 'CVV',
                                hint: '•••',
                                icon: Icons.lock_outline_rounded,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (v.length < 3) return 'Invalid CVV';
                                  return null;
                                },
                              ).animate().fadeIn(delay: 400.ms),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Security note
                        Row(
                          children: [
                            const Icon(Icons.lock_rounded,
                                size: 14, color: Colors.white38),
                            const SizedBox(width: 6),
                            Text(
                              'Your payment info is encrypted and secure.',
                              style: GoogleFonts.manrope(
                                  fontSize: 11, color: Colors.white38),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Pay Button ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : GradientButton(
                        text: 'Pay ${widget.planPrice}',
                        onPressed: _handlePayment,
                        icon: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 20),
                      ).animate().fadeIn(delay: 460.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Pay Button ─────────────────────────────────────────────────────────

class _QuickPayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickPayButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ── Card Form Field ──────────────────────────────────────────────────────────

class _CardField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;

  const _CardField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.manrope(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.manrope(color: Colors.white38, fontSize: 14),
            prefixIcon: Icon(icon, color: AppTheme.primaryLight, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppTheme.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.8),
            ),
            errorStyle: GoogleFonts.manrope(fontSize: 11, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}

// ── Input Formatters ─────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
