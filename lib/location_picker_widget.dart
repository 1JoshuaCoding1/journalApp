import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class LocationPickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: LocationPicker(
        onLocationSelected: (location) {
          Navigator.pop(context, location); 
        },
      ),
    );
  }
}

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const LocationPicker({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onTap: (LatLng latLng) {
            setState(() {
              _selectedLocation = latLng;
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(10.3157, 123.8854), // Initial map position (Cebu City)
            zoom: 12,
          ),
          markers: _selectedLocation != null
              ? {
                  Marker(
                    markerId: MarkerId('selected-location'),
                    position: _selectedLocation!,
                    infoWindow: InfoWindow(title: 'Selected Location'),
                  ),
                }
              : {},
        ),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_selectedLocation != null) {
                    widget.onLocationSelected(_selectedLocation!);
                  }
                },
                child: Text('Confirm Location'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
