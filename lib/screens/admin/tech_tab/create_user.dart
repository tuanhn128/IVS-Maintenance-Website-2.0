import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/widgets/changes_made_back_button.dart';
import 'package:ivs_maintenance_2/widgets/form_item_title.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/select_team_dropdown.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  String _name = "";
  String _team = "";
  String _password = "";
  bool _isAdmin = false;
  bool _changesMade = false;

  _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        TipDialogHelper.loading('Creating User');
        await Provider.of<AuthService>(context, listen: false)
            .createTech(_email, _name, _password, _team, _isAdmin);
        // TipDialogHelper.success('User Created');
        TipDialogHelper.dismiss();
        Navigator.of(context).pop();
      } catch (e) {
        TipDialogHelper.fail(e.toString());
      }
    }
  }

  /* Basic validator that checks field isn't null */
  String? _validate(String? s) {
    if (s == null || s.isEmpty) {
      return "Please enter a value";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            TitleWidget(
              title: 'Create User',
              leading: ChangesMadeBackButton(changesMade: _changesMade),
            ),
          ];
        },
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15.0,
              ),
              FormItemTitle(title: 'Email'),
              Container(
                width: 300.0,
                child: TextFormField(
                  onChanged: (email) {
                    setState(() {
                      _changesMade = true;
                      _email = email;
                    });
                  },
                  validator: _validate,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
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
              FormItemTitle(title: 'Password'),
              Container(
                width: 300.0,
                child: TextFormField(
                  onChanged: (password) {
                    setState(() {
                      _changesMade = true;
                      _password = password;
                    });
                  },
                  validator: _validate,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              FormItemTitle(title: 'Assigned Team'),
              Container(
                width: 300.0,
                child: SelectTeamDropdown(
                  onChanged: (team) {
                    setState(() {
                      _changesMade = true;
                      _team = team ?? "";
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
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
    );
  }
}
