import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/tech.dart';
import 'package:ivs_maintenance_2/screens/admin/tech_tab/admin_edit_tech.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/table_column_label.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class TechsTable extends StatefulWidget {
  const TechsTable({Key? key}) : super(key: key);

  @override
  _TechsTableState createState() => _TechsTableState();
}

class _TechsTableState extends State<TechsTable> {
  /* Pushes edit tech page */
  _editTech(tech) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditTech(tech: tech),
      ),
    );
  }

/* Deletes tech */
  _deleteTech(tech) async {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Delete Tech?'),
        content: Text('Are you sure you want to delete this tech?'),
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
          TipDialogHelper.loading('Deleting Tech');
          await Provider.of<AuthService>(context, listen: false)
              .deleteTech(tech.id);
          TipDialogHelper.success('Tech deleted');
        } catch (e) {
          TipDialogHelper.fail(e.toString());
        }
      }
    });
  }

  /* Helper function to make DataRow object from tech */
  DataRow _getTechRow(Tech tech) {
    return DataRow(
      cells: [
        DataCell(Text(tech.name)),
        DataCell(Text(tech.email)),
        DataCell(Text(tech.team)),
        DataCell(tech.admin
            ? Center(child: Icon(CupertinoIcons.check_mark))
            : SizedBox.shrink()),
        DataCell(
          Row(
            children: [
              IconButton(
                  icon: Icon(CupertinoIcons.pencil_circle),
                  onPressed: () => _editTech(tech)),
              SizedBox(width: 5.0),
              IconButton(
                  icon: Icon(CupertinoIcons.trash_circle),
                  onPressed: () => _deleteTech(tech)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tech>>(
      stream: Provider.of<DatabaseService>(context, listen: false)
          .getAllTechsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        } else {
          List<Tech> techs = snapshot.data ?? [];
          return Column(
            children: [
              Text(
                'Techs',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(
                    label: TableColumnLabel(
                      columnTitle: 'Name',
                    ),
                  ),
                  DataColumn(
                    label: TableColumnLabel(
                      columnTitle: 'Email',
                    ),
                  ),
                  DataColumn(
                    label: TableColumnLabel(
                      columnTitle: 'Team',
                    ),
                  ),
                  DataColumn(
                    label: TableColumnLabel(
                      columnTitle: 'Admin',
                    ),
                  ),
                  DataColumn(
                    label: TableColumnLabel(
                      columnTitle: '',
                    ),
                  ),
                ],
                rows: techs.map((t) => _getTechRow(t)).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
