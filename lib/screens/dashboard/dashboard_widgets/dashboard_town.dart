import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/dashboard/dashboard_widgets/fill_town_report_button.dart';
import 'package:ivs_maintenance_2/screens/dashboard/dashboard_widgets/town_basic_info.dart';
import 'package:ivs_maintenance_2/screens/dashboard/dashboard_widgets/town_details.dart';
import 'package:ivs_maintenance_2/screens/dashboard/dashboard_widgets/town_start_button.dart';

class DashboardTown extends StatefulWidget {
  const DashboardTown({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  _DashboardTownState createState() => _DashboardTownState();
}

class _DashboardTownState extends State<DashboardTown> {
  bool expanded = false;

  /* Makes town green if completed, yellow if in progress,
  light blue if not started. */
  Color? _getTownColor() {
    if (widget.town.completed) {
      return Colors.lightGreen[100];
    }
    if (widget.town.actualStartTime != null) {
      return Colors.yellowAccent[100];
    }
    return Colors.lightBlue[100];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 50.0,
      ),
      child: GestureDetector(
        onTap: () => setState(() => expanded = !expanded),
        child: Container(
          padding: EdgeInsets.all(15.0),
          /* Make color light green if already completed */
          decoration: BoxDecoration(
            color: _getTownColor(),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              /* Town basic info and Fill Out Report button*/
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TownBasicInfo(town: widget.town),
                    ),
                    /* Include details if expanded */
                    expanded
                        ? TownDetails(town: widget.town)
                        : SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TownStartButton(town: widget.town),
                        SizedBox(
                          width: 10.0,
                        ),
                        FillTownReportButton(town: widget.town),
                      ],
                    ),
                  ],
                ),
              ),
              /* Arrow to show it is expandable */
              Positioned(
                top: 10.0,
                right: 10.0,
                child: expanded
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
