import 'package:flutter/material.dart';
import 'package:beacon/widgets/share_location.dart';

class MapScreen extends StatefulWidget {
  bool share;
  MapScreen({this.share});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.share ? ShareLocation() : Container(),
      ),
    );
  }
}
