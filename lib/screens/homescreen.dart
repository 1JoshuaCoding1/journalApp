import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample journal entries (replace with your data source)
  final List<String> entries = [
    'Mic test',
    'Entry 2 - Apoador Sunset',
    'Another journal entry',
    'This is a longer entry with more content',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://picsum.photos/id/2379/200/300', // Replace with your profile image URL
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return JournalEntryCard(title: entries[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Entry'),
        ],
        currentIndex: 0, // Set the initial selected index
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          // Handle bottom navigation bar item tap
        },
      ),
    );
  }
}

class JournalEntryCard extends StatelessWidget {
  final String title;

  const JournalEntryCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
