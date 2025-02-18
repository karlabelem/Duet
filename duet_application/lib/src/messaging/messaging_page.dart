import 'package:flutter/material.dart';
import 'conversation.dart'; 
import 'list_conversations.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key, required this.loggedInUser});

  final String loggedInUser;

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  bool _isDMListPage = true;
  String _otherUser = "";

  void _goToDMListPage() {
    setState(() {
      _isDMListPage = true;
    });
  }

  void _goToIndividualDMPage(String otherUser) {
    setState(() {
      _isDMListPage = false;
      _otherUser = otherUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isDMListPage ? ConversationList(loggedInUser: widget.loggedInUser, onConversationSelected: _goToIndividualDMPage,) : IndividualDMPage(senderId: widget.loggedInUser, receiverId: _otherUser, goBack: _goToDMListPage,),
    );
  }
}
