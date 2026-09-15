import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/coach.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import '../coaches/coach_detail_screen.dart';
import 'meal_plans/meal_plan_requests_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Models & Enums
// ─────────────────────────────────────────────────────────────────────────────

enum ClientStatus {
  onTrack,
  fallingBehind,
  newRequest,
}

class ClientItem {
  final String id;
  final String name;
  final String avatarUrl;
  final String goal;
  final String plan;
  final double adherence; // 0.0 - 1.0 (e.g. 0.88 = 88%)
  final ClientStatus status;
  final String lastActive;
  final String weight;
  final String targetWeight;
  final int completedWorkouts;
  final int targetWorkouts;
  final String? pendingRequestNote;

  const ClientItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.goal,
    required this.plan,
    required this.adherence,
    required this.status,
    required this.lastActive,
    required this.weight,
    required this.targetWeight,
    required this.completedWorkouts,
    required this.targetWorkouts,
    this.pendingRequestNote,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MyClientsScreen
// ─────────────────────────────────────────────────────────────────────────────

class MyClientsScreen extends StatefulWidget {
  final bool isTab;
  final String coachName;

  const MyClientsScreen({
    super.key,
    this.isTab = false,
    this.coachName = 'Marcus Vance',
  });

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _forceZeroClientsDemo = false;

  // ── Realistic Dummy Clients (8-10 items with varied states) ─────────────────
  final List<ClientItem> _allClients = const [
    ClientItem(
      id: 'c1',
      name: 'Sarah Jenkins',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      goal: 'Muscle Hypertrophy',
      plan: '12-Week Hypertrophy Protocol',
      adherence: 0.88,
      status: ClientStatus.onTrack,
      lastActive: 'Today, 9:30 AM',
      weight: '62.5 kg',
      targetWeight: '65.0 kg',
      completedWorkouts: 4,
      targetWorkouts: 4,
    ),
    ClientItem(
      id: 'c2',
      name: 'Alexander Wright',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      goal: 'Athletic Conditioning',
      plan: 'Speed & Agility Track',
      adherence: 0.42,
      status: ClientStatus.newRequest,
      pendingRequestNote: 'Requested custom Keto meal plan (2,200 kcal/day)',
      lastActive: '2 hours ago',
      weight: '84.0 kg',
      targetWeight: '78.0 kg',
      completedWorkouts: 2,
      targetWorkouts: 5,
    ),
    ClientItem(
      id: 'c3',
      name: 'Olivia Martinez',
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
      goal: 'Strength Foundation',
      plan: '5x5 Heavy Compound Split',
      adherence: 0.95,
      status: ClientStatus.onTrack,
      lastActive: 'Today, 8:15 AM',
      weight: '58.0 kg',
      targetWeight: '60.0 kg',
      completedWorkouts: 3,
      targetWorkouts: 3,
    ),
    ClientItem(
      id: 'c4',
      name: 'James Liu',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      goal: 'Fat Loss Protocol',
      plan: 'HIIT & Caloric Deficit Plan',
      adherence: 0.65,
      status: ClientStatus.onTrack,
      lastActive: 'Yesterday',
      weight: '79.2 kg',
      targetWeight: '72.0 kg',
      completedWorkouts: 3,
      targetWorkouts: 4,
    ),
    ClientItem(
      id: 'c5',
      name: 'Priya Nair',
      avatarUrl: 'https://i.pravatar.cc/150?img=56',
      goal: 'Endurance & Running',
      plan: 'Half Marathon Base Builder',
      adherence: 0.28,
      status: ClientStatus.fallingBehind,
      lastActive: '5 days ago',
      weight: '54.0 kg',
      targetWeight: '52.0 kg',
      completedWorkouts: 1,
      targetWorkouts: 4,
    ),
    ClientItem(
      id: 'c6',
      name: 'Tom Reeves',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      goal: 'Mobility & Recovery',
      plan: 'Postural Restoration',
      adherence: 0.72,
      status: ClientStatus.newRequest,
      pendingRequestNote: 'Requested High-Protein meal plan & shoulder rehab focus',
      lastActive: 'Today, 11:00 AM',
      weight: '76.5 kg',
      targetWeight: '75.0 kg',
      completedWorkouts: 3,
      targetWorkouts: 4,
    ),
    ClientItem(
      id: 'c7',
      name: 'Marcus Vance Jr.',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      goal: 'Lean Bulking',
      plan: 'Push / Pull / Legs Cycle',
      adherence: 0.82,
      status: ClientStatus.onTrack,
      lastActive: '45m ago',
      weight: '78.0 kg',
      targetWeight: '82.0 kg',
      completedWorkouts: 4,
      targetWorkouts: 5,
    ),
    ClientItem(
      id: 'c8',
      name: 'Emma Watson',
      avatarUrl: 'https://i.pravatar.cc/150?img=28',
      goal: 'Body Recomposition',
      plan: 'Functional Strength & Core',
      adherence: 0.35,
      status: ClientStatus.fallingBehind,
      lastActive: '3 days ago',
      weight: '60.5 kg',
      targetWeight: '57.0 kg',
      completedWorkouts: 1,
      targetWorkouts: 3,
    ),
    ClientItem(
      id: 'c9',
      name: 'David Chen',
      avatarUrl: 'https://i.pravatar.cc/150?img=60',
      goal: 'Powerlifting Peak',
      plan: 'Advanced Peaking Cycle',
      adherence: 0.90,
      status: ClientStatus.onTrack,
      lastActive: 'Today, 7:00 AM',
      weight: '91.0 kg',
      targetWeight: '93.0 kg',
      completedWorkouts: 4,
      targetWorkouts: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Filter Logic ────────────────────────────────────────────────────────────
  List<ClientItem> get _filteredClients {
    if (_forceZeroClientsDemo) return [];

    final query = _searchController.text.trim().toLowerCase();
    List<ClientItem> list = _allClients;

    // Filter by tab
    if (_selectedTabIndex == 1) {
      // Needs Attention: falling behind or has pending request
      list = list.where((c) =>
          c.status == ClientStatus.fallingBehind ||
          c.status == ClientStatus.newRequest).toList();
    } else if (_selectedTabIndex == 2) {
      // On Track
      list = list.where((c) => c.status == ClientStatus.onTrack).toList();
    }

    // Filter by search query
    if (query.isNotEmpty) {
      list = list.where((c) =>
          c.name.toLowerCase().contains(query) ||
          c.goal.toLowerCase().contains(query) ||
          c.plan.toLowerCase().contains(query)).toList();
    }

    return list;
  }

  int get _needsAttentionCount => _allClients.where((c) =>
      c.status == ClientStatus.fallingBehind ||
      c.status == ClientStatus.newRequest).length;

  int get _onTrackCount =>
      _allClients.where((c) => c.status == ClientStatus.onTrack).length;

  Color _adherenceColor(double val) {
    if (val >= 0.75) return AppTheme.accentGreen;
    if (val >= 0.40) return AppTheme.accentOrange;
    return Colors.redAccent;
  }

  // ── Open Client Detail Modal ────────────────────────────────────────────────
  void _openClientDetail(ClientItem client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _ClientDetailSheet(
        client: client,
        adherenceColor: _adherenceColor(client.adherence),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final clients = _filteredClients;
    final totalCount = _forceZeroClientsDemo ? 0 : _allClients.length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: widget.isTab
          ? null
          : AppBar(
              backgroundColor: AppTheme.backgroundDark,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppTheme.textDark, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'My Clients',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: _forceZeroClientsDemo
                      ? 'Show Clients (Demo)'
                      : 'Simulate Zero Clients (Demo)',
                  icon: Icon(
                    _forceZeroClientsDemo
                        ? Icons.group_add_rounded
                        : Icons.group_off_rounded,
                    color: AppTheme.accentGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _forceZeroClientsDemo = !_forceZeroClientsDemo;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_forceZeroClientsDemo
                            ? 'Simulating empty roster (0 clients)'
                            : 'Restored full client roster (${_allClients.length} clients)'),
                        backgroundColor: AppTheme.surfaceDark,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isTab) ...[
                            Text(
                              'My Clients',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            'Active Trainee Roster',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          StatusBadge.active(
                            label: '$totalCount Active',
                          ),
                          if (widget.isTab) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: _forceZeroClientsDemo
                                  ? 'Show Clients'
                                  : 'Demo: Zero Clients',
                              icon: Icon(
                                _forceZeroClientsDemo
                                    ? Icons.group_add_rounded
                                    : Icons.group_off_rounded,
                                color: AppTheme.accentGreen,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _forceZeroClientsDemo = !_forceZeroClientsDemo;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _searchController.text.isNotEmpty
                            ? AppTheme.accentGreen
                            : AppTheme.surfaceBorder,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.manrope(
                        color: AppTheme.textDark,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by trainee name, goal, or routine...',
                        hintStyle: GoogleFonts.manrope(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    color: AppTheme.textSecondary, size: 18),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs (All / Needs Attention / On Track)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder, width: 1),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: AppTheme.backgroundDark,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('All'),
                        const SizedBox(width: 6),
                        _tabBadge('${_allClients.length}', 0),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Attention'),
                        const SizedBox(width: 6),
                        _tabBadge('$_needsAttentionCount', 1, isAlert: true),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('On Track'),
                        const SizedBox(width: 6),
                        _tabBadge('$_onTrackCount', 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Content Area: List vs Empty State
            Expanded(
              child: _forceZeroClientsDemo
                  ? _buildZeroClientsEmptyState()
                  : clients.isEmpty
                      ? _buildNoSearchResultsEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                          itemCount: clients.length,
                          itemBuilder: (ctx, i) {
                            final client = clients[i];
                            return _ClientRowCard(
                              client: client,
                              index: i,
                              adherenceColor: _adherenceColor(client.adherence),
                              onTap: () => _openClientDetail(client),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab Badge Helper ────────────────────────────────────────────────────────
  Widget _tabBadge(String count, int tabIdx, {bool isAlert = false}) {
    final isSelected = _selectedTabIndex == tabIdx;
    Color bg;
    Color text;

    if (isSelected) {
      bg = AppTheme.backgroundDark.withValues(alpha: 0.25);
      text = AppTheme.backgroundDark;
    } else {
      bg = isAlert
          ? AppTheme.accentOrange.withValues(alpha: 0.15)
          : AppTheme.surfaceLighter;
      text = isAlert ? AppTheme.accentOrange : AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: text,
        ),
      ),
    );
  }

  // ── Empty State: Zero Clients in Roster ──────────────────────────────────────
  Widget _buildZeroClientsEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentGreen.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 46,
                color: AppTheme.accentGreen,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            Text(
              'No Clients Assigned Yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When members subscribe to your 1-on-1 coaching program, their profiles and weekly adherence will appear right here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Navigate to public coach profile preview
                final demoCoach = Coach(
                  name: widget.coachName,
                  specialty: 'Strength & Conditioning Specialist',
                  imageUrl: 'https://i.pravatar.cc/150?img=3',
                  rating: 4.8,
                  reviewCount: 42,
                  experienceYears: 7,
                  bio:
                      'Certified personal trainer dedicated to helping trainees build functional strength, optimize metabolic health, and master balanced nutrition.',
                  reviews: [
                    Review(
                      reviewer: 'Sarah Jenkins',
                      rating: 5.0,
                      comment:
                          'Marcus tailored my routine perfectly around my busy schedule. Down 4% body fat in 8 weeks!',
                    ),
                    Review(
                      reviewer: 'Alexander Wright',
                      rating: 4.8,
                      comment:
                          'Great feedback on form and responsive meal plan suggestions.',
                    ),
                  ],
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoachDetailScreen(
                      coach: demoCoach,
                      isPremium: true,
                      hasThisCoach: false,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.badge_rounded,
                  color: AppTheme.backgroundDark, size: 18),
              label: Text(
                'Preview Public Profile',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.backgroundDark,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.surfaceBorder),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MealPlanRequestsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.inbox_rounded,
                  color: AppTheme.textDark, size: 16),
              label: Text(
                'View Meal Plan Requests',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State: Search yielded no matches ──────────────────────────────────
  Widget _buildNoSearchResultsEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 36,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Clients Found',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No clients match "${_searchController.text.trim()}". Try searching with another name or keyword.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.refresh_rounded,
                  size: 16, color: AppTheme.accentGreen),
              label: Text(
                'Clear Search',
                style: GoogleFonts.poppins(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Client Row Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _ClientRowCard extends StatelessWidget {
  final ClientItem client;
  final int index;
  final Color adherenceColor;
  final VoidCallback onTap;

  const _ClientRowCard({
    required this.client,
    required this.index,
    required this.adherenceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Status Tag Details
    Color tagBg;
    Color tagText;
    IconData tagIcon;
    String tagLabel;

    switch (client.status) {
      case ClientStatus.onTrack:
        tagBg = AppTheme.accentGreen.withValues(alpha: 0.12);
        tagText = AppTheme.accentGreen;
        tagIcon = Icons.check_circle_rounded;
        tagLabel = 'On Track';
        break;
      case ClientStatus.fallingBehind:
        tagBg = AppTheme.accentOrange.withValues(alpha: 0.12);
        tagText = AppTheme.accentOrange;
        tagIcon = Icons.warning_amber_rounded;
        tagLabel = 'Falling Behind';
        break;
      case ClientStatus.newRequest:
        tagBg = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
        tagText = const Color(0xFFA78BFA);
        tagIcon = Icons.bolt_rounded;
        tagLabel = 'New Request';
        break;
    }

    final isToday = client.lastActive.toLowerCase().contains('today') ||
        client.lastActive.contains('m ago') ||
        client.lastActive.contains('hours ago');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: client.status == ClientStatus.newRequest
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.4)
                    : AppTheme.surfaceBorder,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar with online status ring
                    Stack(
                      children: [
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: CustomPaint(
                            painter: _AdherenceRingPainter(
                              progress: client.adherence,
                              color: adherenceColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipOval(
                                child: Image.network(
                                  client.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: AppTheme.surfaceLighter,
                                    child: const Icon(Icons.person_rounded,
                                        color: AppTheme.textSecondary,
                                        size: 26),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppTheme.accentGreen
                                  : AppTheme.textSecondary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.surfaceDark, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Name + Goal + Plan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  client.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Status Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: tagBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(tagIcon, size: 10, color: tagText),
                                    const SizedBox(width: 4),
                                    Text(
                                      tagLabel,
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: tagText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            client.goal,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'Active: ${client.lastActive}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trailing Adherence Stat
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(client.adherence * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: adherenceColor,
                          ),
                        ),
                        Text(
                          'Weekly',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 13, color: AppTheme.textSecondary),
                  ],
                ),

                // Linear Adherence Progress Bar Row
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: client.adherence,
                          backgroundColor: AppTheme.surfaceLighter,
                          valueColor: AlwaysStoppedAnimation(adherenceColor),
                          minHeight: 5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${client.completedWorkouts}/${client.targetWorkouts} workouts',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),

                // Optional note preview if new request
                if (client.pendingRequestNote != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notification_important_rounded,
                            size: 14, color: Color(0xFFA78BFA)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            client.pendingRequestNote!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFDDD6FE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (60 * index).ms, duration: 350.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adherence Ring Custom Painter
// ─────────────────────────────────────────────────────────────────────────────

class _AdherenceRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _AdherenceRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppTheme.surfaceLighter
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Active arc
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
  bool shouldRepaint(_AdherenceRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Client Detail Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ClientDetailSheet extends StatelessWidget {
  final ClientItem client;
  final Color adherenceColor;

  const _ClientDetailSheet({
    required this.client,
    required this.adherenceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header Info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
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
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      client.plan,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last active: ${client.lastActive}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: adherenceColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: adherenceColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${(client.adherence * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: adherenceColor,
                      ),
                    ),
                    Text(
                      'Adherence',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        color: adherenceColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Key Trainee Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLighter,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricCol('Goal', client.goal.split(' ').first),
                _divider(),
                _metricCol('Weight', client.weight),
                _divider(),
                _metricCol('Target', client.targetWeight),
                _divider(),
                _metricCol(
                    'Workouts', '${client.completedWorkouts}/${client.targetWorkouts}'),
              ],
            ),
          ),

          // Action Notice banner if needed
          if (client.status == ClientStatus.newRequest) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu_rounded,
                      color: Color(0xFFA78BFA), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Meal Plan Request',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFDDD6FE),
                          ),
                        ),
                        Text(
                          client.pendingRequestNote ?? 'Trainee submitted dietary preferences',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MealPlanRequestsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Review',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA78BFA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (client.status == ClientStatus.fallingBehind) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppTheme.accentOrange.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded,
                      color: AppTheme.accentOrange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-in Overdue',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accentOrange,
                          ),
                        ),
                        Text(
                          'Trainee has missed 2+ workouts this week. Send a message to keep them accountable.',
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
            ),
          ],

          const SizedBox(height: 24),

          // Bottom Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.surfaceBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Chat channel opened with ${client.name}'),
                        backgroundColor: AppTheme.accentGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded,
                      size: 18, color: AppTheme.textDark),
                  label: Text(
                    'Message',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Workout routine assignment opened for ${client.name}'),
                        backgroundColor: AppTheme.accentGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.fitness_center_rounded,
                      size: 18, color: AppTheme.backgroundDark),
                  label: Text(
                    'Assign Routine',
                    style: GoogleFonts.poppins(
                      color: AppTheme.backgroundDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 28,
      color: AppTheme.surfaceBorder,
    );
  }

  Widget _metricCol(String title, String val) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
