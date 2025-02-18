import 'package:cloud_firestore/cloud_firestore.dart';

class Messagingbackend {
/// the 2 users involved in this conversation
    final String uuid1, uuid2;
  
  /// list of messages between both users
  List<Message> conversation;

  /// unique conversation id composed of uuid1 appended with uuid2
  late final String cid;

  Messagingbackend(      {required this.uuid1, required this.uuid2, List<Message>? conversation})
      : conversation = conversation ?? [],
        cid = makeCid(uuid1, uuid2);

  /// Turns data into map format for firebase
  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'uuid1': uuid1,
      'uuid2': uuid2,
      'conversation': conversation
    };
  }

  /// constructor from a map
  factory Messagingbackend.fromMap(Map<String, dynamic> data) {
    List<Message> newConversation = [];
    for (var msg in data['conversation']) {
      newConversation.add(Message.fromMap(msg));
    }
    return Messagingbackend(
        uuid1: data['uuid1'],
        uuid2: data['uuid2'],
        conversation: newConversation);
  }

  /// Save this conversation to firestore
  Future<int> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(cid)
          .set(toMap());
      return 0;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return 1;
    }
  }

  /// Update firestore on backend side when a user sends a message
  /// Returns 0 if successful, 1 if not
  Future<int> sendMessage(Message msg) async {
    try {
      // get current conversation
      var convRef = FirebaseFirestore.instance.collection('messages').doc(cid);

      // update conversation on firestore
      conversation.add(msg);
      List<dynamic> jsonConversation = [];
      for (var msg in conversation) {
        jsonConversation.add(msg.toMap());
      }
      await convRef.update({'conversation': jsonConversation});
      return 0;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return 1;
    }
  }
}

String makeCid(String user1, String user2) {
  if(user1.compareTo(user2) > 0) {
    return "${user2}_$user1";
  }
  return "${user1}_$user2";
}

/// Get a conversation between 2 users from firestore
Future<Messagingbackend?> getConversation(String user1, String user2) async {
  try {
    var convRef = FirebaseFirestore.instance.collection('messages').doc(makeCid(user1, user2));
    var convSnapshot = await convRef.get();
    if (convSnapshot.exists) {
      print("Found conversation with ID: ${user1}_$user2");
      return Messagingbackend.fromMap(convSnapshot.data()!);
    }
    print("No conversation found for users: $user1 and $user2");
    return null;
  } catch (e) {
    print("Error in getConversation: $e");
    return null;
  }
}

/// Message object with the necessary information to process the object
class Message {
  const Message(this.sender, this.receiver, this.text);

  final String sender;
  final String receiver;
  final String text;

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(data['sender'], data['receiver'], data['text']);
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'text': text,
    };
  }
}
