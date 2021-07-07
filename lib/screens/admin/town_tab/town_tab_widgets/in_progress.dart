import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/table_column_label.dart';
import 'package:provider/provider.dart';

class InProgress extends StatefulWidget {
  const InProgress({Key? key, this.inProgressTowns}) : super(key: key);

  final List<Town>? inProgressTowns;

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {
  bool _ascending = false;
  int _sortColumnIndex = 0;
  List<Town> towns = [];

  @override
  void initState() {
    towns = widget.inProgressTowns ?? [];
    towns.sort((a, b) => a.assignedTeam.compareTo(b.assignedTeam));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InProgress oldWidget) {
    if (towns.toSet() != widget.inProgressTowns?.toSet()) {
      towns = widget.inProgressTowns ?? [];
      towns.sort((a, b) => a.assignedTeam.compareTo(b.assignedTeam));
    }
    super.didUpdateWidget(oldWidget);
  }

  /* On sort function for columns */
  _onSort(int colIndex, bool ascending) {
    /* Updates colIndex and ascending correctly first */
    if (colIndex == _sortColumnIndex) {
      setState(() {
        _ascending = !_ascending; // just reverse ascending if same col
      });
    } else {
      setState(() {
        _sortColumnIndex = colIndex;
        _ascending = true;
      });
    }

    /* Actually sorts cols */
    if (_sortColumnIndex == 0) {
      towns.sort((a, b) => a.assignedTeam.compareTo(b.assignedTeam));
    } else if (_sortColumnIndex == 1) {
      towns.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortColumnIndex == 2) {
      towns.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    } else {
      towns.sort((a, b) {
        /* Make these additional time instances to work around null safety (we 
        know neither time will be null since they are currently in progress */
        DateTime aTime = a.actualStartTime ?? DateTime.now();
        DateTime bTime = b.actualStartTime ?? DateTime.now();
        return aTime.compareTo(bTime);
      });
    }
    if (!_ascending) {
      towns = towns.reversed.toList();
    }
  }

  /* Helper function to make DataRow object from town */
  DataRow _getTownRow(Town town) {
    DateTime actualStartTime = town.actualStartTime ?? DateTime.now();
    return DataRow(cells: [
      DataCell(Text(town.assignedTeam)),
      DataCell(Text(town.name)),
      DataCell(Text("${DateFormat.jm('en_US').format(town.scheduledTime)}")),
      DataCell(Text("${DateFormat.jm('en_US').format(actualStartTime)}")),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'In Progress',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          DataTable(
            sortAscending: _ascending,
            sortColumnIndex: _sortColumnIndex,
            columns: [
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Team',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Town Name',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Scheduled Start',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Actual Start',
                ),
              )
            ],
            rows: towns.map((t) => _getTownRow(t)).toList(),
          ),
        ],
      ),
    );
  }
}
