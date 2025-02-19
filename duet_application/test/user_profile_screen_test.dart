// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:duet_application/src/backend/userProfileScreen.dart';
// import 'package:duet_application/src/backend/userProfile.dart';

// void main() {
//   testWidgets('Edit Profile screen navigation and update', (WidgetTester tester) async {
//     // Mock UserProfileData
//     final userProfile = UserProfileData(
//       name: 'John Doe',
//       email: 'johndoe@example.com',
//       dob: '01/01/1990',
//       location: 'New York',
//       bio: 'A passionate music lover.',
//     );

//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: UserProfileScreen(userProfile: userProfile),
//         ),
//       ),
//     );

//     // Ensure "Edit Profile" button is visible before tapping
//     final editProfileFinder = find.text('Edit Profile');
//     await tester.ensureVisible(editProfileFinder);
//     await tester.pumpAndSettle();

//     // Tap "Edit Profile" button
//     await tester.tap(editProfileFinder);
//     await tester.pumpAndSettle();

//     // Ensure the Edit Profile screen appears
//     expect(find.text('Edit Profile'), findsOneWidget);

//     // Verify text fields exist
//     expect(find.byType(TextField), findsNWidgets(4));

//     // Update profile data
//     await tester.enterText(find.byType(TextField).at(0), 'Jane Doe');
//     await tester.enterText(find.byType(TextField).at(1), 'janedoe@example.com');
//     await tester.enterText(find.byType(TextField).at(2), '02/02/1992');
//     await tester.enterText(find.byType(TextField).at(3), 'California');

//     // Tap "Save" button
//     await tester.tap(find.text('Save'));
//     await tester.pumpAndSettle();

//     // Verify UI updates
//     expect(find.text('Jane Doe'), findsOneWidget);
//     expect(find.text('janedoe@example.com'), findsOneWidget);
//     expect(find.text('02/02/1992'), findsOneWidget);
//     expect(find.text('California'), findsOneWidget);
//   });
// }

