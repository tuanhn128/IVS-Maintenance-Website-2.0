import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class TownStartButton extends StatelessWidget {
  const TownStartButton({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextButton(
      text: 'Mark Town as Started',
      onPressed: () async {
        if (town.actualStartTime != null) {
          TipDialogHelper.info('Town already marked as started earlier');
        } else {
          TipDialogHelper.loading('Marking town as started');
          if (await Provider.of<DatabaseService>(context, listen: false)
              .markTownAsStarted(townId: town.id)) {
            TipDialogHelper.success('${town.name} marked as started');
          } else {
            TipDialogHelper.fail('Error marking ${town.name} as started');
          }
        }
      },
    );
  }
}
