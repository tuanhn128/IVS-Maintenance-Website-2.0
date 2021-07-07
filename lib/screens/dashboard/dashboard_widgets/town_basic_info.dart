import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:tip_dialog/tip_dialog.dart';

/* Widget which contains icons and text representing the town name, the number
of machines, and the address. */
class TownBasicInfo extends StatelessWidget {
  const TownBasicInfo({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /* Town name and number of machines */
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "${town.name} - ",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 5.0,
              ),
              child: Icon(
                CupertinoIcons.device_laptop,
                size: 18.0,
              ),
            ),
            Text(
              "${town.numMachines}",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        /* Time */
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 5.0,
              ),
              child: Icon(
                CupertinoIcons.clock,
                size: 18.0,
              ),
            ),
            Text(
              "${DateFormat.jm('en_US').format(town.scheduledTime)}",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        /* Address */
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 5.0,
              ),
              child: Icon(
                CupertinoIcons.house,
                size: 18.0,
              ),
            ),
            Text(
              "${town.address.trim()}",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.5),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.doc_on_clipboard,
                  size: 18.0,
                ),
                onPressed: () {
                  FlutterClipboard.copy(town.address);
                  TipDialogHelper.success('Address copied!');
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
