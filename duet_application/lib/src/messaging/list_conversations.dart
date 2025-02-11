import 'package:flutter/material.dart';

class ConversationList extends StatelessWidget {
  ConversationList({super.key});

  final List<String> conversations = ["user 1", "user 2", "user 3", "user 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: conversations.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return Text(conversations[index]);
                })
          ],
        ),
      ),
    );
  }
}
