import 'dart:async';
import 'package:beacon/widgets/general_button.dart';
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
    var nav = Navigator.of(context);
    nav.pop();
    nav.pop();
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
    Timer(Duration(minutes: 20), () {
      deleteLoc(context);
    });
    return WillPopScope(
        child: FutureBuilder(
          future: getLocation(),
          builder: (context, loc) {
            if (loc.hasData) {
              setDocId(loc.data["key"]);
              return Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(loc.data["locationData"].latitude,
                            loc.data["locationData"].longitude),
                        zoom: 14),
                    onMapCreated: _onMapCreated,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black),
                      height: 50,
                      width: 200,
                      child: Text(
                        "Key: $docId",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    bottom: 10,
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        onWillPop: () {
          return _onWillPop(context);
        });
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
            ),
            content: Text(
              'Do you want to stop sharing your location?',
            ),
            actions: <Widget>[
              GeneralButton(
                label: "No",
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              GeneralButton(
                label: "Yes",
                onPressed: () {
                  deleteLoc(context);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
