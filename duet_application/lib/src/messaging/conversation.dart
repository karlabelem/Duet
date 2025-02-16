import 'dart:io';

import 'package:flutter/material.dart';
import '../backend/messaging_backend.dart';

/// Widget that displays teh conversation between two users
class MessagingPage extends StatefulWidget {
  MessagingPage({
    super.key,
    required this.senderId,
    required this.receiverId,
  });

  final String senderId;
  final String receiverId;
  late final Messagingbackend messages;

  @override
  State<MessagingPage> createState() => _MessaginPageState();
}

/// State for MessagingPage
class _MessaginPageState extends State<MessagingPage> {
  final typed = TextEditingController();

  @override
  void initState() {
    print("initializing");
    super.initState();
    print("fetching messages");
    widget.messages = Messagingbackend(uuid1: widget.senderId, uuid2: widget.receiverId);
    getMessages().then((response) {
      print(response);
      widget.messages = response;
    });
  }

  Future<Messagingbackend> getMessages() async {
    // get conversation if previous one exists
    final msgs = await getConversation(widget.senderId, widget.receiverId) ?? Messagingbackend(uuid1: widget.senderId, uuid2: widget.receiverId);
    // save conversation in case a new one was created
    await widget.messages.saveToFirestore();
    return msgs;
  }

  /// creates Message object and connects to firebase
  void sendMessage(String text) async {
    final msg = Message(widget.senderId, widget.receiverId, text);
    await widget.messages.sendMessage(msg);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text(widget.receiverId)),
            body: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.messages.conversation.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return TextBubble(
                      msg: widget.messages.conversation[index], sender: widget.senderId);
                }),
            bottomNavigationBar: Container(
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: typed,
                  decoration: InputDecoration(hintText: "Type message..."),
                  onSubmitted: (text) {
                    sendMessage(text);
                  },
                )),
                SendButton(
                  send: sendMessage,
                  typedText: typed,
                )
              ]),
            )));
  }
}

/// Displays a text bubble with the correct formatting based on who the sender of the message is
class TextBubble extends StatelessWidget {
  const TextBubble({super.key, required this.msg, required this.sender});

  final Message msg;
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

  final Function(String) send;
  final TextEditingController typedText;
  final File icon = File("/assets/images/sendButtonIcon.png");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 48,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            send(typedText.text);
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
