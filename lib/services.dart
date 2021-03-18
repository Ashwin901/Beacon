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
  String docId = await addLocation();
  Map locationInfo = {"locationData": _locationData, "key": docId};
  return locationInfo;
}

Future<String> addLocation() async {
  int counter = await getCounter();
  String docId = "";
  if (counter != null) {
    docId = 'abc$counter';
    try {
      await firebaseFirestore.collection('locations').doc(docId).set({
        "key": 'abc$counter',
        "lat": _locationData.latitude,
        "long": _locationData.longitude
      });
      counter++;
      await setCounter(counter);
    } catch (e) {
      print(e.message);
    }
  } else {
    print("Counter error");
  }
  return docId;
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

Future<int> getCounter() async {
  int counter = 0;
  dynamic data;
  try {
    await firebaseFirestore.collection('counter').doc('count').get().then(
          (value) => {
            if (value.exists)
              {data = value.data(), counter = data["counterValue"]}
            else
              {
                counter = null,
              }
          },
        );
  } catch (e) {
    print(e.message);
  }
  return counter;
}

Future<void> setCounter(int counter) async {
  try {
    await firebaseFirestore.collection('counter').doc('count').update(
      {"counterValue": counter},
    );
  } catch (e) {
    print(e.message);
  }
}

Future<void> updateLiveLocation(LocationData data, String key) async {
  try {
    await firebaseFirestore
        .collection('locations')
        .doc(key)
        .update({"lat": data.latitude, "long": data.longitude});
  } catch (e) {
    print(e.message);
  }
}

Future<void> deleteLocation(String key) async {
  try {
    await firebaseFirestore.collection('locations').doc(key).delete();
  } catch (e) {
    print(e.message);
  }
}

void showToast(BuildContext context, String message) {
  Toast.show(message, context, duration: 5, gravity: Toast.BOTTOM);
}
