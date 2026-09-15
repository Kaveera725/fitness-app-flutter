import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import 'build_meal_plan_for_user_screen.dart';
import 'meal_plan_request_model.dart';

class MealPlanRequestsScreen extends StatefulWidget {
  const MealPlanRequestsScreen({super.key});

  @override
  State<MealPlanRequestsScreen> createState() => _MealPlanRequestsScreenState();
}

class _MealPlanRequestsScreenState extends State<MealPlanRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<MealPlanRequest> _allRequests;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _allRequests = getSampleMealPlanRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MealPlanRequest> get _pendingRequests =>
      _allRequests.where((r) => r.status == RequestStatus.pending).toList();

  List<MealPlanRequest> get _completedRequests =>
      _allRequests.where((r) => r.status == RequestStatus.completed).toList();

  void _navigateToBuildPlan(MealPlanRequest request) async {
    final updated = await Navigator.push<MealPlanRequest>(
      context,
      MaterialPageRoute(
        builder: (_) => BuildMealPlanForUserScreen(
          request: request,
          onPlanAssigned: (updatedRequest) {
            setState(() {
              final index =
                  _allRequests.indexWhere((r) => r.id == updatedRequest.id);
              if (index != -1) {
                _allRequests[index] = updatedRequest;
              }
            });
          },
        ),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        final index = _allRequests.indexWhere((r) => r.id == updated.id);
        if (index != -1) {
          _allRequests[index] = updated;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _pendingRequests.length;
    final completedCount = _completedRequests.length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              "Meal Plan Requests",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "$pendingCount Pending",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D0F0D),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: const Color(0xFF0D0F0D),
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pending_actions_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text("Pending ($pendingCount)"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text("Completed ($completedCount)"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Pending requests
          _buildRequestsList(_pendingRequests, isPending: true),

          // Tab 2: Completed requests
          _buildRequestsList(_completedRequests, isPending: false),
        ],
      ),
    );
  }

  Widget _buildRequestsList(List<MealPlanRequest> list, {required bool isPending}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Icon(
                isPending
                    ? Icons.mark_email_read_outlined
                    : Icons.assignment_turned_in_outlined,
                size: 48,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? "No Pending Requests" : "No Completed Requests",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isPending
                  ? "All trainee meal plans have been fulfilled."
                  : "Assigned meal plans will appear here.",
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        return _buildRequestCard(req, isPending: isPending)
            .animate()
            .fadeIn(delay: (index * 60).ms, duration: 350.ms)
            .slideY(begin: 0.08, end: 0);
      },
    );
  }

  Widget _buildRequestCard(MealPlanRequest request, {required bool isPending}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPending
              ? AppTheme.primary.withValues(alpha: 0.35)
              : AppTheme.surfaceBorder,
          width: isPending ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPending
                ? AppTheme.primary.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row: Avatar + Name + Timestamp
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Requesting User Avatar with glowing border
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPending ? AppTheme.primary : AppTheme.surfaceBorder,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF222622),
                    backgroundImage: NetworkImage(request.userAvatar),
                  ),
                ),
                const SizedBox(width: 14),

                // Name + Request Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              request.userName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPending
                                  ? AppTheme.primary.withValues(alpha: 0.14)
                                  : const Color(0xFF222722),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPending
                                      ? Icons.schedule_rounded
                                      : Icons.check_circle_rounded,
                                  size: 12,
                                  color: isPending
                                      ? AppTheme.primary
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  request.timestamp,
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isPending
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${request.mealsPerDay} meals/day request",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: AppTheme.surfaceBorder.withValues(alpha: 0.6),
          ),

          // 2. Condensed Body Stats Preview (Age, Weight, Goal)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF131513),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder.withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("AGE", "${request.age} yrs"),
                  _buildDividerDot(),
                  _buildStatItem("WEIGHT", request.weight),
                  _buildDividerDot(),
                  _buildStatItem("HEIGHT", request.height),
                  _buildDividerDot(),
                  _buildStatItem("GOAL", request.fitnessGoal, isGoal: true),
                ],
              ),
            ),
          ),

          // 3. Dietary Preferences Small Chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...request.dietaryPreferences.map(
                  (pref) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.28),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      pref,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                if (request.allergies.isNotEmpty &&
                    request.allergies.toLowerCase() != "none")
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 11, color: Colors.redAccent),
                        const SizedBox(width: 3),
                        Text(
                          request.allergies,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 4. CTA Row: "View & Build Plan" Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToBuildPlan(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPending ? AppTheme.primary : const Color(0xFF222722),
                  foregroundColor:
                      isPending ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                  elevation: isPending ? 2 : 0,
                  shadowColor: AppTheme.primary.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: isPending
                        ? BorderSide.none
                        : const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPending
                          ? Icons.restaurant_menu_rounded
                          : Icons.visibility_outlined,
                      size: 17,
                      color: isPending
                          ? const Color(0xFF0D0F0D)
                          : AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPending ? "View & Build Plan" : "Review Assigned Plan",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        color: isPending
                            ? const Color(0xFF0D0F0D)
                            : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: isPending
                          ? const Color(0xFF0D0F0D)
                          : AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isGoal = false}) {
    return Column(
      crossAxisAlignment:
          isGoal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isGoal ? AppTheme.primary : AppTheme.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDividerDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Color(0xFF2E342E),
        shape: BoxShape.circle,
      ),
    );
  }
}
