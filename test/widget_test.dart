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
  });
}
