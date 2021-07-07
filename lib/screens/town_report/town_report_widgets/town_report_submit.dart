import 'package:flutter/material.dart';

class TownReportSubmit extends StatelessWidget {
  const TownReportSubmit({Key? key, required this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Submit',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            side: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.all(15.0),
        ),
      ),
    );
  }
}
