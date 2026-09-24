enum MessageType {
  text,
  workoutPlanAssigned,
  mealPlanAssigned,
}

class PlanPreviewData {
  final String title;
  final String subtitle;
  final String durationOrKcal;
  final String focusOrMacros;
  final String frequencyOrSplit;
  final String coachNotes;
  final List<String> items;

  const PlanPreviewData({
    required this.title,
    required this.subtitle,
    required this.durationOrKcal,
    required this.focusOrMacros,
    required this.frequencyOrSplit,
    required this.coachNotes,
    required this.items,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final bool isMe;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final PlanPreviewData? plan;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isMe,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.plan,
    this.isRead = true,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    bool? isMe,
    String? text,
    DateTime? timestamp,
    MessageType? type,
    PlanPreviewData? plan,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      isMe: isMe ?? this.isMe,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      plan: plan ?? this.plan,
      isRead: isRead ?? this.isRead,
    );
  }
}

class ConversationItem {
  final String id;
  final String contactName;
  final String contactAvatar;
  final String? contactSpecialty;
  final bool isCoach;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<ChatMessage> messages;

  const ConversationItem({
    required this.id,
    required this.contactName,
    required this.contactAvatar,
    this.contactSpecialty,
    this.isCoach = true,
    this.isOnline = true,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.messages,
  });

  ConversationItem copyWith({
    String? id,
    String? contactName,
    String? contactAvatar,
    String? contactSpecialty,
    bool? isCoach,
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<ChatMessage>? messages,
  }) {
    return ConversationItem(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      contactAvatar: contactAvatar ?? this.contactAvatar,
      contactSpecialty: contactSpecialty ?? this.contactSpecialty,
      isCoach: isCoach ?? this.isCoach,
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }
}

class DummyMessageData {
  static List<ConversationItem> getInitialConversations() {
    final now = DateTime.now();

    final List<ChatMessage> alexMessages = [
      ChatMessage(
        id: 'm1',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text:
            "Hey Anush! Welcome to FitPulse Pro Coaching. I've analyzed your strength profile and target benchmarks. Ready to tackle that 90kg bench press plateau?",
        timestamp: now.subtract(const Duration(hours: 3, minutes: 20)),
      ),
      ChatMessage(
        id: 'm2',
        senderId: 'user_anush',
        senderName: 'Anush',
        isMe: true,
        text:
            "Hey Alex! Absolutely. I've been stuck at 82.5kg for almost a month now, and my lockout feels fatigued by set 3.",
        timestamp: now.subtract(const Duration(hours: 3, minutes: 14)),
      ),
      ChatMessage(
        id: 'm3',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text:
            "That's classic accessory volume fatigue and pacing. Your pressing volume was clustered too heavily without enough eccentric pause control. I've calibrated a customized 4-week program for you.",
        timestamp: now.subtract(const Duration(hours: 3, minutes: 8)),
      ),
      ChatMessage(
        id: 'm4',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text: "I've assigned your new workout program. Review it below:",
        timestamp: now.subtract(const Duration(hours: 3, minutes: 7)),
        type: MessageType.workoutPlanAssigned,
        plan: const PlanPreviewData(
          title: "4-Week Upper Body Plateau Breaker",
          subtitle: "4 sessions/wk • Heavy compound focus • Deload W4",
          durationOrKcal: "55-65 min",
          focusOrMacros: "Chest & Tricep Drive",
          frequencyOrSplit: "Upper / Lower Split",
          coachNotes:
              "Focus on 2-second eccentric pauses at the chest on Monday bench sessions. Log your RPE for each working set.",
          items: [
            "Barbell Bench Press (4x5 @ RPE 8)",
            "Incline DB Press with Pause (3x8)",
            "Weighted Parallel Bar Dips (3x10)",
            "Cable Face Pulls & Rotators (4x15)",
            "Overhead Cable Tricep Extension (3x12)",
          ],
        ),
      ),
      ChatMessage(
        id: 'm5',
        senderId: 'user_anush',
        senderName: 'Anush',
        isMe: true,
        text:
            "Just checked out the routine! The pause reps on chest day look challenging but exactly what I need. How should I pace warmup sets?",
        timestamp: now.subtract(const Duration(hours: 2, minutes: 45)),
      ),
      ChatMessage(
        id: 'm6',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text:
            "Do 3 clean warmups: bar x 10, 50kg x 5, 70kg x 3, then straight into your working set. Also, what does your current daily protein and calorie intake look like?",
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      ChatMessage(
        id: 'm7',
        senderId: 'user_anush',
        senderName: 'Anush',
        isMe: true,
        text:
            "Averaging around 140g protein and ~2,100 calories. I tend to under-eat on rest days because my appetite drops.",
        timestamp: now.subtract(const Duration(hours: 2, minutes: 12)),
      ),
      ChatMessage(
        id: 'm8',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text:
            "Under-eating on rest days is the hidden culprit behind stalling! Muscle protein synthesis peaks while recovering. I've designed an athletic high-protein meal template for you.",
        timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
      ),
      ChatMessage(
        id: 'm9',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text: "Here is your nutrition blueprint tailored to support the strength block:",
        timestamp: now.subtract(const Duration(hours: 1, minutes: 54)),
        type: MessageType.mealPlanAssigned,
        plan: const PlanPreviewData(
          title: "High-Protein Athletic Hypertrophy",
          subtitle: "2,600 kcal • 185g Protein • 290g Carbs • 75g Healthy Fats",
          durationOrKcal: "2,600 kcal",
          focusOrMacros: "185g P / 290g C / 75g F",
          frequencyOrSplit: "4 Meals + Pre/Post Fuel",
          coachNotes:
              "Have a Greek yogurt bowl or isolate shake 45 mins before your evening lift. Keep hydration around 3.5L on training days.",
          items: [
            "Breakfast: Cinnamon Rolled Oats with Whey & Blueberries",
            "Lunch: Grilled Herb Chicken Breast, Jasmine Rice & Asparagus",
            "Pre-Workout: Rice Cakes with Almond Butter & Banana Slices",
            "Dinner: Atlantic Salmon Fillet, Roasted Sweet Potatoes & Spinach",
          ],
        ),
      ),
      ChatMessage(
        id: 'm10',
        senderId: 'user_anush',
        senderName: 'Anush',
        isMe: true,
        text:
            "Looks delicious and completely doable to meal prep on Sundays. Thanks Alex! Starting Day 1 of the new cycle tomorrow at 7 AM.",
        timestamp: now.subtract(const Duration(minutes: 24)),
      ),
      ChatMessage(
        id: 'm11',
        senderId: 'coach_alex',
        senderName: 'Alex Strong',
        isMe: false,
        text:
            "That's the champion mindset! Record your top working set on bench and drop the video or form notes here. You've got this! 💪🔥",
        timestamp: now.subtract(const Duration(minutes: 6)),
      ),
    ];

    final List<ChatMessage> bellaMessages = [
      ChatMessage(
        id: 'b1',
        senderId: 'coach_bella',
        senderName: 'Bella Flow',
        isMe: false,
        text:
            "Good morning! How did your lower back and hip flexors feel during this morning's thoracic flow routine?",
        timestamp: now.subtract(const Duration(hours: 4, minutes: 10)),
      ),
    ];

    final List<ChatMessage> carlosMessages = [
      ChatMessage(
        id: 'c1',
        senderId: 'coach_carlos',
        senderName: 'Carlos Cardio',
        isMe: false,
        text:
            "Great heart-rate zone discipline on today's 8k! You stayed in Zone 2 for 84% of the session. Exactly what we wanted.",
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
      ),
    ];

    final List<ChatMessage> elenaMessages = [
      ChatMessage(
        id: 'e1',
        senderId: 'coach_elena',
        senderName: 'Elena Vance',
        isMe: false,
        text:
            "Remember to pack your electrolyte hydration mix for tomorrow's outdoor tempo run. Humidity will be high.",
        timestamp: now.subtract(const Duration(days: 2, hours: 5)),
      ),
    ];

    return [
      ConversationItem(
        id: 'conv_alex',
        contactName: 'Alex Strong',
        contactAvatar:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
        contactSpecialty: 'Strength & Conditioning',
        isCoach: true,
        isOnline: true,
        lastMessage:
            "That's the champion mindset! Record your top working set on bench and drop the video or form notes here. You've got this! 💪🔥",
        lastMessageTime: now.subtract(const Duration(minutes: 6)),
        unreadCount: 1,
        messages: alexMessages,
      ),
      ConversationItem(
        id: 'conv_bella',
        contactName: 'Bella Flow',
        contactAvatar:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&q=80',
        contactSpecialty: 'Yoga & Mobility',
        isCoach: true,
        isOnline: true,
        lastMessage:
            "Good morning! How did your lower back and hip flexors feel during this morning's thoracic flow routine?",
        lastMessageTime: now.subtract(const Duration(hours: 4, minutes: 10)),
        unreadCount: 1,
        messages: bellaMessages,
      ),
      ConversationItem(
        id: 'conv_carlos',
        contactName: 'Carlos Cardio',
        contactAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
        contactSpecialty: 'Cardio & Endurance',
        isCoach: true,
        isOnline: false,
        lastMessage:
            "Great heart-rate zone discipline on today's 8k! You stayed in Zone 2 for 84% of the session. Exactly what we wanted.",
        lastMessageTime: now.subtract(const Duration(days: 1, hours: 2)),
        unreadCount: 0,
        messages: carlosMessages,
      ),
      ConversationItem(
        id: 'conv_elena',
        contactName: 'Elena Vance',
        contactAvatar:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80',
        contactSpecialty: 'Performance Nutrition',
        isCoach: true,
        isOnline: false,
        lastMessage:
            "Remember to pack your electrolyte hydration mix for tomorrow's outdoor tempo run. Humidity will be high.",
        lastMessageTime: now.subtract(const Duration(days: 2, hours: 5)),
        unreadCount: 0,
        messages: elenaMessages,
      ),
    ];
  }
}
