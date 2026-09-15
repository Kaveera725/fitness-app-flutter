import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'client_detail_screen.dart';
import 'meal_plans/meal_plan_requests_screen.dart';
import 'my_clients_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Local Data Models
// ─────────────────────────────────────────────────────────────────────────────

class _Client {
  final String name;
  final String avatarUrl;
  final double weeklyProgress; // 0.0–1.0
  final String goal;
  final String lastSeen;
  final String plan;

  const _Client({
    required this.name,
    required this.avatarUrl,
    required this.weeklyProgress,
    required this.goal,
    required this.lastSeen,
    required this.plan,
  });
}

class _AttentionItem {
  final String type; // 'meal_request' | 'checkin'
  final String clientName;
  final String avatarUrl;
  final String subtitle;
  final String timeAgo;
  final String actionLabel;

  const _AttentionItem({
    required this.type,
    required this.clientName,
    required this.avatarUrl,
    required this.subtitle,
    required this.timeAgo,
    required this.actionLabel,
  });
}

class _Session {
  final String clientName;
  final String avatarUrl;
  final String time;
  final String type;

  const _Session({
    required this.clientName,
    required this.avatarUrl,
    required this.time,
    required this.type,
  });
}

class _ActivityItem {
  final String clientName;
  final String avatarUrl;
  final String action;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;

  const _ActivityItem({
    required this.clientName,
    required this.avatarUrl,
    required this.action,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// CoachHomeScreen
// ─────────────────────────────────────────────────────────────────────────────

class CoachHomeScreen extends StatefulWidget {
  final String coachName;
  final VoidCallback? onViewAllClients;
  const CoachHomeScreen({
    super.key,
    this.coachName = 'Marcus',
    this.onViewAllClients,
  });

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  // ── Dummy Data ──────────────────────────────────────────────────────────────
  final List<_Client> _clients = const [
    _Client(
      name: 'Sarah Jenkins',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      weeklyProgress: 0.85,
      goal: 'Hypertrophy',
      plan: '12-Week Hypertrophy',
      lastSeen: 'Today, 9:30 AM',
    ),
    _Client(
      name: 'Alexander Wright',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      weeklyProgress: 0.40,
      goal: 'Conditioning',
      plan: 'Athletic Conditioning',
      lastSeen: 'Yesterday',
    ),
    _Client(
      name: 'Olivia Martinez',
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
      weeklyProgress: 0.95,
      goal: 'Strength',
      plan: 'Strength Foundation',
      lastSeen: '2h ago',
    ),
    _Client(
      name: 'James Liu',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      weeklyProgress: 0.60,
      goal: 'Fat Loss',
      plan: 'Fat Loss Protocol',
      lastSeen: '3d ago',
    ),
    _Client(
      name: 'Priya Nair',
      avatarUrl: 'https://i.pravatar.cc/150?img=56',
      weeklyProgress: 0.25,
      goal: 'Endurance',
      plan: 'Endurance Base',
      lastSeen: '5d ago',
    ),
    _Client(
      name: 'Tom Reeves',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      weeklyProgress: 0.70,
      goal: 'Mobility',
      plan: 'Mobility & Recovery',
      lastSeen: 'Today',
    ),
  ];

  final List<_AttentionItem> _attentionItems = const [
    _AttentionItem(
      type: 'meal_request',
      clientName: 'Alexander Wright',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      subtitle: 'Requested a new meal plan (Keto / 2200 kcal)',
      timeAgo: '2h ago',
      actionLabel: 'Review',
    ),
    _AttentionItem(
      type: 'checkin',
      clientName: 'Priya Nair',
      avatarUrl: 'https://i.pravatar.cc/150?img=56',
      subtitle: 'Overdue check-in: No updates for 5 days',
      timeAgo: '5d ago',
      actionLabel: 'Message',
    ),
    _AttentionItem(
      type: 'meal_request',
      clientName: 'Tom Reeves',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      subtitle: 'Meal plan request pending (High-Protein)',
      timeAgo: '1d ago',
      actionLabel: 'Review',
    ),
  ];

  final List<_Session> _sessions = const [
    _Session(
      clientName: 'Sarah Jenkins',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      time: '09:00 AM',
      type: 'Strength & Technique Review',
    ),
    _Session(
      clientName: 'Olivia Martinez',
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
      time: '11:30 AM',
      type: 'Weekly Nutrition Check-in',
    ),
    _Session(
      clientName: 'James Liu',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      time: '02:00 PM',
      type: 'HIIT & Conditioning Session',
    ),
  ];

  final List<_ActivityItem> _activities = const [
    _ActivityItem(
      clientName: 'Sarah Jenkins',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      action: 'completed Day 3 Upper Body Hypertrophy',
      timeAgo: '15m ago',
      icon: Icons.fitness_center_rounded,
      iconColor: AppTheme.accentGreen,
    ),
    _ActivityItem(
      clientName: 'Marcus Vance',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      action: 'logged lunch: Grilled Salmon with Quinoa',
      timeAgo: '45m ago',
      icon: Icons.restaurant_rounded,
      iconColor: AppTheme.accentOrange,
    ),
    _ActivityItem(
      clientName: 'Emma Watson',
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
      action: 'submitted weekly check-in (-1.2 kg, 88% compliance)',
      timeAgo: '2h ago',
      icon: Icons.fact_check_rounded,
      iconColor: Color(0xFF64B5F6),
    ),
    _ActivityItem(
      clientName: 'Alexander Wright',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      action: 'finished 5.2 km morning aerobic run',
      timeAgo: '4h ago',
      icon: Icons.directions_run_rounded,
      iconColor: Color(0xFF81C784),
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _progressColor(double p) {
    if (p >= 0.75) return AppTheme.accentGreen;
    if (p >= 0.40) return AppTheme.accentOrange;
    return Colors.redAccent;
  }

  void _openClientModal(_Client client) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(client.avatarUrl),
                    backgroundColor: AppTheme.surfaceLighter,
                    onBackgroundImageError: (_, _) {},
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          client.plan,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _progressColor(client.weeklyProgress).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(client.weeklyProgress * 100).toInt()}% Goal',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _progressColor(client.weeklyProgress),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _clientStat('Goal', client.goal),
                    _clientStat('Consistency', '${(client.weeklyProgress * 100).toInt()}%'),
                    _clientStat('Last Seen', client.lastSeen),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppTheme.surfaceBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Chat opened with ${client.name}'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppTheme.textDark),
                      label: Text(
                        'Message',
                        style: GoogleFonts.poppins(color: AppTheme.textDark, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppTheme.accentGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Routine editor opened for ${client.name}'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.fitness_center_rounded, size: 18, color: AppTheme.backgroundDark),
                      label: Text(
                        'Assign Routine',
                        style: GoogleFonts.poppins(color: AppTheme.backgroundDark, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientDetailScreen(
                          client: ClientItem(
                            id: 'c_${client.name.toLowerCase().replaceAll(' ', '_')}',
                            name: client.name,
                            avatarUrl: client.avatarUrl,
                            goal: client.goal,
                            plan: client.plan,
                            adherence: client.weeklyProgress,
                            status: client.weeklyProgress >= 0.75
                                ? ClientStatus.onTrack
                                : ClientStatus.fallingBehind,
                            lastActive: client.lastSeen,
                            weight: '62.5 kg',
                            targetWeight: '60.0 kg',
                            completedWorkouts: 4,
                            targetWorkouts: 4,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_rounded, size: 16, color: AppTheme.accentGreen),
                  label: Text(
                    'View Full Client Profile & Stats',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _clientStat(String title, String val) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showQuickActionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
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
                'Coach Quick Actions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage workouts, nutrition, and member communications',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              _quickActionTile(
                icon: Icons.fitness_center_rounded,
                iconColor: AppTheme.accentGreen,
                title: 'Assign Workout',
                subtitle: 'Push custom routine or template to a trainee',
                onTap: () {
                  Navigator.pop(ctx);
                  _openAssignWorkoutDialog();
                },
              ),
              const SizedBox(height: 12),
              _quickActionTile(
                icon: Icons.restaurant_menu_rounded,
                iconColor: AppTheme.accentOrange,
                title: 'New Meal Plan',
                subtitle: 'Review pending requests and build user nutrition plans',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MealPlanRequestsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _quickActionTile(
                icon: Icons.campaign_rounded,
                iconColor: const Color(0xFF64B5F6),
                title: 'Broadcast Message',
                subtitle: 'Send motivational announcement to all active clients',
                onTap: () {
                  Navigator.pop(ctx);
                  _openBroadcastDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLighter,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
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
                      fontWeight: FontWeight.w700,
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  void _openAssignWorkoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Assign Workout Routine',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select client to push routine:',
              style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            ..._clients.take(3).map(
                  (c) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(c.avatarUrl),
                      radius: 16,
                      onBackgroundImageError: (_, _) {},
                    ),
                    title: Text(c.name, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textDark)),
                    subtitle: Text(c.goal, style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Routine assigned to ${c.name}!'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      },
                      child: Text('Assign', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.backgroundDark)),
                    ),
                  ),
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _openBroadcastDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Broadcast Message',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This message will be sent to all 6 active clients in your roster.',
              style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g., Remember to hydrate and hit your protein goals today! 💪',
                hintStyle: GoogleFonts.manrope(color: AppTheme.textSecondary, fontSize: 12),
                filled: true,
                fillColor: AppTheme.surfaceLighter,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Broadcast sent to all 6 clients!'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            child: Text('Send Broadcast', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppTheme.backgroundDark)),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickActionsSheet,
        backgroundColor: AppTheme.accentGreen,
        icon: const Icon(Icons.bolt_rounded, color: AppTheme.backgroundDark),
        label: Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppTheme.backgroundDark,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: _buildHeader()),

            // Stat Row
            SliverToBoxAdapter(
              child: _buildStatRow()
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(begin: 0.15, end: 0),
            ),

            // Needs Attention
            SliverToBoxAdapter(
              child: _sectionHeader(
                'Needs Your Attention',
                badge: '${_attentionItems.length}',
              ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _AttentionRow(
                  item: _attentionItems[i],
                  index: i,
                  onAction: _attentionItems[i].type == 'meal_request'
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MealPlanRequestsScreen(),
                            ),
                          )
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Chat opened with ${_attentionItems[i].clientName}'),
                              backgroundColor: AppTheme.accentGreen,
                            ),
                          );
                        },
                ),
                childCount: _attentionItems.length,
              ),
            ),

            // My Clients
            SliverToBoxAdapter(
              child: _sectionHeader(
                'My Clients',
                trailingLabel: 'See All',
                onTrailing: widget.onViewAllClients ??
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyClientsScreen(coachName: widget.coachName),
                          ),
                        ),
              ).animate().fadeIn(delay: 350.ms, duration: 350.ms),
            ),
            SliverToBoxAdapter(
              child: _buildClientsRow()
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideX(begin: 0.1, end: 0),
            ),

            // Today's Sessions
            SliverToBoxAdapter(
              child: _sectionHeader("Today's Sessions")
                  .animate()
                  .fadeIn(delay: 450.ms, duration: 350.ms),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _SessionRow(session: _sessions[i], index: i),
                childCount: _sessions.length,
              ),
            ),

            // Recent Activity Section
            SliverToBoxAdapter(
              child: _sectionHeader('Recent Activity')
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 350.ms),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ActivityRow(activity: _activities[i], index: i),
                childCount: _activities.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Coach ${widget.coachName}',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                // Rating badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.accentGreen.withValues(alpha: 0.30),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: AppTheme.accentGreen, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 Rating',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Avatar with online dot
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentGreen, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=3',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppTheme.surfaceLighter,
                      child: const Icon(Icons.person_rounded,
                          color: AppTheme.textSecondary, size: 28),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.backgroundDark, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
    );
  }

  // ── Stat Row ────────────────────────────────────────────────────────────────
  Widget _buildStatRow() {
    final stats = [
      {
        'icon': Icons.people_alt_rounded,
        'value': '6',
        'label': 'Active\nClients',
        'color': AppTheme.accentGreen,
      },
      {
        'icon': Icons.inbox_rounded,
        'value': '3',
        'label': 'Pending\nRequests',
        'color': AppTheme.accentOrange,
      },
      {
        'icon': Icons.star_half_rounded,
        'value': '4.8',
        'label': 'Avg Client\nRating',
        'color': const Color(0xFFFFD700),
      },
      {
        'icon': Icons.fitness_center_rounded,
        'value': '12',
        'label': "Week's\nSessions",
        'color': const Color(0xFF64B5F6),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: _MiniStatCard(
              icon: s['icon'] as IconData,
              value: s['value'] as String,
              label: s['label'] as String,
              accentColor: s['color'] as Color,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Clients Row ─────────────────────────────────────────────────────────────
  Widget _buildClientsRow() {
    return SizedBox(
      height: 128,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _clients.length,
        itemBuilder: (_, i) {
          final c = _clients[i];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _ClientAvatarCard(
              client: c,
              progressColor: _progressColor(c.weeklyProgress),
              onTap: () => _openClientModal(c),
            ),
          );
        },
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────────
  Widget _sectionHeader(
    String title, {
    String? badge,
    String? trailingLabel,
    VoidCallback? onTrailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentOrange,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (trailingLabel != null)
            GestureDetector(
              onTap: onTrailing,
              child: Text(
                trailingLabel,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;

  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  final _AttentionItem item;
  final int index;
  final VoidCallback onAction;

  const _AttentionRow({
    required this.item,
    required this.index,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isMeal = item.type == 'meal_request';
    final tagColor = isMeal ? AppTheme.accentGreen : AppTheme.accentOrange;
    final tagLabel = isMeal ? 'Meal Plan' : 'Check-in';
    final tagIcon = isMeal
        ? Icons.restaurant_menu_rounded
        : Icons.notifications_active_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(item.avatarUrl),
              backgroundColor: AppTheme.surfaceLighter,
              onBackgroundImageError: (_, _) {},
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.clientName,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tagIcon, size: 10, color: tagColor),
                            const SizedBox(width: 3),
                            Text(
                              tagLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: tagColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.timeAgo,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.actionLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.backgroundDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (250 + index * 80).ms, duration: 350.ms)
          .slideX(begin: 0.06, end: 0),
    );
  }
}

class _ClientAvatarCard extends StatelessWidget {
  final _Client client;
  final Color progressColor;
  final VoidCallback onTap;

  const _ClientAvatarCard({
    required this.client,
    required this.progressColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: _ProgressRingPainter(
                progress: client.weeklyProgress,
                color: progressColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ClipOval(
                  child: Image.network(
                    client.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppTheme.surfaceLighter,
                      child: const Icon(Icons.person_rounded,
                          color: AppTheme.textSecondary, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              client.name.split(' ').first,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Text(
            '${(client.weeklyProgress * 100).round()}%',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _ProgressRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppTheme.surfaceLighter
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      old.progress != progress || old.color != color;
}

class _SessionRow extends StatelessWidget {
  final _Session session;
  final int index;
  const _SessionRow({required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    final parts = session.time.split(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            // Time
            Column(
              children: [
                Text(
                  parts[0],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accentGreen,
                  ),
                ),
                Text(
                  parts[1],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: AppTheme.surfaceBorder,
            ),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(session.avatarUrl),
              backgroundColor: AppTheme.surfaceLighter,
              onBackgroundImageError: (_, _) {},
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.clientName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    session.type,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentGreen.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                'Upcoming',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (450 + index * 80).ms, duration: 350.ms)
          .slideX(begin: 0.06, end: 0),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _ActivityItem activity;
  final int index;
  const _ActivityRow({required this.activity, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activity.iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(activity.icon, size: 16, color: activity.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${activity.clientName} ',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    TextSpan(
                      text: activity.action,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              activity.timeAgo,
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (500 + index * 80).ms, duration: 350.ms)
          .slideX(begin: 0.05, end: 0),
    );
  }
}
