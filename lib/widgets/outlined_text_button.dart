import 'package:flutter/material.dart';

class OutlinedTextButton extends StatelessWidget {
  const OutlinedTextButton({Key? key, required this.text, this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              7.5,
            ),
            side: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
