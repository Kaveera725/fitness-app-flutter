import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'admin/admin_home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUpgrading = false;

  Color _getRoleBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.deepOrange;
      case 'coach':
        return Colors.cyan;
      case 'premium':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'coach':
        return Icons.sports;
      case 'premium':
        return Icons.star;
      default:
        return Icons.person;
    }
  }

  Future<void> _handleUpgrade() async {
    final user = ApiService.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isUpgrading = true;
    });

    final res = await ApiService.instance.upgradeToPremium(user.id);

    if (!mounted) return;

    setState(() {
      _isUpgrading = false;
    });

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 Congratulations! You are now a Premium Member!"),
          backgroundColor: Colors.amber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['error'] ?? "Failed to upgrade"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showAdminUsersDialog() async {
    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<List<UserSession>>(
        future: ApiService.instance.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          final users = snapshot.data ?? [];
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text("All Users (Admin View)"),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 350,
              child: users.isEmpty
                  ? const Center(child: Text("No users found."))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final u = users[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            u.name?.isNotEmpty == true ? u.name! : u.email,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${u.email}\nRole: ${u.roleTitle}"),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.edit, size: 20),
                            onSelected: (newRole) async {
                              final res = await ApiService.instance.updateUserRole(u.id, newRole);
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                _showAdminUsersDialog();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res['message'] ?? 'Role updated'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'user', child: Text('Set Member')),
                              PopupMenuItem(value: 'premium', child: Text('Set Premium')),
                              PopupMenuItem(value: 'coach', child: Text('Set Coach')),
                              PopupMenuItem(value: 'admin', child: Text('Set Admin')),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCoachWorkspacesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sports, color: Colors.cyan),
            SizedBox(width: 8),
            Text("Coach Workspace"),
          ],
        ),
        content: const Text(
          "Welcome Coach! You have access to client workout programs, live schedule reviews, and personalized workout assignments.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ApiService.instance.currentUser;
    final displayName = currentUser?.name?.isNotEmpty == true
        ? currentUser!.name!
        : (currentUser != null ? currentUser.email.split('@')[0] : "Alex Morgan");
    final displayEmail = currentUser?.email ?? "alex.morgan@example.com";
    final role = currentUser?.role ?? 'user';
    final roleTitle = currentUser?.roleTitle ?? 'Member';

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: theme.textTheme.displaySmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    backgroundImage: const NetworkImage(
                      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getRoleBadgeColor(role),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getRoleIcon(role),
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(displayName, style: theme.textTheme.displaySmall),
            const SizedBox(height: 4),
            Text(displayEmail, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _getRoleBadgeColor(role).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getRoleBadgeColor(role), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getRoleIcon(role), size: 16, color: _getRoleBadgeColor(role)),
                  const SizedBox(width: 6),
                  Text(
                    roleTitle.toUpperCase(),
                    style: TextStyle(
                      color: _getRoleBadgeColor(role),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            _buildRoleActionCard(theme, currentUser),
            const SizedBox(height: 24),
            _buildSettingsList(theme, context, currentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleActionCard(ThemeData theme, UserSession? currentUser) {
    if (currentUser?.isPremium == true) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Premium Unlocked",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Unlimited workout plans & advanced telemetry active.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (currentUser?.isAdmin == true) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFE35D5B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(Icons.admin_panel_settings, color: Colors.white, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin Control Center",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Manage user directory, system roles, and privileges.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (currentUser?.isCoach == true) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(Icons.sports, color: Colors.white, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Coach Headquarters",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Review trainee progress and prescribe workout routines.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Default Member Upgrade Banner
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 36),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Go Premium",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Unlock all workouts and advanced analytics.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isUpgrading ? null : _handleUpgrade,
              child: _isUpgrading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      "Upgrade to Premium ⭐",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(ThemeData theme, BuildContext context, UserSession? currentUser) {
    return Column(
      children: [
        if (currentUser?.isAdmin == true) ...[
          _buildListTile(
            Icons.dashboard_customize_rounded,
            "Admin Dashboard Console",
            theme,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
              );
            },
            highlightColor: AppTheme.primary,
          ),
          _buildListTile(
            Icons.manage_accounts,
            "Manage All Users (Quick Modal)",
            theme,
            onTap: _showAdminUsersDialog,
            highlightColor: Colors.deepOrange,
          ),
        ],
        if (currentUser?.isCoach == true)
          _buildListTile(
            Icons.assignment,
            "Coach Trainees & Routines",
            theme,
            onTap: _showCoachWorkspacesDialog,
            highlightColor: Colors.cyan,
          ),
        _buildListTile(Icons.person, "Personal Details", theme),
        _buildListTile(Icons.track_changes, "Fitness Goals", theme),
        _buildListTile(Icons.notifications, "Notifications", theme),
        _buildListTile(Icons.security, "Privacy & Security", theme),
        const SizedBox(height: 24),
        CustomButton(
          text: "Logout",
          isPrimary: false,
          onPressed: () {
            ApiService.instance.logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    ThemeData theme, {
    VoidCallback? onTap,
    Color? highlightColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: highlightColor ?? theme.colorScheme.primary),
      ),
      title: Text(title, style: theme.textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap ?? () {},
    );
  }
}
