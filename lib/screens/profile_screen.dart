import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ApiService.instance.currentUser;
    final displayName = currentUser?.name?.isNotEmpty == true
        ? currentUser!.name!
        : (currentUser != null ? currentUser.email.split('@')[0] : "Alex Morgan");
    final displayEmail = currentUser?.email ?? "alex.morgan@example.com";

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
              child: CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                backgroundImage: const NetworkImage(
                  "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80",
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(displayName, style: theme.textTheme.displaySmall),
            const SizedBox(height: 4),
            Text(displayEmail, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)),

            const SizedBox(height: 32),
            _buildPremiumBanner(theme),
            const SizedBox(height: 32),
            _buildSettingsList(theme, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 40),
          const SizedBox(width: 16),
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
    );
  }

  Widget _buildSettingsList(ThemeData theme, BuildContext context) {
    return Column(
      children: [
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

  Widget _buildListTile(IconData icon, String title, ThemeData theme) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: theme.textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
