// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter initializes before Firebase
//   await Firebase.initializeApp(); // Initialize Firebase  
  
//   // Set up the SettingsController, which will glue user settings to multiple
//   // Flutter Widgets.
//   final settingsController = SettingsController(SettingsService());

//   // Load the user's preferred theme while the splash screen is displayed.
//   // This prevents a sudden theme change when the app is first displayed.
//   await settingsController.loadSettings();

//   // Run the app and pass in the SettingsController. The app listens to the
//   // SettingsController for changes, then passes it further down to the
//   // SettingsView.
//   runApp(MyApp(settingsController: settingsController));
// }

// Below is for testing minimal Firebase connection.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch users from Firestore
  QuerySnapshot snapshot = await firestore.collection('users').get();
  for (var doc in snapshot.docs) {
    print("User ID: ${doc.id}, Data: ${doc.data()}");
  }

  runApp(MyApp()); // Run the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Firestore Test")),
        body: Center(child: Text("Check debug console for Firestore users.")),
      ),
    );
  }
}
