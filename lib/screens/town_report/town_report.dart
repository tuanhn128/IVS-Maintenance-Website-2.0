import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivs_maintenance_2/dummy/dummy_data.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/note_form.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/problems_form.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/systems_serviced_form.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_widgets/town_report_submit.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/changes_made_back_button.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class TownReport extends StatefulWidget {
  const TownReport({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  _TownReportState createState() => _TownReportState();
}

class _TownReportState extends State<TownReport> {
  final _formKey = GlobalKey<FormState>();
  late int _systemsServiced;
  late String _notes;
  late bool _changesMade;
  late DateTime? _finishTime;

  @override
  void initState() {
    _systemsServiced = widget.town.systemsServiced;
    _notes = widget.town.techNotes;
    _changesMade = false;
    _finishTime = widget.town.finishTime;
    super.initState();
  }

  _submit() async {
    /* Submit town report, and show success dialog if successful, error
    dialog if failure (we don't need to submit problems because that is
    handled separately by the problems from widget) */
    TipDialogHelper.loading('Saving Town Report');
    DateTime finishTime = DateTime.now();
    if (await Provider.of<DatabaseService>(context, listen: false)
        .submitTownReport(
            widget.town.id, _systemsServiced, _notes, finishTime)) {
      TipDialogHelper.success('Town Report Saved!');
      setState(() {
        _finishTime = finishTime;
      });
    } else {
      TipDialogHelper.fail('Town Report Save Failed :(');
    }
    setState(() {
      _changesMade = false;
    });
  }

  String _getStartTime() {
    if (widget.town.actualStartTime == null) {
      return "Not marked as started yet";
    }
    return DateFormat.yMd().add_jm().format(widget.town.actualStartTime!);
  }

  String _getCompletedTime() {
    if (_finishTime == null) {
      return "";
    }
    return DateFormat.yMd().add_jm().format(_finishTime!);
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
              title: 'Town Report',
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
                  padding: EdgeInsets.only(
                    top: 10.0,
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
                /* Start and finish time */
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Started: ${_getStartTime()} - Completed: ${_getCompletedTime()}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                /* Systems Serviced Form (we pass onChanged as an argument so that
                we can update our private variable on this widget) */
                SystemsServicedForm(
                  town: widget.town,
                  onChanged: (String? systemsServiced) {
                    setState(() {
                      _changesMade = true;
                      if (systemsServiced != null && systemsServiced != "") {
                        _systemsServiced = int.parse(systemsServiced);
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                /* Problems Form */
                ProblemsForm(
                  town: widget.town,
                ),
                SizedBox(
                  height: 16.0,
                ),
                /* Note Form */
                NoteForm(
                  town: widget.town,
                  onChanged: (String? notes) {
                    setState(() {
                      _changesMade = true;
                      _notes = notes ?? '';
                    });
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                /* Submit Button */
                TownReportSubmit(
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
