import 'package:flutter/material.dart';

class FormItemTitle extends StatelessWidget {
  const FormItemTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
