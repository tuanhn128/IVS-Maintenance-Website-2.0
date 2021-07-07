import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/town_report_background_container.dart';
import 'package:ivs_maintenance_2/widgets/multi_line_text_field.dart';

import '../../../widgets/form_item_title.dart';

class NoteForm extends StatelessWidget {
  const NoteForm({Key? key, required this.town, required this.onChanged})
      : super(key: key);

  final Town town;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TownReportBackgroundContainer(
      width: 550.0,
      child: MultiLineTextField(
        title: 'Notes',
        initialValue: town.techNotes,
        onChanged: onChanged,
      ),
    );
  }
}
