import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final String label;
  final onPressed;
  const GeneralButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xff1687a7)),
      ),
    );
  }
}
