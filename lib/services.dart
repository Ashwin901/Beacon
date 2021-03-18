import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

Location _location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future getLocation() async {
  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    print('no service');
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) {
      print("Services denied. Please try again");
      return;
    }
  }
  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      print("No permission");
      return;
    }
  }
  _locationData = await _location.getLocation();
  await addLocation();
  return _locationData;
}

Future<void> addLocation() async {
  try {
    await firebaseFirestore.collection('locations').doc('123abc').set({
      "key": "123abc",
      "lat": _locationData.latitude,
      "long": _locationData.longitude
    });
  } catch (e) {
    print(e.message);
  }
}

Future findKey(String key) async {
  var data;
  await firebaseFirestore
      .collection('locations')
      .doc(key)
      .get()
      .then((value) => {
            if (value.exists) {data = value.data()} else {data = null}
          });
  return data;
}

Future<void> updateLiveLocation(LocationData data) async {
  try {
    await firebaseFirestore
        .collection('locations')
        .doc('123abc')
        .update({"lat": data.latitude, "long": data.longitude});
  } catch (e) {
    print(e.message);
  }
}

Future<void> deleteLocation(String key) async {
  try {
    await firebaseFirestore.collection('locations').doc('123abc').delete();
  } catch (e) {
    print(e.message);
  }
}

void showToast(BuildContext context, String message) {
  Toast.show(message, context, duration: 5, gravity: Toast.BOTTOM);
}
