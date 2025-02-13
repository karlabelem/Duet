import 'package:flutter/material.dart';
import 'userProfile.dart';

// ------------------ User Profile Screen ------------------
class UserProfileScreen extends StatefulWidget {
  final UserProfileData userProfile;

  const UserProfileScreen({super.key, required this.userProfile});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${widget.userProfile.name}", style: TextStyle(fontSize: 18)),
            Text("Email: ${widget.userProfile.email}", style: TextStyle(fontSize: 18)),
            Text("DOB: ${widget.userProfile.dob}", style: TextStyle(fontSize: 18)),
            Text("Location: ${widget.userProfile.location}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("About Me:"),
            Text(widget.userProfile.bio),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final updatedAboutMe = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAboutMeScreen(bio: widget.userProfile.bio),
                  ),
                );
                if (updatedAboutMe != null) {
                  // Update bio in Firestore when changed
                  await widget.userProfile.updateBio(updatedAboutMe);
                  setState(() {
                    widget.userProfile.bio = updatedAboutMe;
                  });
                }
              },
              child: Text("Edit About Me"),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(userProfile: widget.userProfile),
                  ),
                );
                if (updatedProfile != null) {
                  // Update profile details in Firestore when changed
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
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
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
      appBar: AppBar(title: Text("Edit About Me")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, maxLines: 3),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text("Save"),
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
  late TextEditingController _nameController, _emailController, _dobController, _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _dobController = TextEditingController(text: widget.userProfile.dob);
    _locationController = TextEditingController(text: widget.userProfile.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _dobController, decoration: InputDecoration(labelText: "DOB")),
            TextField(controller: _locationController, decoration: InputDecoration(labelText: "Location")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'dob': _dobController.text,
                  'location': _locationController.text,
                });
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}