import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/dummy/dummy_data.dart';
import 'package:ivs_maintenance_2/helpers/helpers.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/admin/town_tab/town_tab_widgets/all_towns.dart';
import 'package:ivs_maintenance_2/screens/admin/town_tab/town_tab_widgets/in_progress.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'dart:html' as html;

class AdminTownTab extends StatefulWidget {
  const AdminTownTab({Key? key}) : super(key: key);

  @override
  _AdminTownTabState createState() => _AdminTownTabState();
}

class _AdminTownTabState extends State<AdminTownTab> {
  /* On pressed for Upload Town button */
  _uploadTown() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["csv"]);

    /* Show dialog that asks if they're sure*/
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Replace all towns?'),
        content: Text(
            'Are you sure you want to clean all town data and use this town csv?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Don't Replace")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Replace Town Data')),
        ],
      ),
    ).then((confirmed) async {
      /* If confirmed and result is valid, clear towns and read csv */
      if (confirmed && result != null) {
        TipDialogHelper.loading('Loading in new towns');
        try {
          /* Clear town */
          await Provider.of<DatabaseService>(context, listen: false)
              .clearAllTowns();
          /* Get csv string from file bytes */
          PlatformFile file = result.files.first;
          Uint8List? fileBytes = file.bytes;
          String csvString = String.fromCharCodes(fileBytes!);
          /* Convert to list of lists to represent each row in csv */
          List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);
          /* Iterate through list, creating newTownMap object, and add town */
          for (int i = 1; i < csvList.length; i++) {
            Map<String, dynamic> newTownMap = {};
            for (int j = 0; j < csvList[i].length; j++) {
              newTownMap[csvList[0][j]] = csvList[i][j];
            }
            DateTime scheduledTime =
                Helpers.getDateTime(newTownMap["Date"], newTownMap["Arrive"]);
            await Provider.of<DatabaseService>(context, listen: false).addTown(
              name: newTownMap["Town"],
              numMachines: newTownMap["Systems"],
              address: newTownMap["Address"],
              contacts: newTownMap["Contact"],
              parkingNotes: newTownMap["Parking"],
              buildingNotes: newTownMap["Enter Bldg"],
              phoneNumbers: newTownMap["Phone"],
              assignedTeam: newTownMap["Team"],
              scheduledTime: scheduledTime,
            );
          }
          TipDialogHelper.success('Towns uploaded');
        } catch (e) {
          print('Error uploading towns: ${e.toString()}');
          TipDialogHelper.fail(e.toString());
        }
      }
    });
  }

  _downloadTownData() async {
    TipDialogHelper.loading('Getting town timing data');
    try {
      /* Fetch towns and convert to list of dyanmic lists */
      List<Town> towns =
          await Provider.of<DatabaseService>(context, listen: false)
              .getAllTownsFuture();
      List<List<dynamic>> townListData = [Town.getHeaderTitles()];
      towns.forEach((element) {
        townListData.add(element.toDynamicList());
      });
      /* Convert list to a csv, then a url */
      String csv = ListToCsvConverter().convert(townListData);
      String content = base64Encode(csv.codeUnits);
      String url = "data:application/csv;base64,$content";
      /* Make html anchor element with url and click it (start download) */
      html.AnchorElement anchorElement = html.AnchorElement(href: url);
      anchorElement.download = url;
      anchorElement.click();
      TipDialogHelper.success('Downloaded!');
    } catch (e) {
      TipDialogHelper.fail(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Town>>(
        stream: Provider.of<DatabaseService>(context).getAllTownsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CupertinoActivityIndicator();
          }
          List<Town> allTowns = [];
          List<Town> inProgTowns = [];
          /* Set allTowns based on snapshot and filter inProgTowns */
          if (snapshot.hasData) {
            allTowns = snapshot.data ?? [];
          }
          // print('adminWidget: $allTowns');
          inProgTowns = allTowns
              .where((t) => t.actualStartTime != null && !t.completed)
              .toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                /* Button to upload a new Town CSV */
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedTextButton(
                        text: 'Upload Town CSV',
                        onPressed: _uploadTown,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      OutlinedTextButton(
                        text: 'Download Town Timing Data',
                        onPressed: _downloadTownData,
                      ),
                    ],
                  ),
                ),
                InProgress(
                  inProgressTowns: inProgTowns,
                ),
                SizedBox(
                  height: 30.0,
                ),
                AllTowns(
                  allTowns: allTowns,
                )
              ],
            ),
          );
        });
  }
}
