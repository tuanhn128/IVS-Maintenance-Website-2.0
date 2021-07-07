import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/dummy/dummy_data.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:tip_dialog/tip_dialog.dart';

class TownReportHome extends StatefulWidget {
  const TownReportHome({Key? key}) : super(key: key);

  @override
  _TownReportHomeState createState() => _TownReportHomeState();
}

class _TownReportHomeState extends State<TownReportHome> {
  Town? _selectedTown;

  _getDropdownItems(List<Town> towns) => towns
      .map(
        (t) => DropdownMenuItem(
          child: Text(t.name),
          value: t.name,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Town>>(
      future: Provider.of<DatabaseService>(context, listen: false)
          .getAllTownsFuture(),
      builder: (context, snapshot) {
        List<Town> towns = [];
        if (snapshot.hasData) {
          towns = snapshot.data ?? [];
        }
        List<DropdownMenuItem> items = _getDropdownItems(towns);
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              TitleWidget(title: 'Town Report Home'),
            ];
          },
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Searchable Dropdown Menu*/
              SearchableDropdown.single(
                items: items,
                hint: "Select Town",
                onChanged: (newTownName) {
                  setState(() {
                    List<Town> townsWithName =
                        towns.where((t) => t.name == newTownName).toList();
                    _selectedTown = townsWithName.first;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              /* Open Town Report Button */
              OutlinedTextButton(
                text: "Open Town Report",
                onPressed: () async {
                  if (_selectedTown == null) {
                    TipDialogHelper.info("Please select a town");
                  } else {
                    Town updatedTown = await Provider.of<DatabaseService>(
                            context,
                            listen: false)
                        .getTownById(_selectedTown!.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TownReport(
                          town: updatedTown,
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
