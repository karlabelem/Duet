import 'package:duet_application/src/backend/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:duet_application/src/backend/spotifyUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//(when we have database configured) import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:duet_application/src/backend/spotifyUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//(when we have database configured) import 'package:firebase_auth/firebase_auth.dart';

// ------------------ User Profile Screen ------------------
class UserProfileScreen extends StatefulWidget {
  final UserProfileData userProfile;

  const UserProfileScreen({super.key, required this.userProfile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<String> favoriteArtists = [];

  @override
  void initState() {
    super.initState();
    _loadTopArtists();
  }

  Future<void> _loadTopArtists() async {
    // Replace with the actual UUID of the logged-in user
    String userUuid =
        "user-uuid-goes-here"; // needs firebase data, because we have to manually insert UUID

    SpotifyUserData userData = await SpotifyUserData.get(userUuid);
    final artists = await userData.fetchArtists(limit: 5); // Get top 5 artists

    setState(() {
      favoriteArtists =
          artists.map((artist) => artist['name'] as String).toList();
    });
  }

  // Main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5C469C),
        title: Text("User Profile"),
        leading: IconButton(
          icon: Icon(Icons.menu), // Three-line menu icon
          onPressed: () {
            // Show the dropdown menu when the icon is pressed
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(0, 60, 0, 0), // Adjust position of menu
              items: <PopupMenuEntry>[
                PopupMenuItem<String>(
                  value: 'HOME',
                  child: Text('HOME'),
                ),
                PopupMenuItem<String>(
                  value: 'PROFILE',
                  child: Text('PROFILE'),
                ),
                PopupMenuItem<String>(
                  value: 'SIGN OUT',
                  child: Text('SIGN OUT'),
                ),
              ],
            );
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFE6E6FA), // Lilac background
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(), // Profile Card
            const SizedBox(width: 16),
            _buildAboutMeCard(), // About Me section next to Profile Card
            const SizedBox(width: 16),
            _buildTopArtistsCard(), // Music section next to About Me section
            const SizedBox(width: 16),
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       _buildTopArtistsSection(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // User Profile Card
  Widget _buildProfileCard() {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF5C469C),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.userProfile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 5),
            _buildInfoRow("Name", widget.userProfile.name),
            _buildInfoRow("Email", widget.userProfile.email),
            _buildInfoRow("DOB", widget.userProfile.dob),
            _buildInfoRow("Location", widget.userProfile.location),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(userProfile: widget.userProfile),
                  ),
                );

                if (updatedProfile != null) {
                  setState(() {
                    widget.userProfile.name = updatedProfile['name'];
                    widget.userProfile.email = updatedProfile['email'];
                    widget.userProfile.dob = updatedProfile['dob'];
                    widget.userProfile.location = updatedProfile['location'];
                  });

                  await widget.userProfile.updateProfile(
                    updatedProfile['name'],
                    updatedProfile['email'],
                    updatedProfile['dob'],
                    updatedProfile['location'],
                  );
                }
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ), 
    );
  }

  // Info Print Method
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Slightly increased padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, // Increased font size
              color: Colors.black87, // Darker text color for better readability
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right, // Keeps text aligned properly
              style: const TextStyle(
                fontSize: 16, // Increased font size
                color: Colors.black, // Ensures good contrast
              ),
              overflow: TextOverflow.ellipsis, // Prevents overflow issues
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // About Me Card
  Widget _buildAboutMeCard() {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("About Me", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            Text(widget.userProfile.bio, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final updatedAboutMe = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditAboutMeScreen(bio: widget.userProfile.bio),
                  ),
                );
                if (updatedAboutMe != null) {
                  setState(() {
                    widget.userProfile.bio = updatedAboutMe;
                  });
                  await widget.userProfile.updateBio(updatedAboutMe);
                }
              },
              child: const Text("Edit", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  // Top Artists Card
  Widget _buildTopArtistsCard() {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Top Artists",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              favoriteArtists.isEmpty
                  ? const Text("No top artists available.", 
                      style: TextStyle(fontSize: 16, color: Colors.black54))
                  : Column(
                      children: favoriteArtists
                          .take(5) // Ensure only top 5 artists are displayed
                          .map((artist) => Text(artist, 
                              style: const TextStyle(fontSize: 16, color: Colors.black)))
                          .toList(),
                    ),
            ],
          ),
        ),
    );
  }

  // // Top Genres Card
  // Widget _buildTopGenresCard() {
  //   return Card(
  //     elevation: 6.0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     margin: const EdgeInsets.all(16.0),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Text(
  //             "Top Genres",
  //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
  //           ),
  //           const SizedBox(height: 10),
  //           favoriteGenres.isEmpty
  //               ? const Text("No top genres available.", 
  //                   style: TextStyle(fontSize: 16, color: Colors.black54))
  //               : Column(
  //                   children: favoriteGenres
  //                       .take(5) // Ensure only top 5 genres are displayed
  //                       .map((genre) => Text(genre, 
  //                           style: const TextStyle(fontSize: 16, color: Colors.black)))
  //                       .toList(),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // // Top Songs Card
  // Widget _buildTopSongsCard() {
  //   return Card(
  //     elevation: 6.0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     margin: const EdgeInsets.all(16.0),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Text(
  //             "Top Songs",
  //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
  //           ),
  //           const SizedBox(height: 10),
  //           favoriteSongs.isEmpty
  //               ? const Text("No top songs available.", 
  //                   style: TextStyle(fontSize: 16, color: Colors.black54))
  //               : Column(
  //                   children: favoriteSongs
  //                       .take(5) // Ensure only top 5 songs are displayed
  //                       .map((song) => Text(song, 
  //                           style: const TextStyle(fontSize: 16, color: Colors.black)))
  //                       .toList(),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// ------------------ Edit About Me Screen ------------------
class EditAboutMeScreen extends StatefulWidget {
  final String bio;
  const EditAboutMeScreen({super.key, required this.bio});

  @override
  State<EditAboutMeScreen>  createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends State<EditAboutMeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.bio; // Set initial value
    _controller.text = widget.bio; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit About Me")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Write something about yourself...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

// ------------------ Edit Profile Screen ------------------
class EditProfileScreen extends StatefulWidget {
  final UserProfileData userProfile;
  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController,
      _emailController,
      _dobController,
      _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _dobController = TextEditingController(text: widget.userProfile.dob);
    _locationController =
        TextEditingController(text: widget.userProfile.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                  labelText: "DOB", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                  labelText: "Location", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'dob': _dobController.text,
                  'location': _locationController.text,
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

