import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/models/tech.dart';

class DashboardGreeting extends StatelessWidget {
  DashboardGreeting(
      {Key? key, required this.tech, this.onNewDate, required this.currentDate})
      : super(key: key);

  final Tech tech;
  final dynamic Function(DateTime)? onNewDate;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hello, ${tech.name}!",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "${tech.team} Team",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          // SizedBox(
          //   height: 5.0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.calendar),
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    onConfirm: onNewDate,
                    currentTime: currentDate,
                  );
                },
              ),
              Text(
                DateFormat.yMMMMd('en_US').format(currentDate),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
