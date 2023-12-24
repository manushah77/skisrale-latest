import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  final double? lat;
  final double? long;

  CustomGoogleMap({this.lat, this.long});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? controller;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat!, widget.long!),
                zoom: 15,
              ),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  this.controller = controller;
                  _addMarker(); // Call the function to add a marker
                });
              },
              myLocationEnabled: false,
              mapToolbarEnabled: true,
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }

  // Function to add a marker
  void _addMarker() {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('CustomMarker'),
          position: LatLng(widget.lat!, widget.long!),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });
  }
}
