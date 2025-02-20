import 'package:duet_application/src/backend/userProfile.dart';
import 'package:flutter/material.dart';
import 'conversation.dart'; 
import 'list_conversations.dart';

class MessagingPage extends StatefulWidget {
  MessagingPage({super.key, required UserProfileData loggedInUser}): loggedInUserId = loggedInUser.uuid;

  final String loggedInUserId;

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
      body: _isDMListPage ? ConversationList(loggedInUser: widget.loggedInUserId, onConversationSelected: _goToIndividualDMPage,) : IndividualDMPage(senderId: widget.loggedInUserId, receiverId: _otherUser, goBack: _goToDMListPage,),
    );
  }
}
