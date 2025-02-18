import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'src/algo/user.dart';
import 'src/algo/matching.dart';

class MatchScreen extends StatefulWidget {
  final String userId;
  const MatchScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<List<Map<String, dynamic>>> matchesFuture;

  @override
  void initState() {
    super.initState();
    matchesFuture = fetchAndMatchUsers(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Best Matches")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No matches found."));
          }

          // Display Matches
          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final user = match['user'] as User;
              final score = match['score'] as double;

              return ListTile(
                title: Text("User ${user.id}"),
                subtitle: Text("Match Score: ${score.toStringAsFixed(2)}"),
              );
            },
          );
        },
      ),
    );
  }
}
