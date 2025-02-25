import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../backend/userProfile.dart';
import '../backend/spotifyUserData.dart';
import 'swipeUser.dart';

class SwipeUserParent extends StatefulWidget {
  final UserProfileData currentUser;

  const SwipeUserParent({
    super.key,
    required this.currentUser,
  });

  @override
  State<SwipeUserParent> createState() => _SwipeUserParentState();
}

class _SwipeUserParentState extends State<SwipeUserParent> {
  List<UserProfileData> potentialMatches = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPotentialMatches();
  }

  Future<void> _loadPotentialMatches() async {
    setState(() {
      isLoading = true;
    });

    // Get all users from Firestore
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Filter out current user and already swiped users
    final filteredUsers = await Future.wait(usersSnapshot.docs.where((doc) {
      final userId = doc.get('uuid');
      return userId != widget.currentUser.uuid &&
          !widget.currentUser.likedUsers.contains(userId) &&
          !widget.currentUser.dislikedUsers.contains(userId);
    }).map((doc) async {
      final userData = UserProfileData.fromMap(doc.data());
      return userData;
    }));

    setState(() {
      potentialMatches = filteredUsers;
      isLoading = false;
    });
  }

  void handleSwipe(bool isLiked) async {
    if (currentIndex < potentialMatches.length) {
      // Get Spotify data for the current profile
      final spotifyData =
          await potentialMatches[currentIndex].getSpotifyUserData();

      setState(() {
        currentIndex++;
      });

      // If we've reached the end of our list, load more matches
      if (currentIndex >= potentialMatches.length) {
        _loadPotentialMatches();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (potentialMatches.isEmpty) {
      return const Center(child: Text('No more profiles to show'));
    }

    if (currentIndex >= potentialMatches.length) {
      return const Center(child: Text('No more profiles to show'));
    }

    return FutureBuilder<SpotifyUserData?>(
      future: potentialMatches[currentIndex].getSpotifyUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SwipeUserScreen(
          userProfile: potentialMatches[currentIndex],
          spotifyUserData: snapshot.data ??
              SpotifyUserData(
                uuid: potentialMatches[currentIndex].uuid,
                email: potentialMatches[currentIndex].email,
                favoriteGenres: [],
              ),
          swipeAction: handleSwipe,
        );
      },
    );
  }
}
