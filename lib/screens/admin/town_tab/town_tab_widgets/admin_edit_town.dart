import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/changes_made_back_button.dart';
import 'package:ivs_maintenance_2/widgets/form_item_title.dart';
import 'package:ivs_maintenance_2/widgets/multi_line_text_field.dart';
import 'package:ivs_maintenance_2/widgets/number_text_field.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/select_team_dropdown.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class AdminEditTown extends StatefulWidget {
  const AdminEditTown({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  _AdminEditTownState createState() => _AdminEditTownState();
}

class _AdminEditTownState extends State<AdminEditTown> {
  final _formKey = GlobalKey<FormState>();
  late int _numMachines;
  late String _contacts;
  late String _address;
  late String _parkingNotes;
  late String _buildingNotes;
  late String _phoneNumbers;
  late DateTime _scheduledTime;
  late String _assignedTeam;
  bool _changesMade = false;

  @override
  void initState() {
    _numMachines = widget.town.numMachines;
    _contacts = widget.town.contacts;
    _address = widget.town.address;
    _parkingNotes = widget.town.parkingNotes;
    _buildingNotes = widget.town.buildingNotes;
    _phoneNumbers = widget.town.phoneNumbers;
    _scheduledTime = widget.town.scheduledTime;
    _assignedTeam = widget.town.assignedTeam;
    super.initState();
  }

  _submit() async {
    TipDialogHelper.loading('Saving Town Edits');
    if (await Provider.of<DatabaseService>(context, listen: false)
        .submitAdminEditTown(
            townId: widget.town.id,
            numMachines: _numMachines,
            contacts: _contacts,
            address: _address,
            parkingNotes: _parkingNotes,
            buildingNotes: _buildingNotes,
            phoneNumbers: _phoneNumbers,
            scheduledTime: _scheduledTime,
            assignedTeam: _assignedTeam)) {
      TipDialogHelper.success('Town Report Saved!');
    } else {
      TipDialogHelper.success('Town Report Save Failed :(');
    }
    setState(() {
      _changesMade = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            /* Title bar with back button that checks if changes have
            been made and confirms they want to leave. */
            TitleWidget(
              title: 'Admin Edit Town',
              leading: ChangesMadeBackButton(
                changesMade: _changesMade,
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    widget.town.name,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                /* Num Machines */
                FormItemTitle(title: '# of Machines'),
                Container(
                  width: 50.0,
                  height: 40.0,
                  child: NumberTextField(
                    initialValue: widget.town.numMachines,
                    onChanged: (String? numMachines) {
                      setState(() {
                        _changesMade = true;
                        _numMachines = int.parse(
                            numMachines ?? widget.town.numMachines.toString());
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Assigned Team */
                FormItemTitle(title: 'Assigned Team'),
                Container(
                  width: 200.0,
                  child: SelectTeamDropdown(
                    onChanged: (String? team) {
                      setState(() {
                        _changesMade = true;
                        _assignedTeam = team ?? "";
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Scheduled Time  */
                FormItemTitle(title: 'Scheduled Time'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "${DateFormat.yMd().add_jm().format(_scheduledTime)}",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                OutlinedTextButton(
                  text: 'Pick Time',
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (newTime) {
                        setState(() {
                          _changesMade = true;
                          _scheduledTime = newTime;
                        });
                      },
                      currentTime: _scheduledTime,
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                /* Contacts */
                MultiLineTextField(
                  title: 'Contacts',
                  initialValue: widget.town.contacts,
                  onChanged: (contacts) {
                    setState(() {
                      _changesMade = true;
                      _contacts = contacts ?? _contacts;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Address */
                MultiLineTextField(
                  title: 'Address',
                  initialValue: widget.town.address,
                  onChanged: (address) {
                    setState(() {
                      _changesMade = true;
                      _address = address ?? _address;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Parking Notes */
                MultiLineTextField(
                  title: 'Parking Notes',
                  initialValue: widget.town.parkingNotes,
                  onChanged: (parkingNotes) {
                    setState(() {
                      _changesMade = true;
                      _parkingNotes = parkingNotes ?? _parkingNotes;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Building Notes */
                MultiLineTextField(
                  title: 'Building Notes',
                  initialValue: widget.town.buildingNotes,
                  onChanged: (buildingNotes) {
                    setState(() {
                      _changesMade = true;
                      _buildingNotes = buildingNotes ?? _buildingNotes;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                /* Phone Numbers */
                MultiLineTextField(
                  title: 'Phone Numbers',
                  initialValue: widget.town.phoneNumbers,
                  onChanged: (phoneNumbers) {
                    setState(() {
                      _changesMade = true;
                      _phoneNumbers = phoneNumbers ?? _phoneNumbers;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                OutlinedTextButton(
                  text: 'Save Town',
                  onPressed: _submit,
                ),
                SizedBox(
                  height: 15.0,
                ), // Padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
