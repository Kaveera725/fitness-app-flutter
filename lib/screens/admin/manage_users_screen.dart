import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';
import 'admin_data.dart';

class ManageUsersScreen extends StatefulWidget {
  final String initialFilter;

  const ManageUsersScreen({
    super.key,
    this.initialFilter = 'All',
  });

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final _adminData = AdminDataService.instance;
  final _searchController = TextEditingController();
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _adminData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _adminData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  List<UserItem> _getFilteredUsers() {
    final query = _searchController.text.trim().toLowerCase();
    return _adminData.users.where((user) {
      final matchesQuery = user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          (user.assignedCoachName?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;

      if (_selectedFilter == 'Premium') {
        return user.plan == UserPlan.premium;
      } else if (_selectedFilter == 'Free') {
        return user.plan == UserPlan.free;
      }
      return true;
    }).toList();
  }

  void _showUserDetailsModal(UserItem user) {
    final isPremium = user.plan == UserPlan.premium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal Handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Top Header with Avatar & Plan
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primary.withOpacity(0.15),
                      backgroundImage: NetworkImage(user.avatarUrl),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : 'U',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppTheme.primary,
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
                                  user.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              isPremium
                                  ? StatusBadge.premium()
                                  : StatusBadge.free(),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Member since ${user.joinDate}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),

                // User Fitness Stats Grid
                Text(
                  'Member Activity Stats',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailStatBox(
                        title: 'Streak',
                        value: '${user.streakDays} Days',
                        icon: Icons.local_fire_department_rounded,
                        color: AppTheme.accentOrange,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDetailStatBox(
                        title: 'Workouts',
                        value: '${user.workoutsCompleted}',
                        icon: Icons.fitness_center_rounded,
                        color: AppTheme.primary,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDetailStatBox(
                        title: 'Calories',
                        value: '${(user.totalCaloriesBurned / 1000).toStringAsFixed(1)}k',
                        icon: Icons.bolt_rounded,
                        color: AppTheme.accentGreen,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Assigned Coach Card
                Text(
                  'Assigned Coach',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF282828)
                        : const Color(0xFFF6F6F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: user.assignedCoachName != null
                          ? AppTheme.primary.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.15),
                    ),
                  ),
                  child: user.assignedCoachName != null
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                user.assignedCoachAvatar ??
                                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                              ),
                              onBackgroundImageError: (exception, stackTrace) {},
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.assignedCoachName!,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '1-on-1 Dedicated Trainer',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGreen.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ASSIGNED',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_off_outlined,
                                  size: 20, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'No coach assigned (Free Tier)',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 24),

                // Account Information (Read-only)
                Text(
                  'Account Information',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                _buildInfoTile(Icons.tag_rounded, 'User ID', user.id, isDark),
                _buildInfoTile(Icons.phone_outlined, 'Phone', user.phone, isDark),
                _buildInfoTile(
                    Icons.location_on_outlined, 'Location', user.location, isDark),
                _buildInfoTile(
                  Icons.verified_outlined,
                  'Account Status',
                  'Verified Member (Active)',
                  isDark,
                  trailingColor: const Color(0xFF00C853),
                ),

                const SizedBox(height: 24),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF2E2E2E)
                          : const Color(0xFFEEEEEE),
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Close Details',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailStatBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282828) : const Color(0xFFF6F6F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
      IconData icon, String label, String value, bool isDark,
      {Color? trailingColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: trailingColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final users = _getFilteredUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Users',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_adminData.totalUsers} Total',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGreen,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by user name, email, or coach...',
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF1F1F4),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter tabs
                Row(
                  children: [
                    _buildFilterChip('All', _adminData.totalUsers),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'Premium', _adminData.activePremiumSubscriptions),
                    const SizedBox(width: 8),
                    _buildFilterChip('Free', _adminData.freeUsersCount),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // User List
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 64,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try adjusting your search or filter criteria',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: users.length,
                    itemBuilder: (ctx, index) {
                      final user = users[index];
                      return _buildUserCard(user, index, theme, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : Colors.grey.withOpacity(0.25),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
      UserItem user, int index, ThemeData theme, bool isDark) {
    final isPremium = user.plan == UserPlan.premium;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _showUserDetailsModal(user),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: isPremium
                        ? AppTheme.primaryLight.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    backgroundImage: NetworkImage(user.avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : 'U',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: isPremium ? AppTheme.primary : Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Name & Email & Plan Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            isPremium
                                ? StatusBadge.premium()
                                : StatusBadge.free(),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Assigned coach & tap to view hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        user.assignedCoachName != null
                            ? Icons.sports_rounded
                            : Icons.person_outline_rounded,
                        size: 15,
                        color: user.assignedCoachName != null
                            ? AppTheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.assignedCoachName != null
                            ? 'Coach: ${user.assignedCoachName}'
                            : 'No Coach Assigned',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: user.assignedCoachName != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: user.assignedCoachName != null
                              ? (isDark ? Colors.white70 : Colors.black87)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View details',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 50).ms, duration: 300.ms)
        .slideY(begin: 0.08, end: 0);
  }
}
