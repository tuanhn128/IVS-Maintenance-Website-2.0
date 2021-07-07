import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/town_report_background_container.dart';
import 'package:ivs_maintenance_2/widgets/number_text_field.dart';
import '../../../widgets/form_item_title.dart';

class SystemsServicedForm extends StatelessWidget {
  const SystemsServicedForm(
      {Key? key, required this.town, required this.onChanged})
      : super(key: key);

  final Town town;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TownReportBackgroundContainer(
      width: 300.0,
      child: Column(
        children: [
          /* Title with computer icon */
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 5.0,
                ),
                child: Icon(
                  CupertinoIcons.device_laptop,
                  size: 22.0,
                ),
              ),
              FormItemTitle(title: 'Systems Serviced'),
            ],
          ),
          SizedBox(
            height: 7.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Text field */
              Container(
                width: 50.0,
                height: 40.0,
                child: NumberTextField(
                  initialValue: town.systemsServiced,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(
                width: 3.0,
              ),
              /* Form suffix */
              Text(
                ' of ${town.numMachines}',
                style: TextStyle(
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
