import 'package:duet_application/src/backend/userProfile.dart';
import 'package:flutter/material.dart';

// ------------------ User Profile Screen ------------------
class UserProfileScreen extends StatefulWidget {
  final UserProfileData userProfile;

  const UserProfileScreen({super.key, required this.userProfile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
                        side: BorderSide(width: 5, color: Color(0xFF5C469C)),
                      ),
                    ),
                  ),
                ),
                _buildProfileInfo(context),
                _buildAboutMeSection(context)
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
                  fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20, decoration: TextDecoration.none)),
          Text(value,
              style: const TextStyle(fontSize: 50, color: Colors.black, decoration: TextDecoration.none)),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About Me:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
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
              await widget.userProfile.updateBio(updatedAboutMe);
              setState(() {
                widget.userProfile.bio = updatedAboutMe;
              });
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
              await widget.userProfile.updateProfile(
                updatedProfile['name'],
                updatedProfile['email'],
                updatedProfile['dob'],
                updatedProfile['location'],
              );
              setState(() {
                widget.userProfile.name = updatedProfile['name'];
                widget.userProfile.email = updatedProfile['email'];
                widget.userProfile.dob = updatedProfile['dob'];
                widget.userProfile.location = updatedProfile['location'];
              });
            }
          },
          child: const Text("Edit Profile"),
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
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.bio);
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
