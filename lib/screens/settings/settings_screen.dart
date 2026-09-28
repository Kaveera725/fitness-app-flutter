import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';
import '../subscription/manage_subscription_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isGoogleUser;

  const SettingsScreen({
    super.key,
    this.isGoogleUser = false,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preferences State
  bool _isMetric = true;
  bool _isDarkMode = true;
  String _selectedLanguage = 'English (US)';

  // Notifications State
  bool _pushNotifications = true;
  bool _coachMessages = true;
  bool _achievementAlerts = true;
  bool _subscriptionReminders = true;
  bool _marketingEmails = false;

  // Privacy State
  bool _showProfileInReviews = true;
  bool _makeProgressVisibleToCoach = true;

  final List<String> _languages = [
    'English (US)',
    'English (UK)',
    'Spanish (Español)',
    'French (Français)',
    'German (Deutsch)',
    'Japanese (日本語)',
  ];

  @override
  Widget build(BuildContext context) {
    final user = ApiService.instance.currentUser;
    final userEmail = user?.email.isNotEmpty == true ? user!.email : 'athlete@fitpulse.io';

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
          'Settings',
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
            // 1. Account Section
            _buildSectionHeader('Account', Icons.person_outline_rounded),
            _buildCardGroup([
              _buildSettingTile(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                subtitle: 'Update your security credentials',
                onTap: _showChangePasswordDialog,
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.mail_outline_rounded,
                title: 'Change Email',
                subtitle: userEmail,
                onTap: () => _showChangeEmailDialog(userEmail),
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.g_mobiledata_rounded,
                title: 'Google Account',
                subtitle: widget.isGoogleUser
                    ? 'Connected as $userEmail'
                    : 'Link your Google account for single sign-on',
                trailing: widget.isGoogleUser
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Linked',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google Account link simulated!'),
                              backgroundColor: AppTheme.surfaceLighter,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.6)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Connect',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 50.ms),

            const SizedBox(height: 24),

            // 2. Preferences Section
            _buildSectionHeader('Preferences', Icons.tune_rounded),
            _buildCardGroup([
              _buildSwitchTile(
                icon: Icons.straighten_rounded,
                title: 'Units of Measurement',
                subtitle: _isMetric ? 'Metric (kg, cm, km)' : 'Imperial (lbs, ft, mi)',
                value: _isMetric,
                onChanged: (val) => setState(() => _isMetric = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: _isDarkMode ? 'Athletic High-Contrast Dark' : 'Standard Light Mode',
                value: _isDarkMode,
                onChanged: (val) {
                  setState(() => _isDarkMode = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isDarkMode ? 'Dark theme enabled' : 'Light theme selected'),
                      backgroundColor: AppTheme.surfaceLighter,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.language_rounded,
                title: 'App Language',
                subtitle: _selectedLanguage,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedLanguage.split(' ').first,
                      style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textSecondary),
                  ],
                ),
                onTap: _showLanguageSelector,
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // 3. Notifications Section
            _buildSectionHeader('Notifications', Icons.notifications_none_rounded),
            _buildCardGroup([
              _buildSwitchTile(
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                subtitle: 'Daily check-ins & workout reminders',
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Coach Messages',
                subtitle: 'Direct messages & form check feedback',
                value: _coachMessages,
                onChanged: (val) => setState(() => _coachMessages = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.emoji_events_outlined,
                title: 'Achievement Alerts',
                subtitle: 'Milestones, streaks, and PRs',
                value: _achievementAlerts,
                onChanged: (val) => setState(() => _achievementAlerts = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.schedule_rounded,
                title: 'Subscription Reminders',
                subtitle: 'Billing updates & renewal notices',
                value: _subscriptionReminders,
                onChanged: (val) => setState(() => _subscriptionReminders = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.mark_email_read_outlined,
                title: 'Marketing & Tips',
                subtitle: 'Weekly digest & workout tips',
                value: _marketingEmails,
                onChanged: (val) => setState(() => _marketingEmails = val),
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 150.ms),

            const SizedBox(height: 24),

            // 4. Privacy Section
            _buildSectionHeader('Privacy & Permissions', Icons.security_rounded),
            _buildCardGroup([
              _buildSwitchTile(
                icon: Icons.rate_review_outlined,
                title: 'Show Profile in Coach Reviews',
                subtitle: 'Display your athlete name on public testimonials',
                value: _showProfileInReviews,
                onChanged: (val) => setState(() => _showProfileInReviews = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.visibility_outlined,
                title: 'Make Progress Visible to Coach',
                subtitle: 'Allow your assigned coach to review logs & metrics',
                value: _makeProgressVisibleToCoach,
                onChanged: (val) => setState(() => _makeProgressVisibleToCoach = val),
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 200.ms),

            const SizedBox(height: 24),

            // 5. Subscription Section
            _buildSectionHeader('Subscription', Icons.workspace_premium_rounded),
            _buildCardGroup([
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: AppTheme.accentPurple,
                            size: 24,
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
                                    'Pro Athlete Plan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'ACTIVE',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Renews automatically on Oct 14, 2026',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ManageSubscriptionScreen()),
                          );
                        },
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        label: const Text('Manage Subscription'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceLighter,
                          foregroundColor: AppTheme.primary,
                          elevation: 0,
                          side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 250.ms),

            const SizedBox(height: 24),

            // 6. Support & Legal Section
            _buildSectionHeader('Support & Legal', Icons.help_outline_rounded),
            _buildCardGroup([
              _buildSettingTile(
                icon: Icons.help_center_outlined,
                title: 'Help Center & FAQ',
                subtitle: 'Guides, tutorials and fitness FAQs',
                onTap: _showHelpCenterSheet,
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.support_agent_rounded,
                title: 'Contact Support',
                subtitle: 'Reach out to FitPulse team 24/7',
                onTap: _showContactSupportSheet,
              ),
              _buildDivider(),
              _buildSettingTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service & Privacy Policy',
                subtitle: 'Review legal terms & data policy',
                onTap: _showTermsDialog,
              ),
              _buildDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'App Version',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      'v2.4.1 (Build 2026.09)',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ]).animate().fadeIn(duration: 300.ms, delay: 300.ms),

            const SizedBox(height: 28),

            // 7. Danger Zone
            _buildSectionHeader('Danger Zone', Icons.warning_amber_rounded, color: Colors.redAccent),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1313),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4), width: 1),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.logout_rounded,
                    title: 'Log Out',
                    subtitle: 'Sign out of your athlete session',
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: _showLogoutDialog,
                  ),
                  Divider(height: 1, color: Colors.redAccent.withValues(alpha: 0.2)),
                  _buildSettingTile(
                    icon: Icons.delete_forever_rounded,
                    title: 'Delete Account',
                    subtitle: 'Permanently erase all fitness data and history',
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: _showDeleteAccountDialog,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, {Color? color}) {
    final effectiveColor = color ?? AppTheme.textSecondary;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: effectiveColor),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.surfaceBorder,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
  }) {
    final effectiveIconColor = iconColor ?? AppTheme.primary;
    final effectiveTextColor = textColor ?? AppTheme.textDark;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: effectiveIconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: effectiveIconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: effectiveTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing
          else if (onTap != null)
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textSecondary),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
            activeTrackColor: AppTheme.primary.withValues(alpha: 0.35),
            inactiveTrackColor: AppTheme.surfaceLighter,
            inactiveThumbColor: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  // ── Dialogs & Action Sheets ──────────────────────────────
  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureText = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
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
              const SizedBox(height: 16),
              Text(
                'Change Password',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your password must be at least 8 characters long.',
                style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 18),
              _buildModalTextField(
                controller: currentPasswordController,
                label: 'Current Password',
                obscureText: obscureText,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: 12),
              _buildModalTextField(
                controller: newPasswordController,
                label: 'New Password',
                obscureText: obscureText,
                prefixIcon: Icons.vpn_key_outlined,
              ),
              const SizedBox(height: 12),
              _buildModalTextField(
                controller: confirmPasswordController,
                label: 'Confirm New Password',
                obscureText: obscureText,
                prefixIcon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password updated successfully!'),
                        backgroundColor: AppTheme.surfaceLighter,
                      ),
                    );
                  },
                  child: const Text('Update Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangeEmailDialog(String currentEmail) {
    final emailController = TextEditingController(text: currentEmail);
    final passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
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
            const SizedBox(height: 16),
            Text(
              'Change Email Address',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We will send a verification link to your new address.',
              style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 18),
            _buildModalTextField(
              controller: emailController,
              label: 'New Email Address',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 12),
            _buildModalTextField(
              controller: passwordController,
              label: 'Current Password',
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification link sent to new email!'),
                      backgroundColor: AppTheme.surfaceLighter,
                    ),
                  );
                },
                child: const Text('Send Verification'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            const SizedBox(height: 16),
            Text(
              'Select Language',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _languages.length,
                separatorBuilder: (context, index) => const Divider(color: AppTheme.surfaceBorder, height: 1),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = lang == _selectedLanguage;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      lang,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppTheme.primary : AppTheme.textDark,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded, color: AppTheme.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedLanguage = lang);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpCenterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FitPulse Help Center',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 14),
            _buildFaqItem('How do I log workouts?', 'Go to the Workout tab, pick a routine, and tap Start Workout.'),
            _buildFaqItem('Can my coach view my logs?', 'Yes, when enabled under Privacy > Make progress visible to coach.'),
            _buildFaqItem('How do streaks work?', 'Complete at least 1 workout or log activity daily to maintain your streak.'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String q, String a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary)),
          const SizedBox(height: 2),
          Text(a, style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  void _showContactSupportSheet() {
    final messageController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Athlete Support',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Describe your issue and our team will get back within 24 hours.',
              style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 4,
              style: GoogleFonts.manrope(color: AppTheme.textDark),
              decoration: const InputDecoration(
                hintText: 'Enter your inquiry or feedback here...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support ticket submitted. Thank you!'),
                      backgroundColor: AppTheme.surfaceLighter,
                    ),
                  );
                },
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        title: Text(
          'Terms & Privacy Policy',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
        content: SizedBox(
          height: 240,
          child: SingleChildScrollView(
            child: Text(
              'FitPulse is committed to protecting your health and fitness privacy. '
              'All telemetry, workout logs, heart rate streams, and coach messages are encrypted '
              'in transit and at rest.\n\n'
              'By utilizing FitPulse, you agree to fair use of personalized coach services and '
              'subscription terms. You retain total control of your athlete profile and can export or '
              'permanently wipe your records at any time via the Danger Zone settings.',
              style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
        content: Text(
          'Are you sure you want to log out of your FitPulse account?',
          style: GoogleFonts.manrope(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.manrope(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1313),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              'Delete Account?',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.redAccent),
            ),
          ],
        ),
        content: Text(
          'This action is irreversible. All workout history, coach chats, milestone achievements, '
          'and active subscriptions will be permanently purged.',
          style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textDark, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.manrope(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Permanently Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(color: AppTheme.textSecondary, fontSize: 13),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppTheme.primary, size: 20) : null,
      ),
    );
  }
}
