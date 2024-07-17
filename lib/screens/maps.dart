import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'entry_detail_screen.dart'; 

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(10.3157, 123.8854);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _fetchLocations() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('entries')
            .where('userId', isEqualTo: userId)
            .get();

        Set<Marker> markers = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          GeoPoint? location = data['location'] as GeoPoint?;
          if (location != null) {
            return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(title: data['title'] ?? 'No Title'),
              onTap: () {
                _showMarkerDialog(doc.id, data['title'] ?? 'No Title');
              },
            );
          }
          return Marker(markerId: MarkerId('null_marker'));
        }).toSet();

        setState(() {
          _markers = markers;
        });
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  void _showMarkerDialog(String documentId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Navigate to Entry'),
          content: Text('Do you want to view details for "$title"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToEntryDetailScreen(documentId);
              },
              child: Text('View Details'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEntryDetailScreen(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryDetailScreen(documentId: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
