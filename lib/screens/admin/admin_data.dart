import 'package:flutter/material.dart';

enum CoachStatus {
  active,
  pending,
}

enum UserPlan {
  premium,
  free,
}

class CoachItem {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final double rating;
  final int reviewCount;
  final CoachStatus status;
  final int clientsCount;
  final String avatarUrl;
  final String joinedDate;
  final String bio;

  CoachItem({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.clientsCount,
    required this.avatarUrl,
    required this.joinedDate,
    this.bio = '',
  });

  CoachItem copyWith({
    String? id,
    String? name,
    String? email,
    String? specialty,
    double? rating,
    int? reviewCount,
    CoachStatus? status,
    int? clientsCount,
    String? avatarUrl,
    String? joinedDate,
    String? bio,
  }) {
    return CoachItem(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      status: status ?? this.status,
      clientsCount: clientsCount ?? this.clientsCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedDate: joinedDate ?? this.joinedDate,
      bio: bio ?? this.bio,
    );
  }
}

class UserItem {
  final String id;
  final String name;
  final String email;
  final UserPlan plan;
  final String? assignedCoachName;
  final String? assignedCoachAvatar;
  final String avatarUrl;
  final String joinDate;
  final int streakDays;
  final int workoutsCompleted;
  final int totalCaloriesBurned;
  final String phone;
  final String location;

  UserItem({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
    this.assignedCoachName,
    this.assignedCoachAvatar,
    required this.avatarUrl,
    required this.joinDate,
    required this.streakDays,
    required this.workoutsCompleted,
    required this.totalCaloriesBurned,
    this.phone = '+1 (555) 234-5678',
    this.location = 'San Francisco, CA',
  });
}

class AdminDataService extends ChangeNotifier {
  static final AdminDataService instance = AdminDataService._internal();

  AdminDataService._internal() {
    _initData();
  }

  final List<CoachItem> _coaches = [];
  final List<UserItem> _users = [];

  List<CoachItem> get coaches => List.unmodifiable(_coaches);
  List<UserItem> get users => List.unmodifiable(_users);

  int get totalUsers => _users.length;
  int get totalCoaches => _coaches.length;
  int get activeCoachesCount =>
      _coaches.where((c) => c.status == CoachStatus.active).length;
  int get pendingCoachesCount =>
      _coaches.where((c) => c.status == CoachStatus.pending).length;
  int get activePremiumSubscriptions =>
      _users.where((u) => u.plan == UserPlan.premium).length;
  int get freeUsersCount =>
      _users.where((u) => u.plan == UserPlan.free).length;

  void _initData() {
    _coaches.addAll([
      CoachItem(
        id: 'c1',
        name: 'Marcus Vance',
        email: 'marcus.vance@fitpulse.app',
        specialty: 'HIIT & Strength Conditioning',
        rating: 4.9,
        reviewCount: 142,
        status: CoachStatus.active,
        clientsCount: 28,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Jan 2024',
        bio: 'Certified CSCS coach with 8+ years specializing in athletic strength, barbell training, and high-intensity conditioning.',
      ),
      CoachItem(
        id: 'c2',
        name: 'Elena Rostova',
        email: 'elena.rostova@fitpulse.app',
        specialty: 'Yoga, Mobility & Mindfulness',
        rating: 5.0,
        reviewCount: 98,
        status: CoachStatus.active,
        clientsCount: 34,
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Feb 2024',
        bio: '500-hr RYT yoga instructor focusing on Vinyasa flow, deep mobility, posture restoration, and stress management.',
      ),
      CoachItem(
        id: 'c3',
        name: 'David Chen',
        email: 'david.chen@fitpulse.app',
        specialty: 'CrossFit & Olympic Lifting',
        rating: 4.8,
        reviewCount: 76,
        status: CoachStatus.active,
        clientsCount: 19,
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Mar 2024',
        bio: 'Level 2 CrossFit trainer dedicated to explosive power, clean form, and progressive overload.',
      ),
      CoachItem(
        id: 'c4',
        name: 'Maya Lin',
        email: 'maya.lin@fitpulse.app',
        specialty: 'Pilates & Core Rehab',
        rating: 4.9,
        reviewCount: 110,
        status: CoachStatus.active,
        clientsCount: 25,
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Apr 2024',
        bio: 'Comprehensive Pilates instructor with clinical rehabilitation background for injury recovery and posture alignment.',
      ),
      CoachItem(
        id: 'c5',
        name: 'James Walker',
        email: 'james.walker@fitpulse.app',
        specialty: 'Endurance Running & Cardio',
        rating: 4.7,
        reviewCount: 45,
        status: CoachStatus.pending,
        clientsCount: 0,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Pending Verification',
        bio: 'Ultra-marathoner and Boston qualifier coach building marathon preparation protocols and Vo2 max plans.',
      ),
      CoachItem(
        id: 'c6',
        name: 'Sophia Patel',
        email: 'sophia.patel@fitpulse.app',
        specialty: 'Nutrition & Metabolic Health',
        rating: 4.9,
        reviewCount: 63,
        status: CoachStatus.pending,
        clientsCount: 0,
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
        joinedDate: 'Pending Verification',
        bio: 'Registered Dietitian and sports nutrition expert tailoring flexible macronutrient tracking for sustainable fat loss.',
      ),
    ]);

    _users.addAll([
      UserItem(
        id: 'u1',
        name: 'Sarah Jenkins',
        email: 'sarah.j@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'Elena Rostova',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        joinDate: '12 Jan 2024',
        streakDays: 24,
        workoutsCompleted: 58,
        totalCaloriesBurned: 24800,
      ),
      UserItem(
        id: 'u2',
        name: 'Alexander Wright',
        email: 'alex.wright@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'Marcus Vance',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        joinDate: '28 Jan 2024',
        streakDays: 18,
        workoutsCompleted: 42,
        totalCaloriesBurned: 18900,
      ),
      UserItem(
        id: 'u3',
        name: 'Emily Davis',
        email: 'emily.d@example.com',
        plan: UserPlan.free,
        assignedCoachName: null,
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
        joinDate: '04 Feb 2024',
        streakDays: 5,
        workoutsCompleted: 14,
        totalCaloriesBurned: 5200,
      ),
      UserItem(
        id: 'u4',
        name: 'Michael Torres',
        email: 'michael.t@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'David Chen',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        joinDate: '15 Feb 2024',
        streakDays: 31,
        workoutsCompleted: 64,
        totalCaloriesBurned: 31400,
      ),
      UserItem(
        id: 'u5',
        name: 'Jessica Taylor',
        email: 'jess.taylor@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'Maya Lin',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
        joinDate: '22 Feb 2024',
        streakDays: 12,
        workoutsCompleted: 29,
        totalCaloriesBurned: 11800,
      ),
      UserItem(
        id: 'u6',
        name: 'Daniel Kim',
        email: 'daniel.kim@example.com',
        plan: UserPlan.free,
        assignedCoachName: null,
        avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
        joinDate: '01 Mar 2024',
        streakDays: 3,
        workoutsCompleted: 8,
        totalCaloriesBurned: 3100,
      ),
      UserItem(
        id: 'u7',
        name: 'Olivia Martinez',
        email: 'olivia.m@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'Marcus Vance',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&auto=format&fit=crop&q=80',
        joinDate: '10 Mar 2024',
        streakDays: 45,
        workoutsCompleted: 82,
        totalCaloriesBurned: 39500,
      ),
      UserItem(
        id: 'u8',
        name: 'Liam Johnson',
        email: 'liam.j@example.com',
        plan: UserPlan.free,
        assignedCoachName: null,
        avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200&auto=format&fit=crop&q=80',
        joinDate: '18 Mar 2024',
        streakDays: 7,
        workoutsCompleted: 19,
        totalCaloriesBurned: 7400,
      ),
      UserItem(
        id: 'u9',
        name: 'Chloe Bennett',
        email: 'chloe.b@example.com',
        plan: UserPlan.premium,
        assignedCoachName: 'Elena Rostova',
        assignedCoachAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
        avatarUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&auto=format&fit=crop&q=80',
        joinDate: '25 Mar 2024',
        streakDays: 15,
        workoutsCompleted: 35,
        totalCaloriesBurned: 14200,
      ),
      UserItem(
        id: 'u10',
        name: 'Ethan Foster',
        email: 'ethan.foster@example.com',
        plan: UserPlan.free,
        assignedCoachName: null,
        avatarUrl: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200&auto=format&fit=crop&q=80',
        joinDate: '02 Apr 2024',
        streakDays: 2,
        workoutsCompleted: 6,
        totalCaloriesBurned: 2200,
      ),
    ]);
  }

  void inviteCoach({
    required String name,
    required String email,
    required String specialty,
    String bio = '',
  }) {
    final newCoach = CoachItem(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      specialty: specialty.isEmpty ? 'General Fitness Coaching' : specialty,
      rating: 5.0,
      reviewCount: 0,
      status: CoachStatus.pending,
      clientsCount: 0,
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&auto=format&fit=crop&q=80',
      joinedDate: 'Invited Just Now',
      bio: bio.isEmpty ? 'Newly invited coach on FitPulse.' : bio,
    );

    _coaches.insert(0, newCoach);
    notifyListeners();
  }

  void removeCoach(String id) {
    _coaches.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
