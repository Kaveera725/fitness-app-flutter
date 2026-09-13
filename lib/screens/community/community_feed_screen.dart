import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

enum PostType {
  workout,
  meal,
  milestone,
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorUsername;
  final String authorAvatar;
  final String followerCount;
  final String timeAgo;
  final String categoryTag;
  final PostType type;
  final String caption;
  final String? imageUrl;
  final Map<String, String>? stats;
  int likeCount;
  int commentCount;
  bool isLiked;
  bool isFollowing;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatar,
    required this.followerCount,
    required this.timeAgo,
    required this.categoryTag,
    required this.type,
    required this.caption,
    this.imageUrl,
    this.stats,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    this.isFollowing = false,
  });
}

class CommunityFeedScreen extends StatefulWidget {
  final bool isEmbedded;
  const CommunityFeedScreen({super.key, this.isEmbedded = false});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Workouts", "Meals", "Milestones"];

  late List<CommunityPost> _posts;

  @override
  void initState() {
    super.initState();
    _posts = [
      // Post 1: Workout Completion Post
      CommunityPost(
        id: "p1",
        authorName: "Marcus Vance",
        authorUsername: "@marcus_fit",
        authorAvatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80",
        followerCount: "4.8k",
        timeAgo: "25m ago",
        categoryTag: "Strength & Hypertrophy",
        type: PostType.workout,
        caption: "Hit a heavy clean PR today! 4x8 on Romanian deadlifts followed by supersets. Focus on form over ego every single time. 🔥💪",
        imageUrl: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=1000&q=80",
        stats: {
          "Duration": "54 min",
          "Burned": "580 kcal",
          "PR Set": "120 kg",
        },
        likeCount: 142,
        commentCount: 23,
        isFollowing: true,
      ),

      // Post 2: Meal & Nutrition Post
      CommunityPost(
        id: "p2",
        authorName: "Maya Rodriguez",
        authorUsername: "@maya_fuel",
        authorAvatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80",
        followerCount: "2.3k",
        timeAgo: "2h ago",
        categoryTag: "Cooking community",
        type: PostType.meal,
        caption: "Post-workout fuel! Seared salmon bowl with cilantro-lime quinoa, avocado, and steamed edamame. Clean ingredients, macro-friendly & delicious. 🥑🥗",
        imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=1000&q=80",
        stats: {
          "Protein": "46g",
          "Calories": "520 kcal",
          "Carbs": "38g",
        },
        likeCount: 218,
        commentCount: 37,
        isFollowing: false,
      ),

      // Post 3: Achievement & Streak Post
      CommunityPost(
        id: "p3",
        authorName: "David Kim",
        authorUsername: "@dkim_lifts",
        authorAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80",
        followerCount: "1.1k",
        timeAgo: "5h ago",
        categoryTag: "Milestone Celebration",
        type: PostType.milestone,
        caption: "Officially unlocked the 30-Day Unstoppable Streak! Consistency was the hardest battle, but showing up every day changes everything. Big shoutout to this community! 🏆⚡",
        stats: {
          "Streak": "30 Days",
          "Workouts": "38 Total",
          "Rank": "#3 Global",
        },
        likeCount: 389,
        commentCount: 64,
        isFollowing: false,
      ),

      // Post 4: High Energy Workout Post
      CommunityPost(
        id: "p4",
        authorName: "Sophia Chen",
        authorUsername: "@sophia_run",
        authorAvatar: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80",
        followerCount: "6.2k",
        timeAgo: "8h ago",
        categoryTag: "Outdoor HIIT & Trail",
        type: PostType.workout,
        caption: "Sunrise hill sprint circuit completed before 7 AM. Crisp morning air and maximum heart rate intervals. Who else trained outdoors today?",
        imageUrl: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1000&q=80",
        stats: {
          "Distance": "6.8 km",
          "Pace": "4'32\" /km",
          "Elevation": "+195m",
        },
        likeCount: 472,
        commentCount: 51,
        isFollowing: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _posts.where((post) {
      if (_selectedCategory == "All") return true;
      if (_selectedCategory == "Workouts") return post.type == PostType.workout;
      if (_selectedCategory == "Meals") return post.type == PostType.meal;
      if (_selectedCategory == "Milestones") return post.type == PostType.milestone;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: AppTheme.backgroundDark,
              elevation: 0,
              title: Text(
                "Community",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    _showSearchSheet(context);
                  },
                  icon: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
                  tooltip: "Search Community",
                ),
              ],
            ),
      body: CustomScrollView(
        slivers: [
          // Category Filters
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      labelStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? const Color(0xFF0D0F0D) : AppTheme.textSecondary,
                      ),
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surfaceDark,
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Posts List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = filteredPosts[index];
                  return _buildPostCard(post, index);
                },
                childCount: filteredPosts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Post Card (Varies layout per content type)
  // ==========================================
  Widget _buildPostCard(CommunityPost post, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header: Avatar, Name, Follower Count, Category, Follow Button
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF222622),
                  backgroundImage: NetworkImage(post.authorAvatar),
                ),
                const SizedBox(width: 12),

                // Name & Followers
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.authorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "${post.followerCount} followers",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            " • ${post.timeAgo}",
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Category Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    post.categoryTag,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Follow Button (Outlined or Filled Neon Green)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      post.isFollowing = !post.isFollowing;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: post.isFollowing
                          ? AppTheme.primary
                          : const Color(0xFF141714),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primary,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      post.isFollowing ? "Following" : "Follow",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: post.isFollowing
                            ? const Color(0xFF0D0F0D)
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Caption Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              post.caption,
              style: GoogleFonts.manrope(
                fontSize: 13.5,
                height: 1.45,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Mixed Content Type Display:
          // Type A: Workout / Meal photo with rounded corners and stats overlay/strip
          if (post.imageUrl != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1C221C),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_rounded, color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ] else if (post.type == PostType.milestone) ...[
            // Type B: Milestone Celebration Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.18),
                      const Color(0xFF1C281C),
                      const Color(0xFF141714),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MILESTONE UNLOCKED",
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "30-Day Unstoppable Streak",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            "Earned Top 3% Athlete Status",
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
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Stats Badge Strip (if stats provided)
          if (post.stats != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141714),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder, width: 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: post.stats!.entries.map((entry) {
                    return Column(
                      children: [
                        Text(
                          entry.value,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          entry.key,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 8),

          // Post Action Buttons: Like, Comment, Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Row(
              children: [
                // Interactive Like
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (post.isLiked) {
                        post.isLiked = false;
                        post.likeCount--;
                      } else {
                        post.isLiked = true;
                        post.likeCount++;
                      }
                    });
                  },
                  icon: Icon(
                    post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: post.isLiked ? Colors.redAccent : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                Text(
                  "${post.likeCount}",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: post.isLiked ? Colors.redAccent : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 14),

                // Comment
                IconButton(
                  onPressed: () {
                    _showCommentSheet(context, post);
                  },
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppTheme.textSecondary,
                    size: 19,
                  ),
                ),
                Text(
                  "${post.commentCount}",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),

                // Share
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Post link copied to clipboard!",
                          style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: AppTheme.surfaceDark,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppTheme.surfaceBorder, width: 1),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 60).ms).slideY(begin: 0.05, end: 0);
  }

  void _showCommentSheet(BuildContext context, CommunityPost post) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
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
              const SizedBox(height: 14),
              Text(
                "Comments (${post.commentCount})",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: GoogleFonts.manrope(color: AppTheme.textDark),
                      decoration: InputDecoration(
                        hintText: "Add an encouraging comment...",
                        hintStyle: GoogleFonts.manrope(color: AppTheme.textSecondary, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF141714),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        setState(() {
                          post.commentCount++;
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                style: GoogleFonts.manrope(color: AppTheme.textDark),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                  hintText: "Search athletes, recipes, hashtags...",
                  hintStyle: GoogleFonts.manrope(color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: const Color(0xFF141714),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.surfaceBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ["#LegDay", "#MealPrep", "#5kRun", "#StrengthChallenge", "#CleanEating"].map((tag) {
                  return ActionChip(
                    label: Text(tag),
                    labelStyle: GoogleFonts.manrope(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.3)),
                    onPressed: () => Navigator.pop(ctx),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
