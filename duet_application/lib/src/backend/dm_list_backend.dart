import 'package:cloud_firestore/cloud_firestore.dart';

class DmListBackend {
  /// The uuid of the user logged in
  final String uuid1;
  /// List of conversations (ids of the conversations)
  List<String> conversations;


  DmListBackend({ required this.uuid1, List<String>? conversations})
      : conversations = conversations ?? [];

  factory DmListBackend.fromMap(Map<String, dynamic> data) {
    return DmListBackend(
        uuid1: data['uuid1'],
        conversations: data['conversations']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid1': uuid1,
      'conversations': conversations
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
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .get();
      for (var doc in querySnapshot.docs) {
        if (doc.id.contains(uuid)) {
          documentNames.add(doc.id);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    conversations = documentNames;
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

