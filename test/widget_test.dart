import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/widgets/custom_button.dart';
import 'package:fitness/services/api_service.dart';

void main() {
  testWidgets('CustomButton renders text and triggers callback', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Sign In',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Sign In'), findsOneWidget);
    await tester.tap(find.byType(CustomButton));
    expect(tapped, isTrue);
  });

  test('ApiService defaultBaseUrl and session test', () {
    expect(ApiService.instance.baseUrl, isNotEmpty);
    ApiService.instance.logout();
    expect(ApiService.instance.currentUser, isNull);

    final user = UserSession.fromJson({
      'id': 1,
      'email': 'admin@fitpulse.com',
      'name': 'Admin User',
      'role': 'admin',
    });

    expect(user.isAdmin, isTrue);
    expect(user.isPremium, isFalse);
    expect(user.isCoach, isFalse);
    expect(user.roleTitle, equals('Admin'));

    final coach = UserSession.fromJson({
      'id': 2,
      'email': 'coach@fitpulse.com',
      'name': 'Coach Sam',
      'role': 'coach',
    });

    expect(coach.isCoach, isTrue);
    expect(coach.roleTitle, equals('Coach'));

    final premium = UserSession.fromJson({
      'id': 3,
      'email': 'vip@fitpulse.com',
      'role': 'premium',
    });

    expect(premium.isPremium, isTrue);
    expect(premium.roleTitle, equals('Premium Member'));
  });
}
