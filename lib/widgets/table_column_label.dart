import 'package:flutter/material.dart';

class TableColumnLabel extends StatelessWidget {
  const TableColumnLabel({Key? key, required this.columnTitle})
      : super(key: key);

  final String columnTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      columnTitle,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
