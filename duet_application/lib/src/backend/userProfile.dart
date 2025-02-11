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
    Add Spotify data fetch method
  */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Create an instance of the Uuid class
var _uuidGen = Uuid();

// This class represents a user's profile data.
// It stores user details (name, DOB, location) and rankings for other users.
// The `rankedProfiles` map stores user UUIDs with their ranking (-1, 0, 1).
// Rankings can be dynamically updated via the `rankUser` method.
class UserProfileData {
  final String _uuid;  // Private unique user ID
  String name, dob, location;
  String imageUrl, bio;
  List<String> likedUsers; // Stores liked users with user UUIDs
  List<String> dislikedUsers; // Stores liked users with user UUIDs

  UserProfileData({
    required this.name,
    required this.dob,
    required this.location,
    required this.imageUrl,
    this.bio = "",
    List<String>? likedUsers,
    List<String>? dislikedUsers,
  })  : _uuid = _uuidGen.v4(),
        likedUsers = likedUsers ?? [],
        dislikedUsers = dislikedUsers ?? [];

  // Convert to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'dob': dob,
      'location': location,
      'imageUrl': imageUrl,
      'bio': bio,
      'likedUsers': likedUsers,
      'dislikedUsers': dislikedUsers,
    };
  }

  // Create an instance from Firestore data
  factory UserProfileData.fromMap(Map<String, dynamic> data) {
    return UserProfileData(
      name: data['name'] ?? '',
      dob: data['dob'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      bio: data['bio'] ?? '',
      likedUsers: List<String>.from(data['likedUsers'] ?? []),
      dislikedUsers: List<String>.from(data['dislikedUsers'] ?? []),
    );
  }
  // Getter for _uuid (to allow read access)
  String get uuid => _uuid;

  // Save user profile data to Firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(uuid).set(toMap()); // creates users collection
  }

  // Method for getting UserProfile Snapshot shortcut
  Future<UserProfileData?> getUserProfile(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId); // fetch data from Firestore users collection
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      return UserProfileData.fromMap(userSnapshot.data()!);
    }
    return null;
  }

  // Swipe function to update userprofile
  Future<void> swipeUser(String otherUuid, bool isLiked) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uuid); // fetch data from Firestore users collection

    // Transaction is for updating data in Firebase directly rather than updating on local class
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Access to user snapshot with transaction
      final userTransaction = await transaction.get(userRef);
      if (!userTransaction.exists) return;

      // Get liked and disliked users data from the database map from Firestore transaction
      final data = userTransaction.data() as Map<String, dynamic>;
      likedUsers = List<String>.from(data['likedUsers'] ?? []);
      dislikedUsers = List<String>.from(data['dislikedUsers'] ?? []);

      // Update liked/disliked lists
      if (isLiked) {
        if (!likedUsers.contains(otherUuid)) {
          likedUsers.add(otherUuid);
        }
        dislikedUsers.remove(otherUuid);
      } else {
        if (!dislikedUsers.contains(otherUuid)) {
          dislikedUsers.add(otherUuid);
        }
        likedUsers.remove(otherUuid);
      }

      // Add updated changes on transaction through Firestore
      transaction.update(userRef, {
        'likedUsers': likedUsers,
        'dislikedUsers': dislikedUsers,
      });
    });
  }

  // Method to update bio info
  Future<void> updateBio(String newBio) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uuid);

    // Run a transaction to update the bio
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userTransaction = await transaction.get(userRef);
      if (!userTransaction.exists) return;

      // Update the bio directly in Firestore
      transaction.update(userRef, {
        'bio': newBio,
      });
    });
  }

  // Method to update profile details (name, dob, location)
  Future<void> updateProfile(String newName, String newDob, String newLocation) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uuid);

    // Run a transaction to update profile details
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userTransaction = await transaction.get(userRef);
      if (!userTransaction.exists) return;

      // Update profile details directly in Firestore
      transaction.update(userRef, {
        'name': newName,
        'dob': newDob,
        'location': newLocation,
      });
    });
  }

  // Method to update profile picture
  Future<void> updateImage(String newImageUrl) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uuid);

    // Run a transaction to update profile details
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userTransaction = await transaction.get(userRef);
      if (!userTransaction.exists) return;

      // Update profile details directly in Firestore
      transaction.update(userRef, {
        'imageUrl': newImageUrl,
      });
    });
  }
}