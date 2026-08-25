import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fitness/models/coach.dart';
import 'package:fitness/widgets/custom_text_field.dart';
import 'package:fitness/widgets/coach_card.dart';
import 'coach_detail_screen.dart';

class FindCoachScreen extends StatefulWidget {
  const FindCoachScreen({super.key});

  @override
  State<FindCoachScreen> createState() => _FindCoachScreenState();
}

class _FindCoachScreenState extends State<FindCoachScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Strength', 'Yoga', 'Cardio', 'HIIT', 'Nutrition'];

  // Dummy data with 7 sample coaches and rich reviews
  final List<Coach> _allCoaches = [
    Coach(
      name: 'Alex Strong',
      specialty: 'Strength',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
      rating: 4.9,
      reviewCount: 58,
      experienceYears: 6,
      bio: 'Certified strength and conditioning specialist with over 6 years of experience helping athletes and everyday gym-goers build muscle, correct posture, and break personal records.',
      reviews: [
        Review(reviewer: 'Sarah M.', rating: 5.0, comment: 'Alex helped me double my deadlift in 3 months! Super attentive form coaching.'),
        Review(reviewer: 'David K.', rating: 4.8, comment: 'Great progressive overload plans and clear weekly check-ins.'),
        Review(reviewer: 'Jessica T.', rating: 5.0, comment: 'Very motivating coach, highly recommended for beginners.'),
      ],
    ),
    Coach(
      name: 'Bella Flow',
      specialty: 'Yoga',
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&q=80',
      rating: 4.9,
      reviewCount: 42,
      experienceYears: 7,
      bio: 'Vinyasa and Hatha yoga instructor focusing on mindful movement, breath control, flexibility, and core stability. Passionate about restorative healing.',
      reviews: [
        Review(reviewer: 'Emily R.', rating: 5.0, comment: 'Her morning flow sessions transformed my mobility and stress levels.'),
        Review(reviewer: 'Marcus B.', rating: 4.8, comment: 'Helped heal my lower back tightness after years of desk work.'),
      ],
    ),
    Coach(
      name: 'Carlos Cardio',
      specialty: 'Cardio',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
      rating: 4.8,
      reviewCount: 47,
      experienceYears: 5,
      bio: 'Marathon finisher and endurance specialist. I design heart rate zone training programs that boost stamina without burning you out.',
      reviews: [
        Review(reviewer: 'Liam P.', rating: 5.0, comment: 'Paced me to my first sub-4 hour marathon. Incredible strategist!'),
        Review(reviewer: 'Rachel H.', rating: 4.6, comment: 'Fun interval workouts that fly by.'),
      ],
    ),
    Coach(
      name: 'Dana HIIT',
      specialty: 'HIIT',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80',
      rating: 4.8,
      reviewCount: 65,
      experienceYears: 4,
      bio: 'High-intensity interval training fanatic! Maximize calorie burn and explosive power with quick 25-45 minute functional circuits.',
      reviews: [
        Review(reviewer: 'Kevin O.', rating: 5.0, comment: 'Intense workouts, maximum energy. Lost 15 lbs with Dana!'),
        Review(reviewer: 'Ashley N.', rating: 4.7, comment: 'Tough but always gives scaling options for every exercise.'),
      ],
    ),
    Coach(
      name: 'Eli Nutri',
      specialty: 'Nutrition',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
      rating: 5.0,
      reviewCount: 34,
      experienceYears: 8,
      bio: 'Registered sports dietitian specializing in macro coaching, gut health, and sustainable lifestyle nutrition without extreme fad diets.',
      reviews: [
        Review(reviewer: 'Samira G.', rating: 5.0, comment: 'Finally a nutrition plan that lets me eat normal food with my family.'),
        Review(reviewer: 'Brian L.', rating: 5.0, comment: 'Clean energy levels all day long. Eli is a wealth of knowledge.'),
      ],
    ),
    Coach(
      name: 'Fiona Flex',
      specialty: 'Strength',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&q=80',
      rating: 4.7,
      reviewCount: 29,
      experienceYears: 3,
      bio: 'Powerlifting and functional hypertrophy coach. Focused on bulletproofing your joints and unlocking true athletic strength.',
      reviews: [
        Review(reviewer: 'Oliver C.', rating: 4.8, comment: 'Taught me proper squat depth and bracing mechanics.'),
      ],
    ),
    Coach(
      name: 'Grace Cardio',
      specialty: 'Cardio',
      imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300&q=80',
      rating: 4.9,
      reviewCount: 51,
      experienceYears: 6,
      bio: 'Spin instructor and aerobic capacity coach. Bringing high energy and upbeat playlists to every sweat session.',
      reviews: [
        Review(reviewer: 'Tyler W.', rating: 5.0, comment: 'Her energy is contagious! Love every single workout.'),
      ],
    ),
  ];

  List<Coach> get _filteredCoaches {
    var list = _allCoaches;
    if (_selectedCategory != 'All') {
      list = list.where((c) => c.specialty == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
          c.name.toLowerCase().contains(q) ||
          c.specialty.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find a Coach',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E35B1),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              label: 'Search Coaches',
              hint: 'Search by name or specialty...',
              controller: _searchController,
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Category Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: const Color(0xFF5E35B1),
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Coach cards list
          Expanded(
            child: _filteredCoaches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No coaches found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _filteredCoaches.length,
                    itemBuilder: (context, index) {
                      final coach = _filteredCoaches[index];
                      return CoachCard(
                        coach: coach,
                        onViewProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoachDetailScreen(coach: coach),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.1, duration: 300.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
