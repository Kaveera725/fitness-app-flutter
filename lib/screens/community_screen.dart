import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> posts = [
      {
        "name": "Sarah Jenkins",
        "avatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80",
        "time": "2 hrs ago",
        "content": "Just finished my first 5k run! Feeling amazing! 🏃‍♀️🔥",
        "likes": "124",
        "comments": "12",
      },
      {
        "name": "Mike Chen",
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80",
        "time": "4 hrs ago",
        "content": "Hit a new personal record on deadlifts today. Consistency pays off. 💪",
        "likes": "89",
        "comments": "5",
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Community", style: theme.textTheme.displaySmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final post = posts[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post["avatar"]!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post["name"]!, style: theme.textTheme.titleLarge),
                          Text(post["time"]!, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                Text(post["content"]!, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInteractionButton(Icons.favorite, post["likes"]!, theme),
                    _buildInteractionButton(Icons.chat_bubble, post["comments"]!, theme),
                    _buildInteractionButton(Icons.share, "Share", theme),
                  ],
                ),
              ],
            ),
          ).animate().fade(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String label, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
      ],
    );
  }
}
