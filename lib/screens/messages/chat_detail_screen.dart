import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import 'message_models.dart';

class ChatDetailScreen extends StatefulWidget {
  final ConversationItem conversation;

  const ChatDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    if (animated) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final newMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_me',
      senderName: 'You',
      isMe: true,
      text: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMsg);
      _textController.clear();
      _isTyping = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate realistic coach response after a brief delay if talking to a coach
    if (widget.conversation.isCoach) {
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        final coachReply = ChatMessage(
          id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
          senderId: widget.conversation.id,
          senderName: widget.conversation.contactName,
          isMe: false,
          text: _generateCoachAutoReply(text),
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(coachReply);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    }
  }

  String _generateCoachAutoReply(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('warm') || lower.contains('start') || lower.contains('ready')) {
      return "Awesome energy! Stick closely to the working sets and keep your rest intervals under 90 seconds. Let me know how it feels!";
    } else if (lower.contains('pain') || lower.contains('hurt') || lower.contains('sore')) {
      return "Good flag! If you feel any joint pinch rather than muscle burn, stop immediately and drop the weight by 20%. Form and safety first.";
    } else if (lower.contains('protein') || lower.contains('food') || lower.contains('eat') || lower.contains('meal')) {
      return "Got it! Keep prioritizing whole food protein sources and time your largest carb meal around your workout window.";
    }
    return "Received loud and clear! I'll review your feedback during our evening check-in. Keep up the high standard! 💪";
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                const SizedBox(height: 18),
                Text(
                  'Share with Coach',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAttachmentOption(
                  icon: Icons.videocam_rounded,
                  title: 'Form Check Video',
                  subtitle: 'Send a clip of your top squat, deadlift, or bench set',
                  color: AppTheme.primary,
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form check video uploader will be enabled in next update!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildAttachmentOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Progress Photo',
                  subtitle: 'Share weekly physique or meal prep check-in',
                  color: AppTheme.accentOrange,
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo check-in upload feature selected.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildAttachmentOption(
                  icon: Icons.fitness_center_rounded,
                  title: 'Workout Log Link',
                  subtitle: 'Attach today’s completed workout summary',
                  color: AppTheme.accentPurple,
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Workout session summary linked!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF141714),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: color, size: 22),
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
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showPlanDetailModal(PlanPreviewData plan, MessageType type) {
    final isWorkout = type == MessageType.workoutPlanAssigned;
    final themeColor = isWorkout ? AppTheme.primary : AppTheme.accentOrange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: themeColor.withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isWorkout ? Icons.fitness_center_rounded : Icons.restaurant_rounded,
                              size: 14,
                              color: themeColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isWorkout ? 'OFFICIAL WORKOUT PLAN' : 'OFFICIAL MEAL PLAN',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: themeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Plan Title
                  Text(
                    plan.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metrics Pill Grid
                  Row(
                    children: [
                      _buildMetricTile(
                        icon: Icons.timer_outlined,
                        label: isWorkout ? 'Duration' : 'Daily Target',
                        val: plan.durationOrKcal,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricTile(
                        icon: Icons.bolt_rounded,
                        label: isWorkout ? 'Focus Target' : 'Macro Split',
                        val: plan.focusOrMacros,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildMetricTile(
                    icon: Icons.calendar_today_rounded,
                    label: isWorkout ? 'Schedule' : 'Meal Structure',
                    val: plan.frequencyOrSplit,
                  ),
                  const SizedBox(height: 20),

                  // Coach Notes Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141714),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tips_and_updates_rounded,
                                size: 16, color: AppTheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              "Coach ${widget.conversation.contactName}'s Strategy",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          plan.coachNotes,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            height: 1.4,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Content Items
                  Text(
                    isWorkout ? 'Included Exercises & Protocol' : 'Structured Daily Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...plan.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161916),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.surfaceBorder.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: themeColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWorkout
                                  ? 'Active workout plan updated to ${plan.title}!'
                                  : 'Active nutrition target updated to ${plan.title}!',
                            ),
                            backgroundColor: themeColor.withValues(alpha: 0.9),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: const Color(0xFF0D0F0D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isWorkout ? 'Start Workout Program' : 'Activate Nutrition Plan',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF0D0F0D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String val,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF141714),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              val,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.backgroundDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar with online status ring
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  child: Image.network(
                    widget.conversation.contactAvatar,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        widget.conversation.contactName.isNotEmpty
                            ? widget.conversation.contactName[0]
                            : 'C',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.conversation.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.backgroundDark, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.conversation.contactName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    if (widget.conversation.isCoach) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'COACH',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                if (widget.conversation.contactSpecialty != null)
                  Text(
                    widget.conversation.contactSpecialty!,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  )
                else
                  Text(
                    widget.conversation.isOnline ? 'Online now' : 'Offline',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: widget.conversation.isOnline ? AppTheme.primary : AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, color: AppTheme.textSecondary, size: 22),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Coach Profile: ${widget.conversation.contactName} (${widget.conversation.contactSpecialty ?? "Trainer"})',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppTheme.surfaceBorder,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isPreviousSameSender =
            index > 0 && _messages[index - 1].isMe == message.isMe;

        // Subtle entrance animation using flutter_animate
        return _buildMessageItem(message, isPreviousSameSender)
            .animate()
            .fadeIn(duration: 280.ms, curve: Curves.easeOut)
            .slideY(begin: 0.12, end: 0, duration: 280.ms, curve: Curves.easeOut);
      },
    );
  }

  Widget _buildMessageItem(ChatMessage message, bool isPreviousSameSender) {
    // If it's a special plan assignment card
    if (message.type == MessageType.workoutPlanAssigned ||
        message.type == MessageType.mealPlanAssigned) {
      return _buildPlanAssignedCard(message);
    }

    final isMe = message.isMe;
    final timeStr = _formatTimestamp(message.timestamp);

    return Padding(
      padding: EdgeInsets.only(
        top: isPreviousSameSender ? 4 : 12,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for received messages (optional if grouped)
              if (!isMe && !isPreviousSameSender) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    widget.conversation.contactAvatar,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 28,
                      height: 28,
                      color: AppTheme.surfaceLighter,
                      child: Center(
                        child: Text(
                          widget.conversation.contactName.isNotEmpty
                              ? widget.conversation.contactName[0]
                              : 'C',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ] else if (!isMe) ...[
                const SizedBox(width: 36),
              ],

              // Bubble Container
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primary : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    border: Border.all(
                      color: isMe
                          ? AppTheme.primary
                          : AppTheme.surfaceBorder,
                      width: 1,
                    ),
                    boxShadow: isMe
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: isMe ? FontWeight.w600 : FontWeight.w400,
                      height: 1.35,
                      color: isMe ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Subtle timestamp below bubble
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 36,
              right: isMe ? 4 : 0,
              top: 3,
            ),
            child: Text(
              timeStr,
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanAssignedCard(ChatMessage message) {
    final plan = message.plan;
    if (plan == null) return const SizedBox.shrink();

    final isWorkout = message.type == MessageType.workoutPlanAssigned;
    final accentColor = isWorkout ? AppTheme.primary : AppTheme.accentOrange;
    final timeStr = _formatTimestamp(message.timestamp);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tag
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.35)),
                ),
                child: Icon(
                  isWorkout ? Icons.fitness_center_rounded : Icons.restaurant_menu_rounded,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWorkout ? 'WORKOUT PLAN ASSIGNED' : 'MEAL PLAN ASSIGNED',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'Assigned by ${message.senderName}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                timeStr,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Plan Title & Description
          Text(
            plan.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            plan.subtitle,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Tag chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildSmallBadge(plan.durationOrKcal, accentColor),
              _buildSmallBadge(plan.focusOrMacros, AppTheme.textSecondary),
              _buildSmallBadge(plan.frequencyOrSplit, AppTheme.textSecondary),
            ],
          ),
          const SizedBox(height: 14),

          // View Plan CTA
          InkWell(
            onTap: () => _showPlanDetailModal(plan, message.type),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Plan Details',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFF141714),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.textSecondary, size: 26),
            tooltip: 'Share clip or log',
            onPressed: _showAttachmentSheet,
          ),
          const SizedBox(width: 4),

          // Message Text Field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFF131613),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.surfaceBorder, width: 1),
              ),
              child: TextField(
                controller: _textController,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppTheme.textDark,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  final typing = val.trim().isNotEmpty;
                  if (typing != _isTyping) {
                    setState(() {
                      _isTyping = typing;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Message ${widget.conversation.contactName}...',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isTyping ? AppTheme.primary : AppTheme.surfaceLighter,
                shape: BoxShape.circle,
                boxShadow: _isTyping
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.send_rounded,
                size: 20,
                color: _isTyping ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24 && time.day == now.day) {
      final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      final period = time.hour >= 12 ? 'PM' : 'AM';
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
