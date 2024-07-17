import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/location_picker_widget.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  LatLng? _selectedLocation;
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _selectLocation() async {
    LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
    }
  }

  Future<void> _saveEntry() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        String? imageURL;
        if (_imageFile != null) {
          File file = File(_imageFile!.path);
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('entry_images/$uid/$fileName');
          UploadTask uploadTask = storageRef.putFile(file);

          TaskSnapshot snapshot = await uploadTask;
          imageURL = await snapshot.ref.getDownloadURL();

          print('Image URL: $imageURL');
        }

        Map<String, dynamic> entryData = {
          'userId': uid,
          'title': _titleController.text,
          'content': _contentController.text,
          'location': _selectedLocation != null
              ? GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude)
              : null,
          'timestamp': Timestamp.now(),
          'imageURL': imageURL,
        };

        await FirebaseFirestore.instance.collection('entries').add(entryData);

        _titleController.clear();
        _contentController.clear();
        setState(() {
          _imageFile = null;
          _selectedLocation = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save entry: $e')),
        );
        print('Error saving entry: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Journal Entry'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Content',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    if (_selectedLocation != null)
                      Text(
                        'Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Add Image'),
                        ),
                        IconButton(
                          onPressed: _selectLocation,
                          icon: const Icon(Icons.place),
                          tooltip: 'Select Location',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    if (_imageFile != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(_imageFile!.path),
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: _removeImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Remove Image', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _saveEntry,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Save Entry',style: TextStyle(color: Colors.white),
),
                      
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Entry'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.push('/');
        break;
      case 1:
        context.push('/maps');
        break;
      case 2:
        context.push('/new-entry');
        break;
    }
  }
}
