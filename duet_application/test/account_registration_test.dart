import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duet_application/src/frontEnd/profile_creation/profile_creation_s0.dart';

void main() {
  testWidgets('AccountRegistration widget test', (WidgetTester tester) async {
    // Mock callback function
    Map<String, String>? submittedData;
    void mockNextStep(Map<String, String> data) {
      submittedData = data;
    }

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: AccountRegistration(nextStep: mockNextStep),
    ));

    // Verify initial state
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Test button is initially disabled (grey)
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final buttonStyle = button.style as ButtonStyle;
    expect(
      buttonStyle.backgroundColor?.resolve({}),
      Colors.grey,
    );

    // Enter valid credentials
    await tester.enterText(
        find.widgetWithText(TextField, 'Email'), 'test@example.com');
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    await tester.pump();

    // Verify button is now enabled (purple)
    final updatedButton =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final updatedStyle = updatedButton.style as ButtonStyle;
    expect(
      updatedStyle.backgroundColor?.resolve({}),
      Colors.purple,
    );

    // Test form submission
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify submitted data
    expect(submittedData, {
      'email': 'test@example.com',
      'password': 'password123',
    });

    // Test password mismatch
    await tester.enterText(
        find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'), 'password456');
    await tester.pump();

    // Tap button with mismatched passwords
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify error message
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('AccountRegistration empty fields validation',
      (WidgetTester tester) async {
    void mockNextStep(Map<String, String> data) {}

    await tester.pumpWidget(MaterialApp(
      home: AccountRegistration(nextStep: mockNextStep),
    ));

    // Test with empty fields
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Button should be grey (disabled) with empty fields
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final buttonStyle = button.style as ButtonStyle;
    expect(
      buttonStyle.backgroundColor?.resolve({}),
      Colors.grey,
    );
  });
}
