import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/admin/town_tab/town_tab_widgets/admin_edit_town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/table_column_label.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class AllTowns extends StatefulWidget {
  const AllTowns({Key? key, this.allTowns}) : super(key: key);

  final List<Town>? allTowns;

  @override
  _AllTownsState createState() => _AllTownsState();
}

class _AllTownsState extends State<AllTowns> {
  bool _ascending = false;
  int _sortColumnIndex = 0;
  List<Town> towns = [];

  @override
  void initState() {
    towns = widget.allTowns ?? [];
    towns.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AllTowns oldWidget) {
    if (towns.toSet() != widget.allTowns?.toSet()) {
      towns = widget.allTowns ?? [];
      towns.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
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
      towns.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    } else if (_sortColumnIndex == 1) {
      towns.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortColumnIndex == 2) {
      towns.sort((a, b) => a.assignedTeam.compareTo(b.assignedTeam));
    } else {
      towns
          .sort((a, b) => a.numUnresolvedItems.compareTo(b.numUnresolvedItems));
    }
    if (!_ascending) {
      towns = towns.reversed.toList();
    }
  }

  /* OnTap for town report button */
  _openTownReport(Town town) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TownReport(
          town: town,
        ),
      ),
    );
  }

  /* OnTap for edit button */
  _editTown(Town town) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditTown(
          town: town,
        ),
      ),
    );
  }

  /* OnTap for delete button */
  _deleteTown(Town town) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Delete Town?'),
        content: Text('Are you sure you want to delete this town?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes')),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed) {
        try {
          TipDialogHelper.loading('Deleting Town');
          await Provider.of<DatabaseService>(context, listen: false)
              .deleteTown(town.id);
          TipDialogHelper.success('Town deleted');
        } catch (e) {
          TipDialogHelper.fail(e.toString());
        }
      }
    });
  }

  /* Helper function to set row green if all serviced, red if not serviced.
  Transparent if not done yet. */
  Color? _getRowColor(Town town) {
    if (!town.completed) {
      return Colors.transparent;
    }
    if (town.systemsServiced == town.numMachines) {
      return Colors.lightGreen[100];
    }
    return Colors.redAccent[100];
  }

  /* Helper function to get DataRow obj for DataTable */
  DataRow _getTownRow(Town town) {
    return DataRow(
      color: MaterialStateProperty.all(
        _getRowColor(town),
      ),
      cells: [
        DataCell(
            Text("${DateFormat.yMd().add_jm().format(town.scheduledTime)}")),
        DataCell(Text(town.name)),
        DataCell(Text(town.assignedTeam)),
        DataCell(Text("${town.systemsServiced}/${town.numMachines}")),
        DataCell(Center(child: Text("${town.numUnresolvedItems}"))),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(CupertinoIcons.doc_circle),
                onPressed: () => _openTownReport(town)),
            SizedBox(width: 5.0),
            IconButton(
                icon: Icon(CupertinoIcons.pencil_circle),
                onPressed: () => _editTown(town)),
            SizedBox(width: 5.0),
            IconButton(
                icon: Icon(CupertinoIcons.trash_circle),
                onPressed: () => _deleteTown(town)),
          ],
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('allTownsWidget: $towns');
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'All Towns',
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
                  columnTitle: 'Scheduled Time',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Name',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Team',
                ),
              ),
              DataColumn(
                label: TableColumnLabel(
                  columnTitle: 'Serviced',
                ),
              ),
              DataColumn(
                onSort: _onSort,
                label: TableColumnLabel(
                  columnTitle: 'Unresolved \n Issues',
                ),
              ),
              DataColumn(
                label: TableColumnLabel(
                  columnTitle: '',
                ),
              ),
            ],
            rows: towns.map((t) => _getTownRow(t)).toList(),
          ),
        ],
      ),
    );
  }
}
