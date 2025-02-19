import 'package:flutter/material.dart';
import 'userProfile.dart';

// ------------------ Swipe User  ------------------
class SwipeUserScreen extends StatefulWidget {
  final UserProfileData userProfile;
  final Function(bool) swipeAction;

  const SwipeUserScreen({super.key, required this.userProfile, required this.swipeAction});

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
            Text(widget.userProfile.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.userProfile.bio),
            //this should show the spotify data from the user
          ],
        ),
      ),
    );
  }
}
