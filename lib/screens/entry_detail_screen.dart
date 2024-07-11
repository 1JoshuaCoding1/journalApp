import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class EntryDetailScreen extends StatefulWidget {
  final String documentId;

  const EntryDetailScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? imageURL;
  DateTime? timestamp;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    FirebaseFirestore.instance.collection('entries').doc(widget.documentId).get().then((snapshot) {
      var entryData = snapshot.data() as Map<String, dynamic>;
      _titleController.text = entryData['title'];
      _contentController.text = entryData['content'];
      setState(() {
        imageURL = entryData['imageURL'];
        timestamp = (entryData['timestamp'] as Timestamp).toDate();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateEntry() {
    FirebaseFirestore.instance.collection('entries').doc(widget.documentId).update({
      'title': _titleController.text,
      'content': _contentController.text,
    }).then((_) {
      context.pop();
    });
  }

  void _deleteEntry() {
    FirebaseFirestore.instance.collection('entries').doc(widget.documentId).delete().then((_) {
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Details'),
      ),
      body: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (timestamp != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Created on: ${DateFormat('yyyy-MM-dd – kk:mm').format(timestamp!)}',
                      style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
                    ),
                  ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                if (imageURL != null)
                  Image.network(
                    imageURL!,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _updateEntry,
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: _deleteEntry,
                      child: const Text('Delete'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
