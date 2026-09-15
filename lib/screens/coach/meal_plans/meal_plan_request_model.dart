import '../meal_plans/../../meal_plan/meal_recipe_models.dart';

enum RequestStatus {
  pending,
  completed,
}

class MealPlanRequest {
  final String id;
  final String userName;
  final String userAvatar;
  final int age;
  final String height;
  final String weight;
  final String bodyFat;
  final String fitnessGoal;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFats;
  final List<String> dietaryPreferences;
  final String allergies;
  final int mealsPerDay;
  final String userNotes;
  final String timestamp;
  RequestStatus status;
  Map<MealSlot, RecipeItem>? assignedPlan;

  MealPlanRequest({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.age,
    required this.height,
    required this.weight,
    required this.bodyFat,
    required this.fitnessGoal,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    required this.dietaryPreferences,
    required this.allergies,
    required this.mealsPerDay,
    required this.userNotes,
    required this.timestamp,
    this.status = RequestStatus.pending,
    this.assignedPlan,
  });
}

/// Realistic sample requests with varied profiles and dietary requirements
List<MealPlanRequest> getSampleMealPlanRequests() {
  return [
    MealPlanRequest(
      id: "req_001",
      userName: "Sarah Jenkins",
      userAvatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200",
      age: 26,
      height: "168 cm",
      weight: "62 kg",
      bodyFat: "21%",
      fitnessGoal: "Lean Muscle & Tone",
      targetCalories: 2100,
      targetProtein: 145,
      targetCarbs: 220,
      targetFats: 55,
      dietaryPreferences: ["High-Protein", "Pescatarian", "Clean Carbs"],
      allergies: "Tree nuts",
      mealsPerDay: 4,
      userNotes: "Need quick morning breakfasts that I can prep in advance. Heavy training days are Mon/Wed/Fri so carbs around workouts help a lot!",
      timestamp: "Today, 09:30 AM",
      status: RequestStatus.pending,
    ),
    MealPlanRequest(
      id: "req_002",
      userName: "Alexander Wright",
      userAvatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
      age: 31,
      height: "185 cm",
      weight: "84 kg",
      bodyFat: "17%",
      fitnessGoal: "Hypertrophy & Strength",
      targetCalories: 2800,
      targetProtein: 195,
      targetCarbs: 320,
      targetFats: 75,
      dietaryPreferences: ["High-Protein", "No Restrictions", "Clean Bulking"],
      allergies: "None",
      mealsPerDay: 4,
      userNotes: "Entering a 12-week hypertrophy surplus phase. High quality protein intake is priority #1. Prefer larger dinners after 7 PM lifting sessions.",
      timestamp: "Yesterday, 3:45 PM",
      status: RequestStatus.pending,
    ),
    MealPlanRequest(
      id: "req_003",
      userName: "Elena Rostova",
      userAvatar: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200",
      age: 24,
      height: "162 cm",
      weight: "55 kg",
      bodyFat: "19%",
      fitnessGoal: "Fat Loss & Conditioning",
      targetCalories: 1750,
      targetProtein: 130,
      targetCarbs: 160,
      targetFats: 45,
      dietaryPreferences: ["Vegetarian", "Low-Calorie", "Dairy-Free"],
      allergies: "Lactose intolerant",
      mealsPerDay: 4,
      userNotes: "Preparing for a spring half-marathon while cutting down 2-3 kg. Wholesome plant sources and clean energizing snacks please.",
      timestamp: "2 days ago",
      status: RequestStatus.pending,
    ),
    MealPlanRequest(
      id: "req_004",
      userName: "David Kim",
      userAvatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200",
      age: 29,
      height: "178 cm",
      weight: "76 kg",
      bodyFat: "15%",
      fitnessGoal: "Body Recomposition",
      targetCalories: 2350,
      targetProtein: 165,
      targetCarbs: 240,
      targetFats: 65,
      dietaryPreferences: ["High-Protein", "Balanced"],
      allergies: "None",
      mealsPerDay: 4,
      userNotes: "Assigned 4-week macro cycle with high complex carbs on leg days.",
      timestamp: "Completed 3 days ago",
      status: RequestStatus.completed,
    ),
    MealPlanRequest(
      id: "req_005",
      userName: "Marcus Brody",
      userAvatar: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200",
      age: 34,
      height: "188 cm",
      weight: "92 kg",
      bodyFat: "18%",
      fitnessGoal: "Powerlifting Strength",
      targetCalories: 3100,
      targetProtein: 210,
      targetCarbs: 380,
      targetFats: 85,
      dietaryPreferences: ["High-Protein", "Keto"],
      allergies: "Shellfish",
      mealsPerDay: 4,
      userNotes: "Full power surplus plan completed and synced with workout cycle.",
      timestamp: "Completed last week",
      status: RequestStatus.completed,
    ),
  ];
}
