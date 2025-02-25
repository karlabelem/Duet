import 'package:duet_application/src/backend/spotifyUserData.dart';
import 'package:flutter/material.dart';
import '../backend/userProfile.dart';

// ------------------ Swipe User  ------------------
class SwipeUserScreen extends StatefulWidget {
  final UserProfileData userProfile;
  final SpotifyUserData spotifyUserData;
  final Function(bool) swipeAction;

  const SwipeUserScreen({super.key, required this.userProfile, required this.swipeAction, required this.spotifyUserData});

  @override
  State<SwipeUserScreen> createState() => _SwipeUserScreenState();
}

class _SwipeUserScreenState extends State<SwipeUserScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          widget.swipeAction(true); // Swiped right (like)
          widget.userProfile
              .swipeUser(widget.userProfile.uuid, true); // add await maybe???
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          widget.swipeAction(false); // Swiped left (dislike)
          widget.userProfile
              .swipeUser(widget.userProfile.uuid, false); // add await maybe???
        }
      },
      child: Card(
        color: Color(0xFF5C469C),
        elevation: 20,
        margin: EdgeInsets.all(40),
        child: Column(
            children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, size: 50, color: Color(0xFF5C469C)),
            ),
            const SizedBox(height: 20),
            Text(
              widget.userProfile.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.userProfile.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.userProfile.location,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Favorite Genres:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.spotifyUserData.favoriteGenres!.map((genre) {
                return Chip(
                  label: Text(genre, style: const TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xFF5C469C),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
