import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
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
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController(text: "26");
  final _bodyFatController = TextEditingController(text: "13.5%");

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imagePath;

  bool _notificationsEnabled = true;

  late bool _isPremium;

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

  // Hashtag interest tags
  final List<String> _interestTags = [
    "#IronPrincess",
    "#MuscleMood",
    "#HIITAddict",
    "#CleanFuel",
    "#HeavyLifting",
    "#DailyConsistency",
    "#CorePower",
  ];

  // Assigned coach data
  final Map<String, dynamic> _assignedCoach = {
    'name': 'Alex Strong',
    'specialty': 'Strength & Conditioning',
    'rating': 4.9,
    'imageUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
  };

  @override
  void initState() {
    super.initState();
    final user = ApiService.instance.currentUser;

    _nameController.text = user?.name ?? 'Alex Henderson';
    _heightController.text = '180 cm';
    _weightController.text = '76.0 kg';

    _isPremium = user?.isPremium ?? widget.isMockPremium;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

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
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Profile photo updated!'),
                ],
              ),
              backgroundColor: AppTheme.surfaceDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.surfaceBorder),
              ),
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

  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
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
                    color: AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Change Profile Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_camera_rounded, color: AppTheme.primary),
                  ),
                  title: Text('Take a Photo', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  subtitle: Text('Use device camera', style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppTheme.primary),
                  ),
                  title: Text('Choose from Gallery', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  subtitle: Text('Select an existing picture', style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_imageBytes != null || _imagePath != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    ),
                    title: Text('Remove Photo', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.redAccent)),
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

  Future<void> _handleSaveChanges() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

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
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.surfaceBorder),
        ),
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

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
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
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Edit Athlete Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Height',
                            controller: _heightController,
                            prefixIcon: Icons.height_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Weight',
                            controller: _weightController,
                            prefixIcon: Icons.monitor_weight_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Age',
                            controller: _ageController,
                            prefixIcon: Icons.cake_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Body Fat %',
                            controller: _bodyFatController,
                            prefixIcon: Icons.pie_chart_outline_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Primary Goal',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141714),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGoal,
                          isExpanded: true,
                          dropdownColor: AppTheme.surfaceDark,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primary),
                          style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 14),
                          items: _fitnessGoals.map((goal) {
                            return DropdownMenuItem(
                              value: goal,
                              child: Text(goal),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => _selectedGoal = val);
                              setState(() => _selectedGoal = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _handleSaveChanges();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: const Color(0xFF0D0F0D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── 1. Full-Width Dark Banner Behind Profile Section ────────
            _buildProfileHeroBanner(),

            // ── Content Below Hero ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── 2. Scrollable Row of Hashtag-Style Interest Tags ────
                  _buildInterestTags(),
                  const SizedBox(height: 20),

                  // ── 3. Stats Rows: Followers & Physical Metrics ────────
                  _buildFollowerStatsBar(),
                  const SizedBox(height: 12),
                  _buildPhysicalStatsRow(),
                  const SizedBox(height: 20),

                  // ── 4. "Last Activity" Card ─────────────────────────────
                  _buildLastActivityCard(),
                  const SizedBox(height: 20),

                  // ── 5. Standard Profile Action Cards ────────────────────
                  _buildEditableProfileActions(),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. Profile Hero with Banner & Lightning Bolt Badge
  // ==========================================
  Widget _buildProfileHeroBanner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Full-width blurred fitness banner
        SizedBox(
          height: 210,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=1200&q=80",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1B201B)),
              ),
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0D0F0D).withValues(alpha: 0.4),
                      const Color(0xFF0D0F0D).withValues(alpha: 0.8),
                      AppTheme.backgroundDark,
                    ],
                    stops: const [0.0, 0.65, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top Corner: Streak / Lightning Bolt Badge
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Athlete Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
                // Glowing Lightning Bolt Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0F0D).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        "42d STREAK",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Circular Profile Photo & Header Info
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Large Circular Photo with Neon Green Ring
              GestureDetector(
                onTap: _showPhotoSourceSheet,
                child: Stack(
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _imageBytes != null
                            ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                            : Image.network(
                                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: const Color(0xFF222622),
                                  child: const Icon(Icons.person, color: AppTheme.primary, size: 48),
                                ),
                              ),
                      ),
                    ),
                    // Camera icon button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.backgroundDark, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Color(0xFF0D0F0D)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. Interest Hashtag Row
  // ==========================================
  Widget _buildInterestTags() {
    return Column(
      children: [
        const SizedBox(height: 48), // clearance for overlapping avatar
        // User Name & Handle
        Text(
          _nameController.text,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "@alex_pulse",
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "PRO ATHLETE",
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Scrollable Row of Hashtag-Style Interest Tags
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _interestTags.map((tag) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF141714),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    width: 0.9,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0),
      ],
    );
  }

  // ==========================================
  // 3. Stats Rows (Followers & Physical Metrics)
  // ==========================================
  Widget _buildFollowerStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCountItem("1.8k", "Followers"),
          _buildDivider(),
          _buildCountItem("342", "Following"),
          _buildDivider(),
          _buildCountItem("128", "Workouts"),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildPhysicalStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem("Age", "${_ageController.text} yrs"),
          _buildDivider(),
          _buildMetricItem("Weight", _weightController.text),
          _buildDivider(),
          _buildMetricItem("Height", _heightController.text),
          _buildDivider(),
          _buildMetricItem("Body Fat", _bodyFatController.text),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  Widget _buildCountItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 26,
      width: 1,
      color: AppTheme.surfaceBorder,
    );
  }

  // ==========================================
  // 4. "Last Activity" Card
  // ==========================================
  Widget _buildLastActivityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 13, color: AppTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      "LAST ACTIVITY",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Today, 7:30 AM",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF141714),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.fitness_center_rounded, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upper Body Hypertrophy",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "52 min • 580 kcal • 148 bpm avg",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppTheme.textSecondary),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  // ==========================================
  // 5. Standard Profile Actions & Settings
  // ==========================================
  Widget _buildEditableProfileActions() {
    return Column(
      children: [
        // Edit Profile Action
        _buildActionTile(
          icon: Icons.edit_note_rounded,
          title: "Edit Athlete Profile",
          subtitle: "Update weight, height, age, goals",
          onTap: _showEditProfileSheet,
        ),
        const SizedBox(height: 10),

        // Assigned Coach / Pro Membership
        _buildActionTile(
          icon: Icons.workspace_premium_rounded,
          title: _isPremium ? "Pro Membership Active" : "Upgrade to Pro",
          subtitle: _isPremium ? "Coach: ${_assignedCoach['name']}" : "Unlock 1-on-1 coach & custom diets",
          iconColor: AppTheme.accentPurple,
          trailing: _isPremium
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "VIP",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accentPurple,
                    ),
                  ),
                )
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Notifications Toggle Tile
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.surfaceBorder, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_active_rounded, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Workout Reminders",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      "Daily streak & recovery notifications",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val);
                },
                thumbColor: const WidgetStatePropertyAll<Color>(AppTheme.primary),
                activeTrackColor: AppTheme.primary.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Find Coaches Shortcut
        _buildActionTile(
          icon: Icons.sports_rounded,
          title: "Find a Personal Coach",
          subtitle: "Browse certified trainers and specialists",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FindCoachScreen()),
            );
          },
        ),
        const SizedBox(height: 10),

        // Log Out Tile
        _buildActionTile(
          icon: Icons.logout_rounded,
          title: "Log Out",
          subtitle: "Sign out of your FitPulse account",
          iconColor: Colors.redAccent,
          textColor: Colors.redAccent,
          onTap: _showLogoutDialog,
        ),
      ],
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
  }) {
    final effectiveIconColor = iconColor ?? AppTheme.primary;
    final effectiveTextColor = textColor ?? AppTheme.textDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
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
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing else const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
