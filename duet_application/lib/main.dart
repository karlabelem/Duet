import 'package:duet_application/src/backend/spotifyUserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  //runApp(MyApp(settingsController: settingsController));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  dotenv.load();

  runApp(MaterialApp(
    home: ElevatedButton(
      onPressed: () async {
        await SpotifyUserData.createSpotifyProfile("uuid");
      },
      child: Text("Create Spotify Profile"),
    )
  ));

  // await Firebase.initializeApp(
  //   demoProjectId: "demo-project-id",
  // );
}
