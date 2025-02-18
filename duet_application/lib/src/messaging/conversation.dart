import 'dart:io';

import 'package:flutter/material.dart';
import '../backend/messaging_backend.dart';

/// Widget that displays the conversation between two users
class IndividualDMPage extends StatefulWidget {
  IndividualDMPage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.goBack,
  });

  final String senderId;
  final String receiverId;
  late Messagingbackend messages;
  final Function() goBack;

  @override
  State<IndividualDMPage> createState() => _IndividualDMPageState();
}

/// State for IndividualDMPage
class _IndividualDMPageState extends State<IndividualDMPage> {
  final typed = TextEditingController();
  late Future<Messagingbackend> _fetchMessages;


  @override
  void initState() {
    super.initState();
    // widget.messages = Messagingbackend(uuid1: widget.senderId, uuid2: widget.receiverId);
    _fetchMessages = getMessages();
  }

  /// gets conversation from firestore
  Future<Messagingbackend> getMessages() async {
    // get conversation if previous one exists
    Messagingbackend? msgs = await getConversation(widget.senderId, widget.receiverId);
    
    // create and save conversation if a new one is needed
    if(msgs == null) {
      // create new conversation
      msgs = Messagingbackend(uuid1: widget.senderId, uuid2: widget.receiverId);
      int exitCode = await msgs.saveToFirestore();
      if (exitCode != 0) {
        // ignore: avoid_print
        print("Error saving conversation to firestore");
      }
    }
    return msgs;
  }

  /// creates Message object and connects to firebase
  Future<void> sendMessage(String text) async {
    final msg = Message(widget.senderId, widget.receiverId, text);
    int exitCode = await widget.messages.sendMessage(msg);
    if (exitCode != 0) {
      // ignore: avoid_print
      print("Error sending message");
    }
    getMessages().then((response) {
      setState(() {
        widget.messages = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(
              widget.receiverId,
              style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFFD4ADFC),
              leading: BackButtonWidget(goBack: widget.goBack),
            ),
            body: FutureBuilder<Messagingbackend>(
                future: _fetchMessages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No conversation found.'));
                  } else {
                    widget.messages = snapshot.data!;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.messages.conversation.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index) {
                          return TextBubble(
                              msg: widget.messages.conversation[index],
                              sender: widget.senderId);
                        });
                  }
                }),
            bottomNavigationBar: Container(
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: typed,
                  decoration: InputDecoration(hintText: "Type message..."),
                  onSubmitted: (text) async {
                    await sendMessage(text);
                    typed.clear();
                  },
                )),
                SendButton(
                  send: () async {
                    await sendMessage(typed.text);
                    typed.clear();
                  },
                  typedText: typed,
                )
              ]),
            )));
  }
}

/// Displays a text bubble with the correct formatting based on who the sender of the message is
class TextBubble extends StatelessWidget {
  const TextBubble({super.key, required this.msg, required this.sender});

  /// Message object to display
  final Message msg;
  /// The user sending the message
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment:
            ((msg.sender == sender) ? Alignment.topRight : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ((msg.sender == sender)
                ? Color(0xFF5C469C)
                : Color(0xFFD4ADFC)),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            msg.text,
            style: TextStyle(
                fontSize: 15,
                color: ((msg.sender == sender) ? Colors.white : Colors.black)),
          ),
        ),
      ),
    );
  }
}

/// Widget representing the "send message" button
class SendButton extends StatelessWidget {
  SendButton({super.key, required this.send, required this.typedText});

  final Function() send;
  final TextEditingController typedText;
  final File icon = File("/assets/images/sendButtonIcon.png");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 48,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            send();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF5C469C)),
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.all(12), // Adjust padding to ensure proper centering
            ),
          ),
          child: Center(
              child: Icon(
            Icons.send,
            color: Colors.white,
          )),
        ));
  }
}

/// Widget representing the "back" button
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, required this.goBack});

  final Function() goBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 48,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            goBack();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF5C469C)),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(12), // Adjust padding to ensure proper centering
            ),
          ),
          child: Center(
              child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
        ));
  }
}