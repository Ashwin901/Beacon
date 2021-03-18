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
  void _onMapCreated(GoogleMapController _mapController) async {
    _controller = _mapController;
    _location.onLocationChanged.listen((loc) async {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 20),
        ),
      );
      // await updateLiveLocation(loc);
    });
  }

  @override
  void initState() {
    _location = Location();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLocation(),
      builder: (context, loc) {
        if (loc.hasData) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(loc.data.latitude, loc.data.longitude),
                zoom: 19.151926040649414),
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
}
