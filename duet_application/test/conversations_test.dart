import 'package:duet_application/src/messaging/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessagingPage', () {
    testWidgets('messages displayed correctly', (WidgetTester tester) async {
      // test if a TextBubble is displayed with 1 message
      List<Message> msgs = [Message("sender", "receiver", "text")];

      MessagingPage msging = MessagingPage(
        senderId: "sender",
        receiverId: "receiver",
        messages: msgs,
      );

      await tester.pumpWidget(msging);

      final find1text = find.byType(TextBubble);

      expect(find1text, findsOneWidget);

      // test if all text messages are displayed
      msgs = [
        Message("sender", "receiver", "text1"),
        Message("sender", "receiver", "text2"),
        Message("reciever", "sender", "text3"),
        Message("sender", "receiver", "text4"),
        Message("reciever", "sender", "text5"),
        Message("sender", "receiver", "text6"),
        Message("reciever", "sender", "text7"),
      ];

      msging = MessagingPage(
        senderId: "sender",
        receiverId: "receiver",
        messages: msgs,
      );

      await tester.pumpWidget(msging);

      final findText1 = find.text("text1");
      final findText2 = find.text("text2");
      final findText3 = find.text("text3");
      final findText4 = find.text("text4");
      final findText5 = find.text("text5");
      final findText6 = find.text("text6");
      final findText7 = find.text("text7");

      expect(findText1, findsOne);
      expect(findText2, findsOne);
      expect(findText3, findsOne);
      expect(findText4, findsOne);
      expect(findText5, findsOne);
      expect(findText6, findsOne);
      expect(findText7, findsOne);
    });

    // testWidgets("send messages", (WidgetTester tester){

    // });
  });
}
