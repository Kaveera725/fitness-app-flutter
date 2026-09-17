import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/coach.dart';
import '../../theme/app_theme.dart';
import '../../widgets/coach_review_card.dart';
import '../../widgets/status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Coach Profile Screen (Coach's own profile management & performance overview)
// ─────────────────────────────────────────────────────────────────────────────

class CoachProfileScreen extends StatefulWidget {
  final String coachName;
  final String? initialAvatarUrl;

  const CoachProfileScreen({
    super.key,
    this.coachName = 'Marcus Vance',
    this.initialAvatarUrl,
  });

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  // ── Form Controllers & State ────────────────────────────────────────────────
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _bioController;
  late int _experienceYears;
  late String _avatarUrl;
  late bool _acceptingNewClients;
  late List<String> _certifications;

  // Rating breakdown filter: 0: All, 1: 5-star, 2: 4-star
  int _selectedReviewFilter = 0;

  // Preset avatar URLs for quick selection
  final List<String> _avatarPresets = const [
    'https://i.pravatar.cc/150?img=3',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&q=80',
  ];

  // Specialty suggestions
  final List<String> _specialtyOptions = const [
    'Hypertrophy & Strength Conditioning',
    'Body Recomposition & Fat Loss',
    'Athletic Performance & Speed',
    'Mobility & Post-Rehab Training',
    'Powerlifting & Compound Mechanics',
  ];

  // Dummy performance numbers
  final double _overallRating = 4.9;
  final int _totalReviews = 148;
  final int _totalClientsCoached = 214;
  final int _activeClientsCount = 6;
  final int _maxClientsCapacity = 8;
  final String _responseRate = '99%';
  final String _avgResponseTime = '< 15 min';

  // Star breakdown percentages (5★, 4★, 3★, 2★, 1★)
  final Map<int, double> _starBreakdown = const {
    5: 0.86,
    4: 0.11,
    3: 0.02,
    2: 0.01,
    1: 0.00,
  };

  // Realistic sample client reviews
  late List<Review> _clientReviews;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coachName);
    _specialtyController =
        TextEditingController(text: 'Hypertrophy & Strength Conditioning');
    _bioController = TextEditingController(
      text:
          'Former collegiate athlete and CSCS-certified coach specializing in evidence-based hypertrophy, posture restoration, and functional athletic longevity. 7+ years guiding busy executives and lifters to sustainable, PR-breaking physiques.',
    );
    _experienceYears = 7;
    _avatarUrl = widget.initialAvatarUrl ?? 'https://i.pravatar.cc/150?img=3';
    _acceptingNewClients = true;
    _certifications = [
      'NSCA - CSCS',
      'NASM - CPT',
      'Precision Nutrition L1',
      'USA Weightlifting L1',
      'FMS Certified',
    ];

    _clientReviews = [
      Review(
        reviewer: 'Sarah Jenkins',
        rating: 5.0,
        comment:
            'Marcus is an incredible coach! He customized my routine around a prior knee injury, and I hit a 52.5 kg bench PR last week. Super responsive on nutrition cues and form check videos.',
        date: '2 days ago',
        avatarUrl: 'https://i.pravatar.cc/150?img=47',
      ),
      Review(
        reviewer: 'David Chen',
        rating: 5.0,
        comment:
            'The customized macro breakdown and weekly check-ins kept me accountable during my 12-week cut. Down 5.8 kg with zero strength loss. Best coaching experience on FitPulse!',
        date: '1 week ago',
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
      ),
      Review(
        reviewer: 'Emma Watson',
        rating: 5.0,
        comment:
            'Best investment in my fitness journey. The cues on Romanian deadlifts and compound lifts gave me the confidence to lift heavy again without lower back tightness.',
        date: '2 weeks ago',
        avatarUrl: 'https://i.pravatar.cc/150?img=23',
      ),
      Review(
        reviewer: 'Olivia Martinez',
        rating: 4.0,
        comment:
            'Very thorough programming and great attention to detail. Fast replies to all my meal plan substitution questions even on busy weekends.',
        date: '3 weeks ago',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
      ),
      Review(
        reviewer: 'James Liu',
        rating: 5.0,
        comment:
            'Top-tier programming. The athletic speed and plyometrics track gave me noticeable vertical jump improvements and overall court stamina.',
        date: '1 month ago',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ── Avatar Change Bottom Sheet ──────────────────────────────────────────────
  void _openAvatarPicker() {
    final customUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 16),
              Text(
                'Change Profile Photo',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                'Select a preset avatar or paste an image URL',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              // Presets horizontal row
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatarPresets.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, i) {
                    final url = _avatarPresets[i];
                    final isSelected = _avatarUrl == url;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _avatarUrl = url);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentGreen
                                : AppTheme.surfaceBorder,
                            width: isSelected ? 3 : 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppTheme.surfaceLighter,
                              child: const Icon(Icons.person,
                                  color: AppTheme.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: customUrlController,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'https://example.com/coach_photo.jpg',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLighter,
                  prefixIcon: const Icon(Icons.link_rounded,
                      size: 18, color: AppTheme.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.accentGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: AppTheme.backgroundDark,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final custom = customUrlController.text.trim();
                    if (custom.isNotEmpty) {
                      setState(() => _avatarUrl = custom);
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Apply Custom Photo',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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

  // ── Add Certification Dialog ────────────────────────────────────────────────
  void _openAddCertDialog() {
    final certController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.surfaceBorder),
          ),
          title: Text(
            'Add Certification',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter certification title (e.g. NASM-CES, Precision Nutrition L2)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: certController,
                autofocus: true,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Certification Name',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLighter,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.accentGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                foregroundColor: AppTheme.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final text = certController.text.trim();
                if (text.isNotEmpty && !_certifications.contains(text)) {
                  setState(() {
                    _certifications.add(text);
                  });
                }
                Navigator.pop(ctx);
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Preview Public Directory Card Modal ──────────────────────────────────────
  void _openPublicPreviewModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Public Directory Preview',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLighter,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Trainee View',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Mock public directory preview card
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(17)),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              _avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                color: AppTheme.surfaceDark,
                                child: const Icon(Icons.person,
                                    size: 48,
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '$_overallRating ($_totalReviews)',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: _acceptingNewClients
                              ? StatusBadge.active(label: 'Accepting Clients')
                              : StatusBadge.pending(label: 'Roster Paused'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.trim().isEmpty
                                ? 'Coach'
                                : _nameController.text.trim(),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            _specialtyController.text.trim(),
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _bioController.text.trim(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: _certifications
                                .take(3)
                                .map((c) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceDark,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppTheme.surfaceBorder),
                                      ),
                                      child: Text(
                                        c,
                                        style: GoogleFonts.manrope(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Close Preview',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
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

  // ── Save Profile Changes ────────────────────────────────────────────────────
  void _saveChanges() {
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.accentGreen, width: 1.5),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppTheme.accentGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 16, color: AppTheme.backgroundDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Saved Successfully',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    'Your public coach directory profile has been updated.',
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Filtered Reviews ────────────────────────────────────────────────────────
  List<Review> get _filteredReviews {
    if (_selectedReviewFilter == 1) {
      return _clientReviews.where((r) => r.rating >= 4.8).toList();
    } else if (_selectedReviewFilter == 2) {
      return _clientReviews
          .where((r) => r.rating >= 3.8 && r.rating < 4.8)
          .toList();
    }
    return _clientReviews;
  }

  // ── Build Method ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Coach Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppTheme.textDark,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _openPublicPreviewModal,
            icon: const Icon(Icons.visibility_outlined,
                size: 16, color: AppTheme.accentGreen),
            label: Text(
              'Preview',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentGreen,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Availability Status Banner
            _buildAvailabilityCard()
                .animate()
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // 2. Editable Public Profile Section
            _buildPublicProfileSection()
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 28),

            // 3. Performance Overview (Read-only Stats)
            _buildPerformanceSection()
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 28),

            // 4. Client Reviews Section
            _buildReviewsSection()
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  // ── 1. Availability Card ────────────────────────────────────────────────────
  Widget _buildAvailabilityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _acceptingNewClients
              ? AppTheme.accentGreen.withValues(alpha: 0.35)
              : AppTheme.accentOrange.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_acceptingNewClients
                      ? AppTheme.accentGreen
                      : AppTheme.accentOrange)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _acceptingNewClients
                  ? Icons.person_add_alt_1_rounded
                  : Icons.pause_circle_outline_rounded,
              color: _acceptingNewClients
                  ? AppTheme.accentGreen
                  : AppTheme.accentOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Accepting New Clients',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (_acceptingNewClients
                                ? AppTheme.accentGreen
                                : AppTheme.accentOrange)
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _acceptingNewClients ? 'Open' : 'Paused',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _acceptingNewClients
                              ? AppTheme.accentGreen
                              : AppTheme.accentOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _acceptingNewClients
                      ? 'Current Roster: $_activeClientsCount/$_maxClientsCapacity trainees (Accepting 2 more)'
                      : 'Roster full or paused. Trainees cannot request new plans.',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _acceptingNewClients,
            activeTrackColor:
                AppTheme.accentGreen.withValues(alpha: 0.5),
            activeThumbColor: AppTheme.accentGreen,
            onChanged: (val) {
              setState(() => _acceptingNewClients = val);
            },
          ),
        ],
      ),
    );
  }

  // ── 2. Editable Public Profile Section ──────────────────────────────────────
  Widget _buildPublicProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Public Profile Info',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Visible to Trainees',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Profile Photo with Tap-to-Change
          Center(
            child: GestureDetector(
              onTap: _openAvatarPicker,
              child: Stack(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accentGreen,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppTheme.surfaceLighter,
                          child: const Icon(Icons.person,
                              size: 44, color: AppTheme.textSecondary),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 15,
                        color: AppTheme.backgroundDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: _openAvatarPicker,
              child: Text(
                'Change Profile Photo',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Full Name Field
          _fieldLabel('Coach Name'),
          _buildTextField(
            controller: _nameController,
            hint: 'e.g. Marcus Vance',
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: 14),

          // Specialty Field with Quick Suggestions
          _fieldLabel('Primary Specialty'),
          _buildTextField(
            controller: _specialtyController,
            hint: 'e.g. Hypertrophy & Strength Conditioning',
            prefixIcon: Icons.fitness_center_rounded,
          ),
          const SizedBox(height: 6),
          // Specialty suggestions chip row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _specialtyOptions.map((opt) {
              final isCurrent = _specialtyController.text == opt;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _specialtyController.text = opt;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppTheme.accentGreen.withValues(alpha: 0.15)
                        : AppTheme.surfaceLighter,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent
                          ? AppTheme.accentGreen
                          : AppTheme.surfaceBorder,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent
                          ? AppTheme.accentGreen
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Experience Years & Capacity Row
          _fieldLabel('Years of Coaching Experience'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLighter,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded,
                        size: 18, color: AppTheme.accentGreen),
                    const SizedBox(width: 10),
                    Text(
                      '$_experienceYears Years Professional Experience',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded,
                          size: 20, color: AppTheme.textSecondary),
                      onPressed: _experienceYears > 1
                          ? () => setState(() => _experienceYears--)
                          : null,
                    ),
                    Text(
                      '$_experienceYears',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded,
                          size: 20, color: AppTheme.accentGreen),
                      onPressed: () => setState(() => _experienceYears++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bio Field
          _fieldLabel('Bio & Coaching Philosophy'),
          TextField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 300,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppTheme.textDark,
              height: 1.45,
            ),
            decoration: InputDecoration(
              hintText:
                  'Describe your coaching methodology, background, and what clients can expect...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              filled: true,
              fillColor: AppTheme.surfaceLighter,
              counterStyle: GoogleFonts.manrope(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.accentGreen,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Certifications Chip List with Add/Remove
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fieldLabel('Certifications & Credentials'),
              GestureDetector(
                onTap: _openAddCertDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_rounded,
                          size: 14, color: AppTheme.accentGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Add Cert',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._certifications.map(
                (c) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLighter,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.surfaceBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 13, color: AppTheme.accentGreen),
                      const SizedBox(width: 6),
                      Text(
                        c,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _certifications.remove(c);
                          });
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. Performance Overview Section ─────────────────────────────────────────
  Widget _buildPerformanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Overview',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Top 5% Coach',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Rating + Breakdown Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Big Display
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLighter,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_overallRating',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.accentGreen,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (_) => const Icon(Icons.star_rounded,
                            size: 15, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_totalReviews reviews',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Star Breakdown Bar Chart (5★ to 1★)
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((stars) {
                    final pct = _starBreakdown[stars] ?? 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        children: [
                          Text(
                            '$stars★',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: AppTheme.surfaceLighter,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  stars >= 4
                                      ? AppTheme.accentGreen
                                      : Colors.amber,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${(pct * 100).toInt()}%',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 4 Compact Stats in a 2x2 Grid
          Row(
            children: [
              Expanded(
                child: _performanceStatCard(
                  icon: Icons.people_alt_rounded,
                  iconColor: AppTheme.accentGreen,
                  label: 'Total Coached',
                  value: '$_totalClientsCoached',
                  sub: 'All-time trainees',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _performanceStatCard(
                  icon: Icons.sports_gymnastics_rounded,
                  iconColor: const Color(0xFF00E5FF),
                  label: 'Active Clients',
                  value: '$_activeClientsCount',
                  sub: 'Current active roster',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _performanceStatCard(
                  icon: Icons.mark_chat_read_rounded,
                  iconColor: AppTheme.accentOrange,
                  label: 'Response Rate',
                  value: _responseRate,
                  sub: 'Messages answered',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _performanceStatCard(
                  icon: Icons.timer_outlined,
                  iconColor: const Color(0xFFB388FF),
                  label: 'Avg Response',
                  value: _avgResponseTime,
                  sub: 'Direct client chats',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _performanceStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.manrope(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Client Reviews Section ───────────────────────────────────────────────
  Widget _buildReviewsSection() {
    final reviews = _filteredReviews;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Client Reviews',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLighter,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_clientReviews.length}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ),
                ],
              ),
              // Star Filter Buttons
              Row(
                children: [
                  _reviewFilterPill('All', 0),
                  const SizedBox(width: 6),
                  _reviewFilterPill('5★', 1),
                  const SizedBox(width: 6),
                  _reviewFilterPill('4★', 2),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reusable CoachReviewCard instances
          if (reviews.isNotEmpty)
            ...reviews.map((r) => CoachReviewCard(
                  review: r,
                  isDark: true,
                  margin: const EdgeInsets.only(bottom: 12),
                ))
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No reviews matching this rating filter',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _reviewFilterPill(String label, int index) {
    final isSelected = _selectedReviewFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedReviewFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentGreen
              : AppTheme.surfaceLighter,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppTheme.backgroundDark
                : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Bottom Save Action Bar ──────────────────────────────────────────────────
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: const Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              foregroundColor: AppTheme.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppTheme.accentGreen.withValues(alpha: 0.4),
            ),
            onPressed: _saveChanges,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 20, color: AppTheme.backgroundDark),
                const SizedBox(width: 8),
                Text(
                  'Save Profile Changes',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.backgroundDark,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────────
  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.manrope(
        fontSize: 13,
        color: AppTheme.textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
        filled: true,
        fillColor: AppTheme.surfaceLighter,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppTheme.textSecondary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.accentGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
