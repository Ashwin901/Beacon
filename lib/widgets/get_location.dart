import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class GetLocation extends StatefulWidget {
  final String value;
  GetLocation({this.value});
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GoogleMapController _controller;
  double latitude, longitude;
  Location location = Location();

  void _onMapCreated(GoogleMapController _mapController) async {
    _controller = _mapController;
    DocumentReference locData =
        firebaseFirestore.collection('locations').doc(widget.value);

    locData.snapshots().listen((loc) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(loc.data()["lat"], loc.data()["long"]), zoom: 20),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseFirestore
            .collection('locations')
            .doc(widget.value)
            .snapshots(),
        builder: (context, loc) {
          if (loc.hasData) {
            latitude = loc.data["lat"];
            longitude = loc.data["long"];
            return GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 20),
                onMapCreated: _onMapCreated);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
