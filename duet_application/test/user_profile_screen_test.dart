import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duet_application/src/frontEnd/userProfileScreen.dart';
import 'package:duet_application/src/backend/userProfile.dart';

void main() {
  testWidgets('Edit Profile screen navigation and update', (WidgetTester tester) async {
    // Mock UserProfileData
    final userProfile = UserProfileData(
      name: 'John Doe',
      email: 'johndoe@example.com',
      dob: '01/01/1990',
      location: 'New York',
      bio: 'A passionate music lover.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserProfileScreen(userProfile: userProfile),
        ),
      ),
    );

    // Verify that the screen shows the user's profile details
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('johndoe@example.com'), findsOneWidget);
    expect(find.text('01/01/1990'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);
    expect(find.text('A passionate music lover.'), findsOneWidget);
  });
}

