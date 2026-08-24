import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import 'admin_data.dart';
import 'admin_login_screen.dart';
import 'manage_coaches_screen.dart';
import 'manage_users_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _adminData = AdminDataService.instance;

  @override
  void initState() {
    super.initState();
    _adminData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _adminData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Admin Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of the Admin Console?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Admin Bar
              _buildTopBar(theme, isDark),

              const SizedBox(height: 24),

              // Welcome Admin Hero Card
              _buildWelcomeHero(theme),

              const SizedBox(height: 28),

              // Section Header: Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Platform Overview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Live Sync',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 16),

              // 4 Summary Metrics Cards (Grid)
              _buildSummaryGrid(theme),

              const SizedBox(height: 28),

              // Section Header: Management Quick Actions
              Text(
                'Management Hub',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              // Management Action Cards
              _buildManagementCards(context, theme, isDark),

              const SizedBox(height: 28),

              // Recent Audit / Platform Activity Feed
              _buildRecentActivity(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDark],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Icon(Icons.shield_rounded, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'FitPulse',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CONSOLE',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Super Admin Workspace',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: _handleLogout,
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          tooltip: 'Admin Logout',
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildWelcomeHero(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 18,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified, color: AppTheme.accentGreen, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'SYSTEM OPERATIONAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'v2.4 Pro',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome back, Administrator',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Manage coaches, track member growth, and monitor live subscriptions in real-time.',
            style: GoogleFonts.manrope(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSummaryGrid(ThemeData theme) {
    final totalUsers = _adminData.totalUsers;
    final totalCoaches = _adminData.totalCoaches;
    final premiumSubs = _adminData.activePremiumSubscriptions;
    final pendingInvites = _adminData.pendingCoachesCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 550;
        final cardWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildMetricCard(
                context: context,
                title: 'Total Users',
                value: '$totalUsers',
                subtext: '10 active accounts',
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF2979FF),
                delayMs: 100,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageUsersScreen()),
                  );
                },
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildMetricCard(
                context: context,
                title: 'Total Coaches',
                value: '$totalCoaches',
                subtext: '${_adminData.activeCoachesCount} active on roster',
                icon: Icons.sports_gymnastics_rounded,
                color: AppTheme.accentOrange,
                delayMs: 150,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageCoachesScreen()),
                  );
                },
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildMetricCard(
                context: context,
                title: 'Premium Subs',
                value: '$premiumSubs',
                subtext: '60% conversion rate',
                icon: Icons.workspace_premium_rounded,
                color: AppTheme.accentGreen,
                delayMs: 200,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ManageUsersScreen(initialFilter: 'Premium')),
                  );
                },
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildMetricCard(
                context: context,
                title: 'Pending Invites',
                value: '$pendingInvites',
                subtext: 'Awaiting onboarding',
                icon: Icons.mark_email_unread_rounded,
                color: const Color(0xFFFF9100),
                delayMs: 250,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageCoachesScreen(
                            initialFilter: 'Pending')),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required int delayMs,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtext,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildManagementCards(
      BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Manage Coaches Card
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ManageCoachesScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.sports_rounded,
                      color: AppTheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Manage Coaches',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              label: '${_adminData.totalCoaches} Roster',
                              type: BadgeType.custom,
                              customColor: AppTheme.primary,
                              fontSize: 11,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invite new trainers, manage specialties & roster',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: 12),

        // Manage Users Card
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.group_rounded,
                      color: Color(0xFF00C853),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Manage Users',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              label: '${_adminData.totalUsers} Members',
                              type: BadgeType.custom,
                              customColor: const Color(0xFF00C853),
                              fontSize: 11,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Search member database, view plans & details',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildRecentActivity(ThemeData theme, bool isDark) {
    final activities = [
      {
        'title': 'New Coach Invitation Sent',
        'subtitle': 'Sophia Patel (Nutrition) invited as Coach',
        'time': '10 mins ago',
        'icon': Icons.mail_outline_rounded,
        'color': AppTheme.accentOrange,
      },
      {
        'title': 'Premium Plan Upgrade',
        'subtitle': 'Sarah Jenkins subscribed to 12-month tier',
        'time': '42 mins ago',
        'icon': Icons.star_rounded,
        'color': AppTheme.accentGreen,
      },
      {
        'title': 'Coach Onboarding Completed',
        'subtitle': 'Elena Rostova verified credentials',
        'time': '2 hours ago',
        'icon': Icons.verified_user_rounded,
        'color': AppTheme.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (ctx, i) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final act = activities[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (act['color'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(act['icon'] as IconData,
                      color: act['color'] as Color, size: 20),
                ),
                title: Text(
                  act['title'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  act['subtitle'] as String,
                  style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey),
                ),
                trailing: Text(
                  act['time'] as String,
                  style: GoogleFonts.manrope(fontSize: 11, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 350.ms);
  }
}
