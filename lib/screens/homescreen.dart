import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/screens/settings_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? 'Journal Entries (${user.displayName})' : 'Journal Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.5,
                    child: SettingsScreen(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('entries')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> entries = snapshot.data!.docs;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return JournalEntryCard(
                title: entries[index]['title'],
                content: entries[index]['content'],
                documentId: entries[index].id,
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Entry'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/maps');
              break;
            case 2:
              context.push('/new-entry');
              break;
          }
        },
      ),
    );
  }
}

class JournalEntryCard extends StatelessWidget {
  final String title;
  final String content;
  final String documentId;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.content,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/entry/$documentId');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
