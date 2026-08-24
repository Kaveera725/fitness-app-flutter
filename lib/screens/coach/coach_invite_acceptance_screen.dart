import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../admin/admin_data.dart';
import 'coach_dashboard_screen.dart';

class CoachInviteAcceptanceScreen extends StatefulWidget {
  final String? inviteToken;
  final String? invitedEmail;
  final String? initialName;
  final String? initialSpecialty;

  const CoachInviteAcceptanceScreen({
    super.key,
    this.inviteToken = 'fp_inv_token_98432a',
    this.invitedEmail = 'jordan.coach@fitpulse.app',
    this.initialName = 'Jordan Mitchell',
    this.initialSpecialty = 'HIIT',
  });

  @override
  State<CoachInviteAcceptanceScreen> createState() =>
      _CoachInviteAcceptanceScreenState();
}

class _CoachInviteAcceptanceScreenState
    extends State<CoachInviteAcceptanceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController(text: '5');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<String> _specialties = [
    'Strength',
    'Yoga',
    'Cardio',
    'HIIT',
    'Nutrition',
  ];

  late String _selectedSpecialty;
  int _selectedAvatarIndex = 0;
  bool _isLoading = false;
  bool _isSubmitted = false;

  final List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.invitedEmail);
    _selectedSpecialty = _specialties.contains(widget.initialSpecialty)
        ? widget.initialSpecialty!
        : 'HIIT';
    _bioController.text =
        'Passionate certified trainer committed to helping trainees build strength, stamina, and sustainable wellness habits.';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate invite token verification & account registration
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    // Update the local admin service so the coach shows up in the roster
    AdminDataService.instance.inviteCoach(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      specialty: _selectedSpecialty,
      bio: _bioController.text.trim(),
    );

    setState(() {
      _isLoading = false;
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : AppTheme.textLight,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'FitPulse',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'COACH INVITE',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentOrange,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isSubmitted
              ? _buildSuccessView(theme, isDark)
              : _buildFormView(theme, isDark),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FORM VIEW
  // ---------------------------------------------------------------------------
  Widget _buildFormView(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('invite_form'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Banner
                _buildHeroHeader(theme)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.08, end: 0),

                const SizedBox(height: 28),

                // Section 1: Profile Photo
                _buildAvatarPicker(theme, isDark)
                    .animate()
                    .fadeIn(delay: 150.ms),

                const SizedBox(height: 24),

                // Section 2: Coach Information
                Text(
                  'Coach Profile Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 14),

                // Full Name
                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g. Jordan Mitchell',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 250.ms),

                const SizedBox(height: 16),

                // Email (Read-only / verified from invite link)
                CustomTextField(
                  label: 'Invited Email Address',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  readOnly: true,
                  helperText: '🔒 Linked to your secure coach invitation token',
                ).animate().fadeIn(delay: 280.ms),

                const SizedBox(height: 16),

                // Specialty Dropdown
                _buildSpecialtyDropdown(theme, isDark)
                    .animate()
                    .fadeIn(delay: 310.ms),

                const SizedBox(height: 16),

                // Years of Experience
                CustomTextField(
                  label: 'Years of Experience',
                  hint: 'e.g. 5',
                  controller: _experienceController,
                  prefixIcon: Icons.timeline_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your years of experience';
                    }
                    final years = int.tryParse(v);
                    if (years == null || years < 0 || years > 50) {
                      return 'Please enter a valid number of years (0 - 50)';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 340.ms),

                const SizedBox(height: 16),

                // Short Bio
                CustomTextField(
                  label: 'Short Bio / Coaching Philosophy',
                  hint: 'Describe your training style and background...',
                  controller: _bioController,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 4,
                  minLines: 3,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please write a brief coach bio';
                    }
                    if (v.trim().length < 20) {
                      return 'Bio must be at least 20 characters long';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 370.ms),

                const SizedBox(height: 28),

                // Section 3: Credentials
                Text(
                  'Set Your Password',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 6),
                Text(
                  'Create credentials to access the FitPulse Coach Web & Mobile App.',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ).animate().fadeIn(delay: 420.ms),
                const SizedBox(height: 14),

                // Password
                CustomTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 450.ms),

                const SizedBox(height: 16),

                // Confirm Password
                CustomTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_reset_rounded,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 480.ms),

                const SizedBox(height: 32),

                // Gradient CTA Button
                GradientButton(
                  text: 'Join Coach Community',
                  icon: const Icon(Icons.fitness_center_rounded,
                      color: Colors.white, size: 20),
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ).animate().fadeIn(delay: 520.ms).scale(
                      begin: const Offset(0.96, 0.96),
                      end: const Offset(1, 1),
                    ),

                const SizedBox(height: 16),

                // Terms hint
                Center(
                  child: Text(
                    'By joining, you agree to the FitPulse Coach Terms & Code of Conduct.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF311B92), // Deep Indigo
            AppTheme.primary, // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentGreen.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.mark_email_read_rounded,
                        color: AppTheme.accentGreen, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'OFFICIAL INVITATION',
                      style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.active(label: 'Verified Link'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "You've been invited to join FitPulse as a Coach",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your trainer profile and set your login credentials to start mentoring dedicated members.',
            style: GoogleFonts.manrope(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPicker(ThemeData theme, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.camera_alt_outlined,
                    color: AppTheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Profile Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Select an avatar preset or tap the camera badge to customize.',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Main Preview & Presets Row
            Row(
              children: [
                // Big Avatar Preview
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppTheme.primary.withOpacity(0.2),
                      backgroundImage:
                          NetworkImage(_presetAvatars[_selectedAvatarIndex]),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Presets
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presetAvatars.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final isSelected = _selectedAvatarIndex == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAvatarIndex = i;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(_presetAvatars[i]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtyDropdown(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specialty / Category',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222222) : const Color(0xFFF7F7FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSpecialty,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.primary),
              dropdownColor:
                  isDark ? const Color(0xFF222222) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              items: _specialties.map((spec) {
                IconData icon;
                switch (spec) {
                  case 'Strength':
                    icon = Icons.fitness_center_rounded;
                    break;
                  case 'Yoga':
                    icon = Icons.self_improvement_rounded;
                    break;
                  case 'Cardio':
                    icon = Icons.directions_run_rounded;
                    break;
                  case 'HIIT':
                    icon = Icons.local_fire_department_rounded;
                    break;
                  case 'Nutrition':
                    icon = Icons.restaurant_rounded;
                    break;
                  default:
                    icon = Icons.sports_gymnastics_rounded;
                }

                return DropdownMenuItem<String>(
                  value: spec,
                  child: Row(
                    children: [
                      Icon(icon, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        spec,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSpecialty = val;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SUCCESS VIEW
  // ---------------------------------------------------------------------------
  Widget _buildSuccessView(ThemeData theme, bool isDark) {
    final name = _nameController.text.trim();
    final specialty = _selectedSpecialty;
    final exp = _experienceController.text.trim();
    final avatarUrl = _presetAvatars[_selectedAvatarIndex];

    return Center(
      key: const ValueKey('success_view'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Celebration Badge
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.accentGreen,
                        Color(0xFF00B0FF),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGreen.withOpacity(0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  'Welcome to the\nFitPulse Coach Community!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  'Your profile and credentials have been verified. You can now build routines and coach members.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 28),

              // Coach Profile Summary Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        color: AppTheme.accentGreen, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$specialty • $exp yrs exp',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusBadge.active(label: 'Active Coach'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      _buildPerkRow(Icons.groups_rounded,
                          'Access to assigned 1-on-1 trainees'),
                      _buildPerkRow(Icons.fitness_center_rounded,
                          'Custom workout routine builder & library'),
                      _buildPerkRow(Icons.insights_rounded,
                          'Live trainee performance analytics'),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 250.ms),

              const SizedBox(height: 32),

              // Go to Coach Dashboard CTA
              GradientButton(
                text: 'Go to Coach Dashboard',
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoachDashboardScreen(
                        coachName: name,
                        coachSpecialty: specialty,
                        avatarUrl: avatarUrl,
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 350.ms).scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerkRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.accentGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
