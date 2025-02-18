import 'package:duet_application/src/backend/dm_list_backend.dart';
import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  ConversationList({super.key, required this.loggedInUser, required this.onConversationSelected});

  final String loggedInUser;
  late final DmListBackend conversations; // List of conversations
  final Function(String) onConversationSelected;

  @override
  State<ConversationList> createState() => _ConversationListState();
}

/// Widget that displays the list of conversations a user has
class _ConversationListState extends State<ConversationList> {
  late Future<void> _fetchConversations;

  @override
  void initState() {
    super.initState();
    widget.conversations = DmListBackend(uuid1: widget.loggedInUser);
    _fetchConversations = _initializeConversations();
  }

  /// Initialize the conversations from backend
  Future<void> _initializeConversations() async {
    await widget.conversations.getDocumentsWithUuidSubstring(widget.loggedInUser);
    await widget.conversations.saveToFirestore();
  }

  String extractOtherUser(String cid) {
    List<String> users = cid.split("_");
    if (users[0] == widget.loggedInUser) {
      return users[1];
    } else {
      return users[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4ADFC), // Background color
      body: FutureBuilder<void>(
        future: _fetchConversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Conversations",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5C469C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.conversations.conversations.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                        onTap: () {
                          widget.onConversationSelected(extractOtherUser(widget.conversations.conversations[index]));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                            ),
                          ],
                          ),
                          child: Text(
                          extractOtherUser(widget.conversations.conversations[index]),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF5C469C), // Text color
                          ),
                          ),
                        ),
                        );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
