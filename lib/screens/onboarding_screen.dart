import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart'; // Assume this will be created soon

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to FitPulse",
      "subtitle": "Your personal fitness companion to help you achieve your goals.",
      "image": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80",
    },
    {
      "title": "Track Your Progress",
      "subtitle": "Monitor your workouts, calories, and weight seamlessly.",
      "image": "https://images.unsplash.com/photo-1526506114642-458bb0e0a5bb?w=800&q=80",
    },
    {
      "title": "Join the Community",
      "subtitle": "Connect with friends and stay motivated together.",
      "image": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildPage(
                _onboardingData[index]["image"]!,
                _onboardingData[index]["title"]!,
                _onboardingData[index]["subtitle"]!,
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildDot(index: index),
                  ),
                ),
                const SizedBox(height: 32),
                if (_currentIndex == _onboardingData.length - 1)
                  CustomButton(
                    text: "Get Started",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                  ).animate().fade().slideY(begin: 0.2, end: 0)
                else
                  CustomButton(
                    text: "Next",
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String image, String title, String subtitle) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          image,
          fit: BoxFit.cover,
        ).animate().scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0), duration: 2.seconds),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
                Colors.black,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade().slideY(begin: 0.2, end: 0, delay: 200.ms),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ).animate().fade().slideY(begin: 0.2, end: 0, delay: 300.ms),
              const SizedBox(height: 160), // Space for buttons and indicators
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? AppTheme.accentGreen : Colors.white54,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
