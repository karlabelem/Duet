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
  *
  */

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
  final String name, dob, location; // Public fields: name, dob, location
  String aboutMe; // This will be updated dynamically

  // Map to store rankings given by this user (key = ranked user's UUID, value = rank)
  Map<String, int> rankedProfiles; 

  // Constructor Method
  UserProfileData({
    required this.name,
    required this.dob,
    required this.location,
    this.aboutMe = "" // Initialize as empty and update later
  }) :   this._uuid = _uuidGen.v4(), // Generate and assign a UUID
         this.rankedProfiles = {}; // Initialize empty map

  // Getter for _uuid (to allow read access)
  String get uuid => _uuid;

  // Method to update ranking
  void rankUser(String rankedUserUuid, int rankValue) {
    if (rankValue < -1 || rankValue > 1) return; // Ensure valid ranking
    rankedProfiles[rankedUserUuid] = rankValue;
  }

}

// This screen displays a user's profile, allowing them to update their bio
// and rank other users. Rankings dynamically update and persist in the UI.
// It fetches data from `UserProfileData` and modifies rankings in real time.
class UserProfileScreen extends StatefulWidget {
  final String name, dob, location; // Expecting data from login

  // Constructor to receive user details
  const UserProfileScreen({
    required this.name,
    required this.dob,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _aboutMeController = TextEditingController();
  late UserProfileData _userProfile;

  @override
  void initState() {
    super.initState();

    // Assume these values come from the logged-in user's data
    String userName = widget.name; // Passed from login page
    String userDob = widget.dob; 
    String userLocation = widget.location;

    _userProfile = UserProfileData(
      name: userName,
      dob: userDob,
      location: userLocation,
    );

    // Set initial value for text field if there's existing data
    _aboutMeController.text = _userProfile.aboutMe;
  }

  void _saveAboutMe() {
    setState(() {
      _userProfile.aboutMe = _aboutMeController.text; // Update the object
    });
  }

  void _updateRanking(String rankedUserUuid, int rankValue) {
    setState(() {
      _userProfile.rankUser(rankedUserUuid, rankValue);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About Me:", style: TextStyle(fontSize: 18)),
            TextField(
              controller: _aboutMeController,
              decoration: InputDecoration(
                hintText: "Tell us about yourself...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveAboutMe,
              child: Text("Save"),
            ),
            SizedBox(height: 20),
            Text("Saved Info: ${_userProfile.aboutMe}"),
          ],
        ),
      ),
    );
  }

  // Method to update the rankings upon cliking like/dislike
  Widget _buildRanking(String userUuid, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(userName),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.thumb_down, color: _userProfile.rankedProfiles[userUuid] == -1 ? Colors.red : Colors.grey),
              onPressed: () => _updateRanking(userUuid, -1),
            ),
            IconButton(
              icon: Icon(Icons.remove, color: _userProfile.rankedProfiles[userUuid] == 0 ? Colors.blue : Colors.grey),
              onPressed: () => _updateRanking(userUuid, 0),
            ),
            IconButton(
              icon: Icon(Icons.thumb_up, color: _userProfile.rankedProfiles[userUuid] == 1 ? Colors.green : Colors.grey),
              onPressed: () => _updateRanking(userUuid, 1),
            ),
          ],
        ),
      ],
    );
  }
}