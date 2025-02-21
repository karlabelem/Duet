import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duet_application/src/backend/userProfile.dart';

class DmListBackend {
  /// The uuid of the user logged in
  final String uuid1;
  /// List of conversations (ids of the conversations)
  List<String> conversations;
  List<Map<String, String>> names;

  DmListBackend({required this.uuid1, List<String>? conversations, List<Map<String, String>>? names})
      : conversations = conversations ?? [],
        names = names ?? [];

  factory DmListBackend.fromMap(Map<String, dynamic> data) {
    return DmListBackend(
      uuid1: data['uuid1'],
      conversations: List<String>.from(data['conversations']),
      names: List<Map<String, String>>.from(data['names']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid1': uuid1,
      'conversations': conversations,
      'names': names,
    };
  }

  Future<int> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('dm_list')
          .doc(uuid1)
          .set(toMap());
      return 0;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return 1;
    }
  }

  /// Get all documents in the messaging collection that contain the uuid substring
  Future<void> getDocumentsWithUuidSubstring(String uuid) async {
    List<String> documentNames = [];
    List<Map<String, String>> userNames = [];
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .get();
      for (var doc in querySnapshot.docs) {
        if (doc.id.contains(uuid)) {
          documentNames.add(doc.id);
          List<String> profiles = doc.id.split("_");
          UserProfileData? profile1 = await UserProfileData.getUserProfile(profiles[0]);
          UserProfileData? profile2 = await UserProfileData.getUserProfile(profiles[1]);
          if (profile1 != null && profile2 != null) {
            userNames.add({profile1.uuid: profile1.name, profile2.uuid: profile2.name});
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    conversations = documentNames;
    names = userNames;
  }

  /// Fetch conversations from Firestore
  Future<void> fetchConversations() async {
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('dm_list')
          .doc(uuid1)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        conversations = List<String>.from(data['conversations']);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

/// Get the list of conversations a user has
Future<DmListBackend?> getConversation(String uuid1) async {
  try {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('dm_list')
        .doc(uuid1)
        .get();
    if (doc.exists) {
      return DmListBackend.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
    return null;
  }
}

