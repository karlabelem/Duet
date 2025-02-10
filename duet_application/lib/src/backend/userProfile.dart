 /* This file is for user profile to keep track of information about users
  *
  * UserProfileData class has the following informations about the user:
      - uuid: Unique User ID
      - name: Name of the user
      - dob: Date of birth
      - location: Current location of the user
      - aboutMe: Users about me section to let them have a small text on the profile
      - Spotify Data: Their connected spotify data??
      - Ranked Profiles: Ranked profiles on the feed
  *
  * TODO:
    Add Spotify userName/extend Spoify Class
  */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

// Create an instance of the Uuid class
var _uuidGen = Uuid();

// This class represents a user's profile data.
// It stores user details (name, DOB, location) and rankings for other users.
// The `rankedProfiles` map stores user UUIDs with their ranking (-1, 0, 1).
// Rankings can be dynamically updated via the `rankUser` method.
class UserProfileData {
  final String _uuid;  // Private unique user ID
  String name, dob, location;
  String aboutMe;
  Map<String, int> rankings; // Stores rankings with user UUIDs

  UserProfileData({
    required this.name,
    required this.dob,
    required this.location,
    this.aboutMe = "",
    Map<String, int>? rankings,
  })  : _uuid = _uuidGen.v4(),
        rankings = rankings ?? {};

  // Convert to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'dob': dob,
      'location': location,
      'aboutMe': aboutMe,
      'rankings': rankings,
    };
  }

  // Create an instance from Firestore data
  factory UserProfileData.fromMap(Map<String, dynamic> data) {
    return UserProfileData(
      name: data['name'],
      dob: data['dob'],
      location: data['location'],
      aboutMe: data['aboutMe'] ?? "",
      rankings: Map<String, int>.from(data['rankings'] ?? {}),
    );
  }
  // Getter for _uuid (to allow read access)
  String get uuid => _uuid;

  // Save user profile data to Firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(uuid).set(toMap());
  }

  // Update ranking data in Firestore
  Future<void> updateRanking(String rankedUserUuid, int rank) async {
    rankings[rankedUserUuid] = rank;
    await FirebaseFirestore.instance.collection('users').doc(uuid).update({'rankings': rankings});
  }
}

// ------------------ User Profile Screen ------------------
class UserProfileScreen extends StatefulWidget {
  final UserProfileData userProfile;

  UserProfileScreen({required this.userProfile});

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
            Text("DOB: ${widget.userProfile.dob}", style: TextStyle(fontSize: 18)),
            Text("Location: ${widget.userProfile.location}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("About Me:"),
            Text(widget.userProfile.aboutMe),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final updatedAboutMe = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAboutMeScreen(aboutMe: widget.userProfile.aboutMe),
                  ),
                );
                if (updatedAboutMe != null) {
                  setState(() {
                    widget.userProfile.aboutMe = updatedAboutMe;
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
                  setState(() {
                    widget.userProfile.name = updatedProfile['name'];
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

// ------------------ Ranking Management ------------------
class RankingWidget extends StatelessWidget {
  final UserProfileData userProfile;
  final String rankedUserUuid;

  RankingWidget({required this.userProfile, required this.rankedUserUuid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up),
          color: userProfile.rankings[rankedUserUuid] == 1 ? Colors.blue : Colors.grey,
          onPressed: () async {
            await userProfile.updateRanking(rankedUserUuid, 1);
          },
        ),
        IconButton(
          icon: Icon(Icons.thumb_down),
          color: userProfile.rankings[rankedUserUuid] == -1 ? Colors.red : Colors.grey,
          onPressed: () async {
            await userProfile.updateRanking(rankedUserUuid, -1);
          },
        ),
      ],
    );
  }
}

// ------------------ Edit About Me Screen ------------------
class EditAboutMeScreen extends StatefulWidget {
  final String aboutMe;
  EditAboutMeScreen({required this.aboutMe});

  @override
  _EditAboutMeScreenState createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends State<EditAboutMeScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.aboutMe);
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
  EditProfileScreen({required this.userProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController, _dobController, _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
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
            TextField(controller: _dobController, decoration: InputDecoration(labelText: "DOB")),
            TextField(controller: _locationController, decoration: InputDecoration(labelText: "Location")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
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
