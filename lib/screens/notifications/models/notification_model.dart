import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// Recency bucket for notifications grouping
enum RecencyGroup {
  today,
  thisWeek,
  earlier,
}

/// Supported notification types in FitPulse
enum NotificationCategory {
  planAssigned, // Coach assigned workout or meal plan
  coachMessage, // New direct message from coach
  streakAtRisk, // Streak at risk alert
  achievement, // Badge or level milestone unlocked
  subscription, // Pro renewal or billing notification
  coachReview, // Trainee review for coach (coach-side)
  mealPlanAssigned, // Dedicated meal plan assignment
  community, // Community leaderboard/challenge update
}

/// Model representing a single notification item
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final RecencyGroup recency;
  final String timeAgo;
  final String? senderName;
  final String? senderAvatar;
  final String? actionLabel;
  final String? targetRoute;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.recency,
    required this.timeAgo,
    this.senderName,
    this.senderAvatar,
    this.actionLabel,
    this.targetRoute,
    this.isRead = false,
  });

  /// Category configuration: Icon, Accent Color, and Chip Label
  IconData get icon {
    switch (category) {
      case NotificationCategory.planAssigned:
        return Icons.fitness_center_rounded;
      case NotificationCategory.mealPlanAssigned:
        return Icons.restaurant_menu_rounded;
      case NotificationCategory.coachMessage:
        return Icons.chat_bubble_rounded;
      case NotificationCategory.streakAtRisk:
        return Icons.local_fire_department_rounded;
      case NotificationCategory.achievement:
        return Icons.emoji_events_rounded;
      case NotificationCategory.subscription:
        return Icons.workspace_premium_rounded;
      case NotificationCategory.coachReview:
        return Icons.star_rounded;
      case NotificationCategory.community:
        return Icons.military_tech_rounded;
    }
  }

  Color get accentColor {
    switch (category) {
      case NotificationCategory.planAssigned:
        return AppTheme.primary; // Neon lime
      case NotificationCategory.mealPlanAssigned:
        return const Color(0xFF00E676); // Spring mint green
      case NotificationCategory.coachMessage:
        return const Color(0xFF00E5FF); // Electric cyan
      case NotificationCategory.streakAtRisk:
        return AppTheme.accentOrange; // Radiant flame orange
      case NotificationCategory.achievement:
        return AppTheme.accentPurple; // Electric purple / trophy
      case NotificationCategory.subscription:
        return const Color(0xFFFFD600); // Amber gold
      case NotificationCategory.coachReview:
        return const Color(0xFFFFAB00); // Golden star
      case NotificationCategory.community:
        return const Color(0xFF7C4DFF); // Deep purple
    }
  }

  String get categoryLabel {
    switch (category) {
      case NotificationCategory.planAssigned:
        return "WORKOUT PLAN";
      case NotificationCategory.mealPlanAssigned:
        return "MEAL PLAN";
      case NotificationCategory.coachMessage:
        return "COACH MESSAGE";
      case NotificationCategory.streakAtRisk:
        return "STREAK ALERT";
      case NotificationCategory.achievement:
        return "ACHIEVEMENT";
      case NotificationCategory.subscription:
        return "SUBSCRIPTION";
      case NotificationCategory.coachReview:
        return "NEW REVIEW";
      case NotificationCategory.community:
        return "COMMUNITY";
    }
  }
}

/// Realistic seed data covering all required notification types
List<NotificationItem> getInitialMockNotifications() {
  return [
    // ----------------- TODAY -----------------
    NotificationItem(
      id: "notif_1",
      title: "New Workout Plan Assigned",
      body:
          "Coach Marcus assigned you '4-Week Hypertrophy & Power V2'. Review your progressive overload targets and workout split.",
      category: NotificationCategory.planAssigned,
      recency: RecencyGroup.today,
      timeAgo: "18m ago",
      senderName: "Coach Marcus Vance",
      senderAvatar:
          "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=120&q=80",
      actionLabel: "View Routine",
      targetRoute: "/workout_plan",
      isRead: false,
    ),
    NotificationItem(
      id: "notif_2",
      title: "New Message from Coach Elena",
      body:
          "“Great form on those pause squats today! Let's bump your working sets by 2.5 kg next session.”",
      category: NotificationCategory.coachMessage,
      recency: RecencyGroup.today,
      timeAgo: "2h ago",
      senderName: "Coach Elena Rostova",
      senderAvatar:
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=120&q=80",
      actionLabel: "Reply to Elena",
      targetRoute: "/messages",
      isRead: false,
    ),
    NotificationItem(
      id: "notif_3",
      title: "Streak at Risk: 5 Days Burning! 🔥",
      body:
          "Don't break your 5-day streak! Log just 15 mins of mobility, cardio, or core before midnight to keep your XP multiplier alive.",
      category: NotificationCategory.streakAtRisk,
      recency: RecencyGroup.today,
      timeAgo: "4h ago",
      actionLabel: "Quick Workout",
      targetRoute: "/quick_workout",
      isRead: false,
    ),

    // ----------------- THIS WEEK -----------------
    NotificationItem(
      id: "notif_4",
      title: "Achievement Unlocked: Iron Pumper III",
      body:
          "You crushed 5,000 kg total barbell volume this week. +200 XP awarded to your athletic rank!",
      category: NotificationCategory.achievement,
      recency: RecencyGroup.thisWeek,
      timeAgo: "Yesterday",
      actionLabel: "View Badge",
      targetRoute: "/milestone",
      isRead: false,
    ),
    NotificationItem(
      id: "notif_5",
      title: "High-Protein Macro Plan Tailored",
      body:
          "Coach Bella published your 2,400 kcal lean-cutting nutritional protocol with high-protein recipe breakdowns.",
      category: NotificationCategory.mealPlanAssigned,
      recency: RecencyGroup.thisWeek,
      timeAgo: "2 days ago",
      senderName: "Coach Bella Flow",
      senderAvatar:
          "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=120&q=80",
      actionLabel: "View Meal Plan",
      targetRoute: "/meal_plan",
      isRead: true,
    ),
    NotificationItem(
      id: "notif_6",
      title: "FitPulse Pro Renews in 3 Days",
      body:
          "Your monthly membership renews on Sep 28 for \$19.99/mo. Switch to the Annual tier to save 20% (\$159/yr).",
      category: NotificationCategory.subscription,
      recency: RecencyGroup.thisWeek,
      timeAgo: "3 days ago",
      actionLabel: "Manage Plan",
      targetRoute: "/subscription",
      isRead: true,
    ),

    // ----------------- EARLIER -----------------
    NotificationItem(
      id: "notif_7",
      title: "New 5-Star Review from Marcus T.",
      body:
          "“Elena completely revitalized my bench pressing technique and fixed my shoulder pinch. Outstanding coach!”",
      category: NotificationCategory.coachReview,
      recency: RecencyGroup.earlier,
      timeAgo: "Sep 18",
      senderName: "Marcus Thorne",
      senderAvatar:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120&q=80",
      actionLabel: "Read Review",
      targetRoute: "/reviews",
      isRead: true,
    ),
    NotificationItem(
      id: "notif_8",
      title: "Top 5% on Global Cardio Leaderboard",
      body:
          "You completed 34.8 km this week and climbed 16 positions in the FitPulse Autumn Speed challenge.",
      category: NotificationCategory.community,
      recency: RecencyGroup.earlier,
      timeAgo: "Sep 14",
      actionLabel: "Leaderboard",
      targetRoute: "/community",
      isRead: true,
    ),
  ];
}
