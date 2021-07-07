import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/models/town_problem.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/town_report_background_container.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/table_column_label.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

import '../../../widgets/form_item_title.dart';
import 'new_problem_dialog.dart';

class ProblemsForm extends StatefulWidget {
  const ProblemsForm({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  _ProblemsFormState createState() => _ProblemsFormState();
}

class _ProblemsFormState extends State<ProblemsForm> {
  /* On tap function that opens new problem dialog */
  _addProblem() {
    showDialog(
      context: context,
      builder: (context) => NewProblemDialog(
        townId: widget.town.id,
      ),
    );
  }

  /* Helper function that creates a DataRow object for a given problem */
  DataRow _getProblemsTableRow(
      {required String townId,
      required TownProblem problem,
      required BuildContext context}) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            '${problem.itemName}',
          ),
        ),
        DataCell(
          Text(
            '${problem.replaced}',
          ),
        ),
        DataCell(
          Text('${problem.unresolved}'),
        ),
        DataCell(
          IconButton(
            onPressed: () async {
              TipDialogHelper.loading('Deleting Problem');
              if (await Provider.of<DatabaseService>(context, listen: false)
                  .removeProblemFromTown(
                      townId: townId, problemId: problem.id)) {
                TipDialogHelper.success('Deleted Problem');
              } else {
                TipDialogHelper.fail('Error deleting problem');
              }
            },
            icon: Icon(
              CupertinoIcons.trash,
              size: 22.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TownProblem>>(
      stream: Provider.of<DatabaseService>(context)
          .getTownProblemsStream(widget.town.id),
      builder: (context, snapshot) {
        List<TownProblem> problems = [];
        if (snapshot.hasData) {
          problems = snapshot.data ?? [];
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TownReportBackgroundContainer(
            width: 550.0,
            child: Column(
              children: [
                FormItemTitle(title: 'Problems Found'),
                DataTable(
                  /* Column Headers */
                  columns: [
                    DataColumn(
                      label: TableColumnLabel(
                        columnTitle: 'Item Name',
                      ),
                    ),
                    DataColumn(
                      label: TableColumnLabel(
                        columnTitle: 'Replaced',
                      ),
                    ),
                    DataColumn(
                      label: TableColumnLabel(
                        columnTitle: 'Unresolved',
                      ),
                    ),
                    DataColumn(
                      label: TableColumnLabel(
                        columnTitle: '',
                      ),
                    ),
                  ],
                  /* Rows */
                  rows: problems
                      .map((TownProblem prob) => _getProblemsTableRow(
                          townId: widget.town.id,
                          problem: prob,
                          context: context))
                      .toList(),
                ),
                /* Add Problem Button */
                IconButton(
                  icon: Icon(CupertinoIcons.plus_rectangle),
                  onPressed: _addProblem,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
