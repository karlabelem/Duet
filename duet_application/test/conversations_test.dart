import 'package:duet_application/src/backend/messaging_backend.dart';
import 'package:duet_application/src/messaging/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextBubble Widget', () {
    testWidgets('displays message text correctly', (WidgetTester tester) async {
      // Arrange
      final message = Message('sender', 'receiver', 'Hello, World!');
      final widget = MaterialApp(
        home: Scaffold(
          body: TextBubble(msg: message, sender: 'sender'),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('aligns message to the right for sender', (WidgetTester tester) async {
      // Arrange
      final message = Message('sender', 'receiver', 'Hello, World!');
      final widget = MaterialApp(
        home: Scaffold(
          body: TextBubble(msg: message, sender: 'sender'),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final align = container.child as Align;
      expect(align.alignment, Alignment.topRight);
    });

    testWidgets('aligns message to the left for receiver', (WidgetTester tester) async {
      // Arrange
      final message = Message('receiver', 'sender', 'Hello, World!');
      final widget = MaterialApp(
        home: Scaffold(
          body: TextBubble(msg: message, sender: 'sender'),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final align = container.child as Align;
      expect(align.alignment, Alignment.topLeft);
    });
  });

  group('SendButton Widget', () {
    testWidgets('calls send function when pressed', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;
      final widget = MaterialApp(
        home: Scaffold(
          body: SendButton(
            send: (text) {
              wasPressed = true;
            },
            typedText: TextEditingController(),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('displays send icon', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          body: SendButton(
            send: (text) {},
            typedText: TextEditingController(),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}