import 'dart:async';
import 'package:flutter/material.dart';
import 'package:beacon/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ShareLocation extends StatefulWidget {
  @override
  _ShareLocationState createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  Location _location;
  GoogleMapController _controller;
  String docId = "";

  void _onMapCreated(GoogleMapController _mapController) async {
    _controller = _mapController;
    _location.onLocationChanged.listen((loc) async {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 20),
        ),
      );
      await updateLiveLocation(loc, docId);
    });
  }

  void deleteLoc(BuildContext context) async {
    await deleteLocation(docId);
    Navigator.pop(context);
  }

  void setDocId(String key) {
    docId = key;
  }

  @override
  void initState() {
    _location = Location();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(hours: 3), () {
      deleteLoc(context);
    });
    return FutureBuilder(
      future: getLocation(),
      builder: (context, loc) {
        if (loc.hasData) {
          setDocId(loc.data["key"]);
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(loc.data["locationData"].latitude,
                    loc.data["locationData"].longitude),
                zoom: 14),
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
