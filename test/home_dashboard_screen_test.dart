import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/screens/home_dashboard_screen.dart';
import 'package:fitness/services/api_service.dart';

void main() {
  testWidgets('HomeDashboardScreen renders member user name and member badge', (WidgetTester tester) async {
    // Simulate Member login
    ApiService.instance.currentUser = UserSession(
      id: 12,
      email: 'member@gmail.com',
      name: 'Alex Rivera',
      role: 'user',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Fix 1: Heading has real name Alex, role pill has MEMBER
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('MEMBER'), findsOneWidget);

    // Verify Member upgrade banner is visible
    expect(find.text('Upgrade to FitPulse Pro'), findsOneWidget);

    // Verify Fix 2 & Fix 4: Combined metric cards
    expect(find.text('Steps'), findsOneWidget);
    expect(find.text('8,432'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('2.1 L'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('7h 45m'), findsOneWidget);

    // Verify Fix 5: Personalized Today's Picks
    expect(find.text("Today's Plan"), findsOneWidget);
    expect(find.text('Upper Body Hypertrophy'), findsOneWidget);
    expect(find.text('Mobility & Core Flow'), findsOneWidget);
    expect(find.textContaining('Personalized for you'), findsOneWidget);
  });

  testWidgets('HomeDashboardScreen renders premium member styling and perks', (WidgetTester tester) async {
    // Simulate Premium login
    ApiService.instance.currentUser = UserSession(
      id: 11,
      email: 'premium@gmail.com',
      name: 'Sarah Connor',
      role: 'premium',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Fix 1: Heading has Sarah, role pill has PREMIUM
    expect(find.text('Sarah'), findsOneWidget);
    expect(find.text('PREMIUM'), findsOneWidget);

    // Verify Premium perks bar is visible
    expect(find.textContaining('FitPulse VIP Member'), findsOneWidget);
    // Member upgrade banner should NOT be visible
    expect(find.text('Upgrade to FitPulse Pro'), findsNothing);
  });
}
