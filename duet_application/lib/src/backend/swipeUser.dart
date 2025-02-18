import 'package:flutter/material.dart';
import 'userProfile.dart';

// ------------------ Swipe User  ------------------
class SwipeUserScreen extends StatefulWidget {
  final UserProfileData userProfile;
  final Function(bool) swipeAction;

  SwipeUserScreen({required this.userProfile, required this.swipeAction});

  @override
  _SwipeUserScreenState createState() => _SwipeUserScreenState();
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
        child: Column(
          children: [
            Image.network(widget.userProfile.imageUrl,
                height: 200, fit: BoxFit.cover),
            Text(widget.userProfile.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.userProfile.bio),
          ],
        ),
      ),
    );
  }
}
