import 'package:beacon/services.dart';
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
  Set<Marker> _markers = Set<Marker>();
  int counter = 0;
  double latitude, longitude;
  Location location = Location();

  void _onMapCreated(GoogleMapController _mapController) async {
    _controller = _mapController;
    DocumentReference locData =
        firebaseFirestore.collection('locations').doc(widget.value);

    //Add initial marker
    var data = await findKey(widget.value);
    _addMarkers(
      LatLng(
        data["lat"],
        data["long"],
      ),
    );
    locData.snapshots().listen((loc) {
      if (loc.exists) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(loc.data()["lat"], loc.data()["long"]),
                zoom: 20),
          ),
        );
        //When location changes we have to update the markers also
        _addMarkers(
          LatLng(
            loc.data()["lat"],
            loc.data()["long"],
          ),
        );
      }
    });
  }

  void _addMarkers(LatLng point) {
    _markers.clear();
    final String markerId = "markerId_$counter";
    counter++;
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId(markerId), position: point),
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
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: LatLng(latitude, longitude), zoom: 14),
              onMapCreated: _onMapCreated,
              markers: _markers,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
