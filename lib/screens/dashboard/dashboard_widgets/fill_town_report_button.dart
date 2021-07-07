import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:provider/provider.dart';

class FillTownReportButton extends StatelessWidget {
  const FillTownReportButton({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextButton(
      onPressed: () async {
        // Town updatedTown =
        //     await Provider.of<DatabaseService>(context, listen: false)
        //         .getTownById(town.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TownReport(
              town: town,
            ),
          ),
        );
      },
      text: "Fill Town Report",
    );
  }
}
