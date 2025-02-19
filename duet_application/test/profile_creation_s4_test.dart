import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duet_application/src/frontEnd/profile_creation/profile_creation_s4.dart';

void main() {
  testWidgets('ProfileCreationStep4 renders correctly',
      (WidgetTester tester) async {
    bool nextStepCalled = false;

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: ProfileCreationStep4(
        nextStep: () {
          nextStepCalled = true;
        },
      ),
    ));

    // Verify the basic structure and content
    expect(find.text('Connect your Spotify'), findsOneWidget);
    expect(find.text('Step 4 of 4'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Verify the container styling
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.white));
    expect(decoration.borderRadius, equals(BorderRadius.circular(16.0)));

    // Test the next button functionality
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(nextStepCalled, isTrue);
  });

  testWidgets('ProfileCreationStep4 has correct background color',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProfileCreationStep4(
        nextStep: () {},
      ),
    ));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(const Color(0xFFE0CFF2)));
  });

  testWidgets('ProfileCreationStep4 button has correct styling',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ProfileCreationStep4(
        nextStep: () {},
      ),
    ));

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final buttonStyle = button.style as ButtonStyle;

    // Verify button background color
    final backgroundColor = buttonStyle.backgroundColor?.resolve({});
    expect(backgroundColor, equals(Colors.grey));

    // Verify button shape
    final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
    expect(shape.borderRadius, equals(BorderRadius.circular(24.0)));
  });
}
