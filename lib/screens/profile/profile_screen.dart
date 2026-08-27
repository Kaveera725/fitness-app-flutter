import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/status_badge.dart';
import '../login_screen.dart';
import '../coaches/find_coach_screen.dart';
import '../subscription/subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGoogleUser;
  final bool isMockPremium;
  final bool hasAssignedCoach;

  const ProfileScreen({
    super.key,
    this.isGoogleUser = false,
    this.isMockPremium = true,
    this.hasAssignedCoach = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imagePath;

  bool _isSaving = false;
  bool _notificationsEnabled = true;

  late bool _isPremium;
  late bool _hasCoach;

  // Selected fitness goal
  String _selectedGoal = 'Build Muscle';
  final List<String> _fitnessGoals = [
    'Build Muscle',
    'Lose Weight & Burn Fat',
    'Improve Cardiovascular Endurance',
    'Increase Flexibility & Mobility',
    'General Health & Wellness',
    'Athletic Strength & Conditioning',
  ];

  // Assigned coach mock data
  Map<String, dynamic> _assignedCoach = {
    'name': 'Alex Strong',
    'specialty': 'Strength & Conditioning',
    'rating': 4.9,
    'imageUrl':
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
  };

  @override
  void initState() {
    super.initState();
    final user = ApiService.instance.currentUser;

    _nameController.text = user?.name ?? 'Alex Henderson';
    _emailController.text = user?.email ?? 'alex.henderson@fitpulse.com';
    _heightController.text = '180 cm';
    _weightController.text = '76 kg';

    _isPremium = user?.isPremium ?? widget.isMockPremium;
    _hasCoach = widget.hasAssignedCoach;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// Pick an image using image_picker (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imagePath = pickedFile.path;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Profile photo updated!'),
                ],
              ),
              backgroundColor: const Color(0xFF00C853),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// Show modal bottom sheet to pick photo source
  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Change Profile Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_camera_rounded,
                        color: Color(0xFF5E35B1)),
                  ),
                  title: Text('Take a Photo',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                  subtitle: Text('Use device camera',
                      style: GoogleFonts.manrope(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded,
                        color: Color(0xFF5E35B1)),
                  ),
                  title: Text('Choose from Gallery',
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                  subtitle: Text('Select an existing picture',
                      style: GoogleFonts.manrope(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_imageBytes != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                    ),
                    title: Text('Remove Photo',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent)),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _imageBytes = null;
                        _imagePath = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Save profile changes handler
  Future<void> _handleSaveChanges() async {
    setState(() => _isSaving = true);

    // Simulate backend network latency
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Profile changes saved successfully!',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00C853),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Log out confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out of your FitPulse account?',
          style: GoogleFonts.manrope(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.grey)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  /// Delete Account confirmation warning dialog
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Text('Delete Account',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, color: Colors.redAccent)),
          ],
        ),
        content: Text(
          'This action is irreversible. All your workout history, progress stats, and coach messages will be permanently deleted.',
          style: GoogleFonts.manrope(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Keep Account',
                style: GoogleFonts.manrope(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.instance.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account successfully deleted.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Permanently Delete'),
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Management',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // ── Profile Photo with Camera Overlay ────────────────────────
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _showPhotoSourceSheet,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFF5E35B1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5E35B1).withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.5),
                        child: ClipOval(
                          child: Container(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey.shade100,
                            child: _imageBytes != null
                                ? Image.memory(
                                    _imageBytes!,
                                    fit: BoxFit.cover,
                                    width: 104,
                                    height: 104,
                                  )
                                : Container(
                                    color: const Color(0xFF5E35B1)
                                        .withOpacity(0.12),
                                    child: Center(
                                      child: Text(
                                        _nameController.text.isNotEmpty
                                            ? _nameController.text[0]
                                                .toUpperCase()
                                            : 'A',
                                        style: GoogleFonts.poppins(
                                          fontSize: 44,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF5E35B1),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Camera Icon Badge Overlay
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _showPhotoSourceSheet,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF5E35B1),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 12),

            // User Name & Email Subtitle
            Text(
              _nameController.text,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _emailController.text,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // ── Plan Status Badge Card ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isPremium
                    ? const LinearGradient(
                        colors: [Color(0xFF2E0854), Color(0xFF5E35B1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF242424), const Color(0xFF1E1E1E)]
                            : [Colors.grey.shade100, Colors.grey.shade200],
                      ),
                border: Border.all(
                  color: _isPremium
                      ? const Color(0xFF7C4DFF).withOpacity(0.5)
                      : Colors.grey.withOpacity(0.2),
                ),
                boxShadow: _isPremium
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7C4DFF).withOpacity(0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isPremium
                          ? Colors.amber.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPremium
                          ? Icons.workspace_premium_rounded
                          : Icons.person_outline_rounded,
                      color: _isPremium ? Colors.amber : Colors.grey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isPremium
                              ? 'Premium — expires Dec 31, 2026'
                              : 'Free Plan',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _isPremium ? Colors.white : null,
                          ),
                        ),
                        Text(
                          _isPremium
                              ? 'All coach messaging & workouts active'
                              : 'Upgrade for personal coach & analytics',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color:
                                _isPremium ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isPremium)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SubscriptionScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E35B1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        textStyle: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Upgrade'),
                    ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 16),

            // ── Assigned Coach Mini Card (If Premium & has a coach) ───────
            if (_isPremium && _hasCoach) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5E35B1).withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Mini Coach Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 44,
                        height: 44,
                        color: const Color(0xFF5E35B1).withOpacity(0.12),
                        child: Image.network(
                          _assignedCoach['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.person,
                                  color: Color(0xFF5E35B1), size: 24),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _assignedCoach['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const StatusBadge(
                                label: 'Assigned Coach',
                                type: BadgeType.custom,
                                customColor: Color(0xFF5E35B1),
                                fontSize: 9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _assignedCoach['specialty'],
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FindCoachScreen()),
                        );
                      },
                      child: Text(
                        'Change',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5E35B1),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 16),
            ],

            // ── Section Title: Personal Details ───────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Information',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Full Name field
            CustomTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 14),

            // Email field (read-only if Google account)
            CustomTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              readOnly: widget.isGoogleUser,
              helperText: widget.isGoogleUser
                  ? '🔒 Managed by your Google account (read-only)'
                  : null,
            ),
            const SizedBox(height: 14),

            // Height and Weight in a 2-column Row
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Height',
                    hint: 'e.g. 180 cm',
                    controller: _heightController,
                    prefixIcon: Icons.height_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CustomTextField(
                    label: 'Weight',
                    hint: 'e.g. 76 kg',
                    controller: _weightController,
                    prefixIcon: Icons.monitor_weight_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Fitness Goal Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitness Goal',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFF7F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGoal,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF5E35B1)),
                      dropdownColor:
                          isDark ? const Color(0xFF222222) : Colors.white,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onChanged: (newGoal) {
                        if (newGoal != null) {
                          setState(() => _selectedGoal = newGoal);
                        }
                      },
                      items: _fitnessGoals.map((goal) {
                        return DropdownMenuItem<String>(
                          value: goal,
                          child: Row(
                            children: [
                              const Icon(Icons.fitness_center_rounded,
                                  size: 16, color: Color(0xFF5E35B1)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  goal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Save Changes Gradient Button ──────────────────────────────
            GradientButton(
              text: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _handleSaveChanges,
              icon: const Icon(Icons.save_rounded,
                  color: Colors.white, size: 20),
            ),

            const SizedBox(height: 32),

            // ── Section Title: Account & Settings ─────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings & Preferences',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Settings Card List
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Notifications Switch Tile
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Color(0xFF5E35B1), size: 20),
                    ),
                    title: Text(
                      'Push Notifications',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Workout reminders and coach messages',
                      style: GoogleFonts.manrope(fontSize: 12),
                    ),
                    value: _notificationsEnabled,
                    activeColor: const Color(0xFF5E35B1),
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                    },
                  ),
                  const Divider(height: 1, indent: 56),

                  // Privacy Policy Tile
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shield_outlined,
                          color: Color(0xFF5E35B1), size: 20),
                    ),
                    title: Text(
                      'Privacy & Security',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Colors.grey),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('Privacy & Security',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700)),
                          content: Text(
                            'Your data is securely stored and encrypted. FitPulse never shares personal health data with third-party advertising networks.',
                            style: GoogleFonts.manrope(
                                fontSize: 13, height: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),

                  // Log Out Tile (Red Text)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Colors.redAccent, size: 20),
                    ),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Colors.redAccent),
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Delete Account Button (Less prominent, red text)
            Center(
              child: TextButton.icon(
                onPressed: _showDeleteAccountDialog,
                icon: const Icon(Icons.delete_forever_outlined,
                    size: 16, color: Colors.red),
                label: Text(
                  'Delete Account',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
