import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Location _location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future getLocation() async {
  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
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
  await addLocation();
  _locationData = await _location.getLocation();

  return _locationData;
}

Future<void> addLocation() async {
  await firebaseFirestore.collection('locations').add({
    "key": "123abc",
    "lat": _locationData.latitude,
    "long": _locationData.longitude
  });
}

Future findKey(String key) async {
  var data;
  await firebaseFirestore
      .collection('locations')
      .where("key", isEqualTo: key)
      .get()
      .then((value) => {
            if (value.docs.length > 0)
              {data = value.docs[0].data()}
            else
              {data = null}
          });

  return data;
}
