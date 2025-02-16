import 'package:flutter/material.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage(
      {super.key, required this.senderId, required this.receiverId});

  final String senderId;
  final String receiverId;

  @override
  State<MessagingPage> createState() => _MessaginPageState();
}

class _MessaginPageState extends State<MessagingPage> {
  final typed = TextEditingController();
  late List<Message> messages;
  @override
  void initState() {
    super.initState();
    messages = [
      Message(widget.senderId, widget.receiverId, "wassup gang"),
      Message(widget.receiverId, widget.senderId, "yo how u doing"),
      Message(widget.senderId, widget.receiverId, "been chillin fsfs"),
      Message(widget.receiverId, widget.senderId, "fye"),
      Message(widget.senderId, widget.receiverId, "this is random text"),
      Message(widget.receiverId, widget.senderId,
          "just testing some stuff for sure"),
      Message(widget.senderId, widget.receiverId, "short"),
      Message(widget.receiverId, widget.senderId,
          "boutta be a long message: kfbjshdbfhsdbfhabdfhbadfhbajhdbfakhjkfbcakjdb")
    ];
  }

  void sendMessage(String text) {
    List<Message> newMessages = messages.sublist(0);
    setState(() {
      messages = newMessages;
    });
    print("message sent");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverId)),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            Message m = messages[index];
            if (m.sender == widget.senderId) {
              return Container(
                  alignment: Alignment.center,
                  color: Color(0xFF5C469C),
                  padding: const EdgeInsets.all(8.0),
                  transformAlignment: Alignment.topRight,
                  width: 5,
                  child:
                      Row(children: <Widget>[Flexible(child: Text(m.text))]));
            }
            return TextBubble(isSent: m.sender == widget.senderId, msg: m.text);
          }),
      bottomNavigationBar: TextField(
        controller: typed,
        decoration: InputDecoration(hintText: "Type message..."),
        onSubmitted: (text) {
          sendMessage(text);
          typed.clear();
        },
      ),
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
  const TextBubble({super.key, required this.isSent, required this.msg});

  final bool isSent;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 167,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: (!isSent) ? Color(0xFFD4ADFC) : Color(0xFF5C469C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg,
                style: TextStyle(
                  color: (isSent) ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontFamily: 'GDS Transport Website',
                  fontWeight: FontWeight.w300,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
