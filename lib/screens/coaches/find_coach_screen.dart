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

  // Dummy data
  final List<Coach> _allCoaches = [
    Coach(
      name: 'Alex Strong',
      specialty: 'Strength',
      imageUrl: 'https://i.pravatar.cc/150?img=1',
      rating: 4.8,
      reviewCount: 54,
      experienceYears: 5,
      bio: 'Passionate about building strength and confidence.',
      reviews: [],
    ),
    Coach(
      name: 'Bella Flow',
      specialty: 'Yoga',
      imageUrl: 'https://i.pravatar.cc/150?img=2',
      rating: 4.9,
      reviewCount: 38,
      experienceYears: 7,
      bio: 'Guiding you to inner peace through mindful movement.',
      reviews: [],
    ),
    Coach(
      name: 'Carlos Cardio',
      specialty: 'Cardio',
      imageUrl: 'https://i.pravatar.cc/150?img=3',
      rating: 4.7,
      reviewCount: 42,
      experienceYears: 4,
      bio: 'Heart‑pumping sessions to boost endurance.',
      reviews: [],
    ),
    Coach(
      name: 'Dana HIIT',
      specialty: 'HIIT',
      imageUrl: 'https://i.pravatar.cc/150?img=4',
      rating: 4.8,
      reviewCount: 61,
      experienceYears: 3,
      bio: 'High‑intensity intervals for maximum results.',
      reviews: [],
    ),
    Coach(
      name: 'Eli Nutri',
      specialty: 'Nutrition',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      rating: 5.0,
      reviewCount: 27,
      experienceYears: 6,
      bio: 'Food‑focused coaching for optimal performance.',
      reviews: [],
    ),
    Coach(
      name: 'Fiona Flex',
      specialty: 'Strength',
      imageUrl: 'https://i.pravatar.cc/150?img=6',
      rating: 4.6,
      reviewCount: 19,
      experienceYears: 2,
      bio: 'Empowering you with functional strength.',
      reviews: [],
    ),
  ];

  List<Coach> get _filteredCoaches {
    var list = _allCoaches;
    if (_selectedCategory != 'All') {
      list = list.where((c) => c.specialty == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) => c.name.toLowerCase().contains(q) || c.specialty.toLowerCase().contains(q)).toList();
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
        title: const Text('Find a Coach'),
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              label: 'Search Coaches',
              hint: 'Enter name or specialty',
              controller: _searchController,
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          SizedBox(
            height: 48,
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
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: const Color(0xFF7C4DFF),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: _filteredCoaches.length,
              itemBuilder: (context, index) {
                final coach = _filteredCoaches[index];
                return CoachCard(
                  coach: coach,
                  onViewProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CoachDetailScreen(coach: coach)),
                    );
                  },
                ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, duration: 300.ms);
              },
            ),
          ),
        ],
      ),
    );
  }
}
