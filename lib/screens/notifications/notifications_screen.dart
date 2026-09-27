import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/milestone_celebration_modal.dart';
import '../messages/chat_detail_screen.dart';
import '../messages/message_models.dart';
import '../subscription/subscription_screen.dart';
import '../workout_library_screen.dart';
import 'models/notification_model.dart';

/// Notifications Screen for FitPulse
/// Grouped by recency: Today, This Week, Earlier
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _notifications;
  String _selectedFilter = "All"; // "All", "Unread", "Coach", "System"

  @override
  void initState() {
    super.initState();
    _notifications = getInitialMockNotifications();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    if (_unreadCount == 0) return;
    HapticFeedback.lightImpact();
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.primary, width: 1),
        ),
        content: Row(
          children: [
            const Icon(Icons.done_all_rounded, color: AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            Text(
              "All notifications marked as read",
              style: GoogleFonts.manrope(color: AppTheme.textDark, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markSingleAsRead(NotificationItem item) {
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
    }
  }

  void _deleteNotification(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  void _resetNotifications() {
    HapticFeedback.mediumImpact();
    setState(() {
      _notifications = getInitialMockNotifications();
    });
  }

  void _handleNotificationTap(NotificationItem item) {
    _markSingleAsRead(item);
    HapticFeedback.selectionClick();

    switch (item.category) {
      case NotificationCategory.achievement:
        MilestoneCelebrationModal.show(
          context,
          badgeTitle: "Iron Pumper III",
          badgeDescription: "Crushed 5,000 kg total volume with barbell!",
          badgeIcon: Icons.military_tech_rounded,
          badgeColor: AppTheme.accentPurple,
          xpReward: 200,
        );
        break;

      case NotificationCategory.coachMessage:
        final mockList = DummyMessageData.getInitialConversations();
        final conv = mockList.isNotEmpty
            ? mockList.first
            : ConversationItem(
                id: 'conv_elena',
                contactName: 'Elena Vance',
                contactAvatar:
                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=120&q=80',
                contactSpecialty: 'Strength & Conditioning',
                isCoach: true,
                isOnline: true,
                lastMessage: item.body,
                lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
                unreadCount: 0,
                messages: [
                  ChatMessage(
                    id: 'm1',
                    senderId: 'coach_elena',
                    senderName: 'Elena Vance',
                    isMe: false,
                    text: item.body,
                    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
                  ),
                ],
              );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(conversation: conv),
          ),
        );
        break;

      case NotificationCategory.subscription:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SubscriptionScreen(),
          ),
        );
        break;

      case NotificationCategory.planAssigned:
      case NotificationCategory.streakAtRisk:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WorkoutLibraryScreen(),
          ),
        );
        break;

      case NotificationCategory.mealPlanAssigned:
      case NotificationCategory.coachReview:
      case NotificationCategory.community:
        _showSimulatedDetailSheet(item);
        break;
    }
  }

  void _showSimulatedDetailSheet(NotificationItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppTheme.surfaceBorder, width: 1.2),
          ),
        ),
        child: SafeArea(
          top: false,
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: item.accentColor,
                          ),
                        ),
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.body,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.accentColor,
                    foregroundColor: const Color(0xFF0D0F0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    item.actionLabel ?? "Got It",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: item.accentColor == AppTheme.primary
                          ? const Color(0xFF0D0F0D)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<NotificationItem> _getFilteredNotifications() {
    return _notifications.where((n) {
      if (_selectedFilter == "Unread") return !n.isRead;
      if (_selectedFilter == "Coach") {
        return n.category == NotificationCategory.planAssigned ||
            n.category == NotificationCategory.coachMessage ||
            n.category == NotificationCategory.mealPlanAssigned ||
            n.category == NotificationCategory.coachReview;
      }
      if (_selectedFilter == "System") {
        return n.category == NotificationCategory.streakAtRisk ||
            n.category == NotificationCategory.achievement ||
            n.category == NotificationCategory.subscription ||
            n.category == NotificationCategory.community;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredNotifications();

    final todayItems = filtered.where((n) => n.recency == RecencyGroup.today).toList();
    final thisWeekItems = filtered.where((n) => n.recency == RecencyGroup.thisWeek).toList();
    final earlierItems = filtered.where((n) => n.recency == RecencyGroup.earlier).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Filter Chips Row
          _buildFilterChips(),

          // Main notifications list or empty state
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (todayItems.isNotEmpty) ...[
                        _buildSectionHeader("TODAY", todayItems.length),
                        ...todayItems.asMap().entries.map(
                              (entry) => _buildNotificationCard(entry.value, entry.key * 70),
                            ),
                        const SizedBox(height: 18),
                      ],
                      if (thisWeekItems.isNotEmpty) ...[
                        _buildSectionHeader("THIS WEEK", thisWeekItems.length),
                        ...thisWeekItems.asMap().entries.map(
                              (entry) => _buildNotificationCard(
                                entry.value,
                                (todayItems.length + entry.key) * 70,
                              ),
                            ),
                        const SizedBox(height: 18),
                      ],
                      if (earlierItems.isNotEmpty) ...[
                        _buildSectionHeader("EARLIER", earlierItems.length),
                        ...earlierItems.asMap().entries.map(
                              (entry) => _buildNotificationCard(
                                entry.value,
                                (todayItems.length + thisWeekItems.length + entry.key) * 70,
                              ),
                            ),
                        const SizedBox(height: 18),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    final hasUnread = _unreadCount > 0;

    return AppBar(
      backgroundColor: AppTheme.backgroundDark,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        color: AppTheme.textDark,
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: "Back",
      ),
      title: Row(
        children: [
          Text(
            "Notifications",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          if (hasUnread) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$_unreadCount new",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D0F0D),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: hasUnread ? _markAllAsRead : null,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primary,
            disabledForegroundColor: AppTheme.textMuted,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            "Mark all as read",
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: hasUnread ? AppTheme.primary : AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildFilterChips() {
    final filters = ["All", "Unread", "Coach", "System"];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = filters[i];
          final isSelected = _selectedFilter == filter;
          int badgeNum = 0;
          if (filter == "All") badgeNum = _notifications.length;
          if (filter == "Unread") badgeNum = _unreadCount;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    filter,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textDark,
                    ),
                  ),
                  if (badgeNum > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D0F0D).withValues(alpha: 0.18)
                            : AppTheme.surfaceLighter,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$badgeNum",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.surfaceBorder, width: 0.8),
            ),
            child: Text(
              "$count",
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATION CARD
  // ---------------------------------------------------------------------------
  Widget _buildNotificationCard(NotificationItem item, int delayMs) {
    final isUnread = !item.isRead;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(item.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isUnread
              ? AppTheme.surfaceDark.withValues(alpha: 0.95)
              : AppTheme.surfaceDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? item.accentColor.withValues(alpha: 0.35)
                : AppTheme.surfaceBorder,
            width: isUnread ? 1.2 : 0.8,
          ),
          boxShadow: isUnread
              ? [
                  BoxShadow(
                    color: item.accentColor.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _handleNotificationTap(item),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading Icon with color badge
                  Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item.accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: item.accentColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.accentColor,
                          size: 22,
                        ),
                      ),
                      if (isUnread)
                        Positioned(
                          top: -1,
                          right: -1,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.backgroundDark,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Center Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Pill + Time Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.categoryLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: item.accentColor,
                              ),
                            ),
                            Text(
                              item.timeAgo,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isUnread ? AppTheme.textSecondary : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Title
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                            color: isUnread ? AppTheme.textDark : AppTheme.textDark.withValues(alpha: 0.85),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Body description
                        Text(
                          item.body,
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            height: 1.4,
                            color: isUnread ? AppTheme.textSecondary : AppTheme.textMuted,
                          ),
                        ),

                        // Sender tag or action preview
                        if (item.senderName != null || item.actionLabel != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (item.senderName != null)
                                Row(
                                  children: [
                                    if (item.senderAvatar != null) ...[
                                      CircleAvatar(
                                        radius: 9,
                                        backgroundImage: NetworkImage(item.senderAvatar!),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Text(
                                      item.senderName!,
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                const SizedBox.shrink(),

                              if (item.actionLabel != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.actionLabel!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: item.accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 9,
                                      color: item.accentColor,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 350.ms)
        .slideY(begin: 0.08, end: 0, duration: 350.ms);
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceDark,
                border: Border.all(color: AppTheme.surfaceBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: AppTheme.textSecondary,
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            Text(
              "All Caught Up!",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _selectedFilter == "All"
                  ? "You don't have any notifications right now. Keep crushing your workouts and we'll keep you posted."
                  : "No $_selectedFilter notifications found right now.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _resetNotifications,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Reset Sample Notifications"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceLighter,
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.surfaceBorder),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
