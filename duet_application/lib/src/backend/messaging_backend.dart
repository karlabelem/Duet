import 'package:cloud_firestore/cloud_firestore.dart';

class Messagingbackend {
  /// the 2 users involved in this conversation
  final String uuid1, uuid2;

  /// list of messages between both users
  List<Message> conversation;

  /// unique conversation id composed of uuid1 appended with uuid2
  late final String cid;

  Messagingbackend(
      {required this.uuid1, required this.uuid2, List<Message>? conversation})
      : conversation = conversation ?? [],
        cid = uuid1 + uuid2;

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
    return Messagingbackend(
        uuid1: data['uuid1'],
        uuid2: data['uuid2'],
        conversation: data['conversation']);
  }

  /// Save this conversation to firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(cid)
        .set(toMap());
  }

  /// Get a conversation between 2 users from firestore
  Future<Messagingbackend?> getConversation(String user1, String user2) async {
    // There are 2 possible cid for this conversation: user1+user2 || user2+user1
    // attempt user1+user2
    var convRef =
        FirebaseFirestore.instance.collection('users').doc(user1 + user2);
    var convSnapshot = await convRef.get();
    if (convSnapshot.exists) {
      return Messagingbackend.fromMap(convSnapshot.data()!);
    }
    // attempt user2+user1
    convRef = FirebaseFirestore.instance.collection('users').doc(user2 + user1);
    convSnapshot = await convRef.get();
    if (convSnapshot.exists) {
      return Messagingbackend.fromMap(convSnapshot.data()!);
    }
    // the conversation doesn't exist, so return null
    return null;
  }

  /// Update firestore on backend side when a user sends a message
  /// Returns 0 if successful, 1 if not
  Future<int> sendMessage(Message msg) async {
    // get current conversation
    var convRef = FirebaseFirestore.instance.collection('users').doc(cid);

    // update conversation on firestore
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final sendTransaction = await transaction.get(convRef);
      if (!sendTransaction.exists) return 1;

      // add message to the conversation
      conversation.add(msg);

      // Update the conversation directly in Firestore
      transaction.update(convRef, {
        'conversation': conversation,
      });
    });
    return 0;
  }
}

/// Get a conversation between 2 users from firestore
  Future<Messagingbackend?> getConversation(String user1, String user2) async {
    // There are 2 possible cid for this conversation: user1+user2 || user2+user1
    // attempt user1+user2
    var convRef =
        FirebaseFirestore.instance.collection('users').doc(user1 + user2);
    var convSnapshot = await convRef.get();
    if (convSnapshot.exists) {
      return Messagingbackend.fromMap(convSnapshot.data()!);
    }
    // attempt user2+user1
    convRef = FirebaseFirestore.instance.collection('users').doc(user2 + user1);
    convSnapshot = await convRef.get();
    if (convSnapshot.exists) {
      return Messagingbackend.fromMap(convSnapshot.data()!);
    }
    // the conversation doesn't exist, so return null
    return null;
  }

/// Message object with the necessary information to process the object
class Message {
  const Message(this.sender, this.receiver, this.text);

  final String sender;
  final String receiver;
  final String text;
}
