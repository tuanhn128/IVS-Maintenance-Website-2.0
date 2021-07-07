import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/tech.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/widgets/changes_made_back_button.dart';
import 'package:ivs_maintenance_2/widgets/form_item_title.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/select_team_dropdown.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class AdminEditTech extends StatefulWidget {
  const AdminEditTech({Key? key, required this.tech}) : super(key: key);

  final Tech tech;

  @override
  _AdminEditTechState createState() => _AdminEditTechState();
}

class _AdminEditTechState extends State<AdminEditTech> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _team;
  late bool _isAdmin;
  bool _changesMade = false;

  @override
  void initState() {
    _name = widget.tech.name;
    _team = widget.tech.team;
    _isAdmin = widget.tech.admin;
    super.initState();
  }

  /* Basic validator that checks field isn't null */
  String? _validate(String? s) {
    if (s == null || s.isEmpty) {
      return "Please enter a value";
    }
    return null;
  }

  /* Submit button for editing tech */
  _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        TipDialogHelper.loading('Editng Tech');
        await Provider.of<AuthService>(context, listen: false)
            .editTech(widget.tech.id, _name, _team, _isAdmin);
        Navigator.of(context).pop();
      } catch (e) {
        TipDialogHelper.fail(e.toString());
      }
    }
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
              title: 'Admin Edit Tech',
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
                /* Name */
                FormItemTitle(title: 'Name'),
                Container(
                  width: 300.0,
                  child: TextFormField(
                    onChanged: (name) {
                      setState(() {
                        _changesMade = true;
                        _name = name;
                      });
                    },
                    validator: _validate,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                /* Team */
                FormItemTitle(title: 'Team'),
                Container(
                  width: 200.0,
                  child: SelectTeamDropdown(
                    onChanged: (String? team) {
                      setState(() {
                        _changesMade = true;
                        _team = team ?? "";
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormItemTitle(title: 'Admin?'),
                SizedBox(
                  height: 5.0,
                ),
                Checkbox(
                  value: _isAdmin,
                  onChanged: (bool? isChecked) {
                    setState(() {
                      _isAdmin = isChecked ?? _isAdmin;
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                OutlinedTextButton(
                  text: 'Submit',
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
