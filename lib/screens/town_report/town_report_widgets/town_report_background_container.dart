import 'package:flutter/material.dart';

/* This is the background light blue bubble container that visually wraps each 
part of the town report */
class TownReportBackgroundContainer extends StatelessWidget {
  const TownReportBackgroundContainer(
      {Key? key, required this.child, required this.width})
      : super(key: key);

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.lightBlue[100],
      ),
      width: width,
      child: child,
    );
  }
}
