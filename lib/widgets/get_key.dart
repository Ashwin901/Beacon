import 'package:beacon/widgets/general_button.dart';
import 'package:beacon/widgets/get_location.dart';
import 'package:flutter/material.dart';
import 'package:beacon/services.dart';

class GetKey extends StatefulWidget {
  @override
  _GetKeyState createState() => _GetKeyState();
}

class _GetKeyState extends State<GetKey> {
  String key = "";
  dynamic loc = {};
  bool loading = false;

  void onPressed() async {
    if (key.length > 0) {
      setState(() {
        loading = !loading;
      });

      loc = await findKey(key);

      setState(() {
        loading = !loading;
      });
      if (loc == null) {
        print("Invalid key. Location no found");
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return GetLocation(value: key);
            },
          ),
        );
      }
    } else {
      print("Please enter the key");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) {
                      key = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the key",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  GeneralButton(label: "Submit", onPressed: onPressed)
                ],
              ),
            ),
    );
  }
}
