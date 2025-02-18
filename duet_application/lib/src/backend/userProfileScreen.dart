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
  _UserProfileScreenState createState() => _UserProfileScreenState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1440,
        height: 1024,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(children: [
          Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(
                      verticalDirection: VerticalDirection.down,
                      children: [
                    Container(
                      width: 1440,
                      height: 80,
                      decoration: BoxDecoration(color: Color(0xFF5C469C)),
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: ShapeDecoration(
                          shape: OvalBorder(
                            side:
                                BorderSide(width: 5, color: Color(0xFF5C469C)),
                          ),
                        ),
                      ),
                    ),
                    _buildProfileInfo(context),
                    _buildAboutMeSection(context),
                    _buildTopArtistsSection(), // Displays the top artists
                  ])))
                  child: Column(
                      verticalDirection: VerticalDirection.down,
                      children: [
                    Container(
                      width: 1440,
                      height: 80,
                      decoration: BoxDecoration(color: Color(0xFF5C469C)),
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: ShapeDecoration(
                          shape: OvalBorder(
                            side:
                                BorderSide(width: 5, color: Color(0xFF5C469C)),
                          ),
                        ),
                      ),
                    ),
                    _buildProfileInfo(context),
                    _buildAboutMeSection(context),
                    _buildTopArtistsSection(), // Displays the top artists
                  ])))
        ]));
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Name", widget.userProfile.name),
        _buildInfoRow("Email", widget.userProfile.email),
        _buildInfoRow("DOB", widget.userProfile.dob),
        _buildInfoRow("Location", widget.userProfile.location),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          Text(value,
              style: const TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About Me:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(widget.userProfile.bio,
              style: const TextStyle(fontSize: 16)),
        ),
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
              await widget.userProfile.updateBio(updatedAboutMe);
            }
          },
          child: const Text("Edit About Me"),
        ),
        const SizedBox(height: 10),
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
    );
  }

  // display top five artists on profile page
  Widget _buildTopArtistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Artists:",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        favoriteArtists.isEmpty
            ? const Text("No top artists available.",
                style: TextStyle(fontSize: 16))
            : Column(
                children: favoriteArtists
                    .map((artist) =>
                        Text(artist, style: TextStyle(fontSize: 16)))
                    .toList(),
              ),
      ],
    );
  }
}

// ------------------ Edit About Me Screen ------------------
class EditAboutMeScreen extends StatefulWidget {
  final String bio;
  const EditAboutMeScreen({super.key, required this.bio});

  @override
  _EditAboutMeScreenState createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends State<EditAboutMeScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller = TextEditingController();

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
  _EditProfileScreenState createState() => _EditProfileScreenState();
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
