import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_badge.dart';
import 'coach_home_screen.dart';
import 'meal_plans/meal_plan_requests_screen.dart';

class CoachDashboardScreen extends StatefulWidget {
  final String coachName;
  final String coachSpecialty;
  final String? avatarUrl;

  const CoachDashboardScreen({
    super.key,
    this.coachName = 'Marcus Vance',
    this.coachSpecialty = 'HIIT & Strength',
    this.avatarUrl,
  });

  @override
  State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _trainees = [
    {
      'name': 'Sarah Jenkins',
      'plan': '12-Week Hypertrophy',
      'progress': 0.75,
      'lastActive': 'Today, 9:30 AM',
      'avatar': 'https://i.pravatar.cc/150?img=47',
    },
    {
      'name': 'Alexander Wright',
      'plan': 'Athletic Conditioning',
      'progress': 0.40,
      'lastActive': 'Yesterday',
      'avatar': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'name': 'Olivia Martinez',
      'plan': 'Strength Foundation',
      'progress': 0.90,
      'lastActive': '2 hours ago',
      'avatar': 'https://i.pravatar.cc/150?img=23',
    },
    {
      'name': 'James Liu',
      'plan': 'Fat Loss Protocol',
      'progress': 0.60,
      'lastActive': '3 days ago',
      'avatar': 'https://i.pravatar.cc/150?img=33',
    },
    {
      'name': 'Priya Nair',
      'plan': 'Endurance Base',
      'progress': 0.25,
      'lastActive': '5 days ago',
      'avatar': 'https://i.pravatar.cc/150?img=56',
    },
    {
      'name': 'Tom Reeves',
      'plan': 'Mobility & Recovery',
      'progress': 0.70,
      'lastActive': 'Today',
      'avatar': 'https://i.pravatar.cc/150?img=68',
    },
  ];

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      CoachHomeScreen(coachName: widget.coachName.split(' ').first),
      _ClientsTab(trainees: _trainees),
      const MealPlanRequestsScreen(),
      _CoachProfileTab(
        coachName: widget.coachName,
        coachSpecialty: widget.coachSpecialty,
        avatarUrl: widget.avatarUrl,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.surfaceBorder, width: 1)),
          color: AppTheme.surfaceDark,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: AppTheme.surfaceDark,
          selectedItemColor: AppTheme.accentGreen,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.people_alt_rounded),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_trainees.length}',
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Clients',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.inbox_rounded),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Requests',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Clients Tab (full client list with progress bars)
// ─────────────────────────────────────────────────────────────────────────────

class _ClientsTab extends StatelessWidget {
  final List<Map<String, dynamic>> trainees;
  const _ClientsTab({required this.trainees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Clients',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  StatusBadge.active(label: '${trainees.length} Active'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trainees.length,
                itemBuilder: (_, i) {
                  final t = trainees[i];
                  final progress = t['progress'] as double;
                  Color barColor = AppTheme.accentGreen;
                  if (progress < 0.75) barColor = AppTheme.accentOrange;
                  if (progress < 0.40) barColor = Colors.redAccent;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.surfaceBorder, width: 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(t['avatar'] as String),
                              backgroundColor: AppTheme.surfaceLighter,
                              onBackgroundImageError: (_, _) {},
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['name'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  Text(
                                    t['plan'] as String,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: AppTheme.accentGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              t['lastActive'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: AppTheme.surfaceLighter,
                                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: barColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (i * 60).ms, duration: 300.ms).slideY(begin: 0.05, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coach Profile Tab
// ─────────────────────────────────────────────────────────────────────────────

class _CoachProfileTab extends StatelessWidget {
  final String coachName;
  final String coachSpecialty;
  final String? avatarUrl;

  const _CoachProfileTab({
    required this.coachName,
    required this.coachSpecialty,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              // Profile card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryDark, AppTheme.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38, width: 2),
                      ),
                      child: ClipOval(
                        child: avatarUrl != null
                            ? Image.network(avatarUrl!, fit: BoxFit.cover)
                            : Container(
                                color: Colors.white24,
                                child: Center(
                                  child: Text(
                                    coachName.isNotEmpty ? coachName[0] : 'C',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  coachName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: Colors.white, size: 18),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coachSpecialty,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'VERIFIED COACH',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms),
              const SizedBox(height: 28),
              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: '+ New Routine',
                      icon: const Icon(Icons.add, color: Colors.white, size: 18),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Trainee Chat',
                      isPrimary: false,
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      onPressed: () {},
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 150.ms),
            ],
          ),
        ),
      ),
    );
  }
}
