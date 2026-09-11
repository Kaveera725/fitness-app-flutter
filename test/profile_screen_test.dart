import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness/screens/profile/profile_screen.dart';
import 'package:fitness/services/api_service.dart';

void main() {
  testWidgets('ProfileScreen removes email address part and Delete Account section', (WidgetTester tester) async {
    // Simulate user login
    ApiService.instance.currentUser = UserSession(
      id: 12,
      email: 'member@gmail.com',
      name: 'Anushad Kaveera',
      role: 'user',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify user name is present in both header and Full Name input
    expect(find.text('Anushad Kaveera'), findsNWidgets(2));

    // Verify Email Address text and fields are completely removed
    expect(find.text('member@gmail.com'), findsNothing);
    expect(find.text('Email Address'), findsNothing);

    // Verify Delete Account section is completely removed
    expect(find.text('Delete Account'), findsNothing);

    // Verify remaining personal information fields are present
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
  });
}
