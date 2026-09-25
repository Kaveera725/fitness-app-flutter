import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../coaches/find_coach_screen.dart';
import 'chat_detail_screen.dart';
import 'message_models.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() => _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  late List<ConversationItem> _conversations;
  String _selectedFilter = 'All'; // 'All', 'Unread', 'Coaches'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _forceEmptyStateForDemo = false;

  @override
  void initState() {
    super.initState();
    _conversations = DummyMessageData.getInitialConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ConversationItem> get _filteredConversations {
    if (_forceEmptyStateForDemo) {
      return [];
    }

    return _conversations.where((conv) {
      // Filter tab
      if (_selectedFilter == 'Unread' && conv.unreadCount == 0) {
        return false;
      }
      if (_selectedFilter == 'Coaches' && !conv.isCoach) {
        return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = conv.contactName.toLowerCase().contains(query);
        final specialtyMatch =
            conv.contactSpecialty?.toLowerCase().contains(query) ?? false;
        final messageMatch = conv.lastMessage.toLowerCase().contains(query);
        return nameMatch || specialtyMatch || messageMatch;
      }

      return true;
    }).toList();
  }

  void _openChat(ConversationItem conversation) async {
    // Mark as read locally
    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1 && conversation.unreadCount > 0) {
      setState(() {
        _conversations[index] = conversation.copyWith(unreadCount: 0);
      });
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(conversation: conversation),
      ),
    );

    // Refresh state when coming back
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredConversations;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter controls
            _buildSearchAndFilters(),

            // Conversation list or Empty state
            Expanded(
              child: list.isEmpty ? _buildEmptyState() : _buildConversationsList(list),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final totalUnread = _conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);

    return AppBar(
      backgroundColor: AppTheme.backgroundDark,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Text(
            'Messages',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: -0.3,
            ),
          ),
          if (totalUnread > 0 && !_forceEmptyStateForDemo) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalUnread new',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0F0D),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        // Demo toggle to view empty state
        Tooltip(
          message: _forceEmptyStateForDemo ? 'Show conversations' : 'Preview empty state',
          child: IconButton(
            icon: Icon(
              _forceEmptyStateForDemo
                  ? Icons.visibility_rounded
                  : Icons.speaker_notes_off_outlined,
              color: _forceEmptyStateForDemo ? AppTheme.primary : AppTheme.textSecondary,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _forceEmptyStateForDemo = !_forceEmptyStateForDemo;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_add_alt_1_rounded,
              color: AppTheme.textDark, size: 22),
          tooltip: 'Find new coach',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FindCoachScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Search input
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF141714),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder, width: 1),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppTheme.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Search coaches, topics or messages...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppTheme.textSecondary, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: [
              _buildFilterChip('All'),
              const SizedBox(width: 8),
              _buildFilterChip('Unread'),
              const SizedBox(width: 8),
              _buildFilterChip('Coaches'),
              const Spacer(),
              if (_forceEmptyStateForDemo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accentOrange.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'Empty State Preview',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentOrange,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label && !_forceEmptyStateForDemo;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _forceEmptyStateForDemo = false;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : const Color(0xFF161916),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildConversationsList(List<ConversationItem> list) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: list.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 80, right: 16),
        child: Container(
          color: AppTheme.surfaceBorder.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
      itemBuilder: (context, index) {
        final conv = list[index];
        return _buildConversationRow(conv)
            .animate()
            .fadeIn(duration: 250.ms, delay: (40 * index).ms)
            .slideX(begin: -0.05, end: 0, duration: 250.ms, delay: (40 * index).ms);
      },
    );
  }

  Widget _buildConversationRow(ConversationItem conv) {
    final hasUnread = conv.unreadCount > 0;
    final timeStr = _formatRelativeTime(conv.lastMessageTime);

    return InkWell(
      onTap: () => _openChat(conv),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Contact Avatar with optional online status dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    width: 52,
                    height: 52,
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    child: Image.network(
                      conv.contactAvatar,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            conv.contactName.isNotEmpty ? conv.contactName[0] : 'C',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (conv.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.backgroundDark,
                          width: 2.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Name, specialty tag, and truncated message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          conv.contactName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      if (conv.contactSpecialty != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.25),
                              width: 0.7,
                            ),
                          ),
                          child: Text(
                            conv.contactSpecialty!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Message preview (truncated, bold text if unread)
                  Text(
                    conv.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
                      color: hasUnread ? AppTheme.textDark : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Timestamp and unread indicator column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                    color: hasUnread ? AppTheme.primary : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                if (hasUnread)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        conv.unreadCount > 9 ? '9+' : '${conv.unreadCount}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D0F0D),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glowing athletic icon container
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Friendly headline
            Text(
              'No conversations yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),

            // Descriptive subtext
            Text(
              'Connect with certified FitPulse coaches for tailored training programs, nutrition feedback, and daily accountability.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                height: 1.45,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Primary action button
            ElevatedButton.icon(
              onPressed: () {
                if (_forceEmptyStateForDemo) {
                  setState(() {
                    _forceEmptyStateForDemo = false;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FindCoachScreen()),
                  );
                }
              },
              icon: Icon(
                _forceEmptyStateForDemo ? Icons.refresh_rounded : Icons.search_rounded,
                size: 18,
              ),
              label: Text(
                _forceEmptyStateForDemo ? 'Reset Conversations' : 'Find a Coach',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0F0D),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF0D0F0D),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 350.ms);
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24 && time.day == now.day) {
      final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      final period = time.hour >= 12 ? 'PM' : 'AM';
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } else if (diff.inDays == 1 || (diff.inHours < 48 && time.day == now.day - 1)) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
