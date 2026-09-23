import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../models/progress_models.dart';

class ProgressPhotosSection extends StatelessWidget {
  final List<ProgressPhoto> photos;
  final Function(ProgressPhoto newPhoto) onPhotoAdded;

  const ProgressPhotosSection({
    super.key,
    required this.photos,
    required this.onPhotoAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: AppTheme.accentPurple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Progress Photos',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            Text(
              '${photos.length} Logs',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Horizontal Scrollable Cards
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: photos.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              if (index < photos.length) {
                final photo = photos[index];
                return _buildPhotoCard(context, photo, index);
              } else {
                return _buildAddPhotoTile(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(BuildContext context, ProgressPhoto photo, int index) {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${monthNames[photo.date.month - 1]} ${photo.date.day}';

    return GestureDetector(
      onTap: () => _showPhotoDetailModal(context, photo),
      child: Container(
        width: 145,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.surfaceBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Content (Network or Memory)
            if (photo.imageBytes != null)
              Image.memory(
                photo.imageBytes!,
                fit: BoxFit.cover,
              )
            else if (photo.imageUrl != null)
              Image.network(
                photo.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: AppTheme.surfaceLighter,
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded, color: AppTheme.textSecondary),
                  ),
                ),
              )
            else
              Container(
                color: AppTheme.surfaceLighter,
                child: const Center(
                  child: Icon(Icons.person_rounded, color: AppTheme.textSecondary, size: 40),
                ),
              ),

            // Gradient Overlay for Readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),

            // Top Badges: Date & Weight
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0F0D).withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      dateStr,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      '${photo.weight.toStringAsFixed(1)} kg',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Caption
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.touch_app_rounded, color: AppTheme.textSecondary, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        'Tap to inspect',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 70).ms, duration: 350.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildAddPhotoTile(BuildContext context) {
    return InkWell(
      onTap: () => _pickAndAddPhoto(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF131613),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: AppTheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Photo',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Log physique update',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndAddPhoto(BuildContext context) async {
    final picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                Text(
                  'Add Progress Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Capture your transformation milestones with private progress photos.',
                  style: GoogleFonts.manrope(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppTheme.primary),
                  ),
                  title: Text(
                    'Take a Photo',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  subtitle: Text(
                    'Use device camera',
                    style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                const Divider(color: AppTheme.surfaceBorder, height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppTheme.accentOrange),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  subtitle: Text(
                    'Pick from your photos',
                    style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final XFile? file = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1440,
        imageQuality: 85,
      );

      if (file != null) {
        final Uint8List bytes = await file.readAsBytes();
        if (!context.mounted) return;

        // Prompt for quick caption/weight
        final newPhoto = await _promptPhotoDetails(context, bytes);
        if (newPhoto != null) {
          onPhotoAdded(newPhoto);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20),
                    SizedBox(width: 8),
                    Text('Progress photo added!'),
                  ],
                ),
                backgroundColor: AppTheme.surfaceLighter,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.surfaceBorder),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<ProgressPhoto?> _promptPhotoDetails(BuildContext context, Uint8List bytes) async {
    final captionController = TextEditingController(text: 'Week ${photos.length + 1} Update');
    final weightController = TextEditingController(text: '73.8');

    return showDialog<ProgressPhoto>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppTheme.surfaceBorder),
          ),
          title: Text(
            'Photo Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: captionController,
                style: GoogleFonts.poppins(color: AppTheme.textDark, fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Caption / Milestone',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.poppins(color: AppTheme.textDark, fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Current Weight (kg)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final weightVal = double.tryParse(weightController.text.trim()) ?? 73.8;
                final newPhoto = ProgressPhoto(
                  id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
                  caption: captionController.text.trim().isEmpty
                      ? 'Progress Update'
                      : captionController.text.trim(),
                  date: DateTime.now(),
                  weight: weightVal,
                  imageBytes: bytes,
                  note: 'Physique checkpoint logged from camera/gallery.',
                );
                Navigator.pop(dialogCtx, newPhoto);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
              ),
              child: Text(
                'Add Photo',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoDetailModal(BuildContext context, ProgressPhoto photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo.caption,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Logged on ${photo.date.day}/${photo.date.month}/${photo.date.year}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${photo.weight.toStringAsFixed(1)} kg',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Image Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: photo.imageBytes != null
                        ? Image.memory(
                            photo.imageBytes!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : (photo.imageUrl != null
                            ? Image.network(
                                photo.imageUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 260,
                                color: AppTheme.surfaceLighter,
                                child: const Icon(Icons.image, size: 60, color: AppTheme.textSecondary),
                              )),
                  ),

                  if (photo.note != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141714),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_rounded, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              photo.note!,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppTheme.textDark,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
