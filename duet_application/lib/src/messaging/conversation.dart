import 'package:flutter/material.dart';

class MessagingPage extends StatefulWidget {
  MessagingPage(
      {super.key, required this.senderId, required this.receiverId, this.messages});

  final String senderId;
  final String receiverId;
  late List<Message> ?messages;

  @override
  State<MessagingPage> createState() => _MessaginPageState();
}

class _MessaginPageState extends State<MessagingPage> {

  final typed = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.messages ??= [
      Message(widget.senderId, widget.receiverId, "message 1"),
      Message(widget.receiverId, widget.senderId, "message 2"),
      Message(widget.senderId, widget.receiverId, "message 3"),
      Message(widget.senderId, widget.receiverId, "message 4"),
      Message(widget.receiverId, widget.senderId, "message 5"),
      Message(widget.receiverId, widget.senderId, "message 6"),
      Message(widget.senderId, widget.receiverId, "message 7"),
    ];
  }

  void sendMessage(String text) {
    List<Message> newMessages = widget.messages!.sublist(0);
    newMessages.add(Message(widget.senderId, widget.receiverId, text));
    setState(() {
      widget.messages = newMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverId)),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.messages!.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return TextBubble(msg: widget.messages![index], sender: widget.senderId);
          }),
      bottomNavigationBar: Row(children: <Widget>[
        Expanded(
            child: TextField(
          controller: typed,
          decoration: InputDecoration(hintText: "Type message..."),
          onSubmitted: (text) {
            sendMessage(text);
            typed.clear();
          },
        ))
      ]),
    );
  }
}

class Message {
  const Message(this.sender, this.receiver, this.text);

  final String sender;
  final String receiver;
  final String text;
}

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
