import 'package:flutter/material.dart';
import 'package:beacon/widgets/location_button.dart';
import 'package:beacon/screens/maps_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beacon"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.pngkey.com%2Fpng%2Fdetail%2F129-1296419_cartoon-mountains-png-mountain-animation-png.png&f=1&nofb=1",
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LocationButton(
                  label: "Share Location",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MapScreen();
                        },
                      ),
                    );
                  },
                ),
                LocationButton(
                  label: "Get Location",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
