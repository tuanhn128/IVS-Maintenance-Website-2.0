import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:firebase/firebase.dart' as firebase;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";

  _submit() async {
    try {
      TipDialogHelper.loading('Logging in');
      await Provider.of<AuthService>(context, listen: false)
          .login(_email, _password);
      await firebase.auth(firebase.app()).onAuthStateChanged.first;
      TipDialogHelper.dismiss();
    } catch (e) {
      // print(e.toString());
      TipDialogHelper.dismiss();
      TipDialogHelper.fail(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [TitleWidget(title: 'IVS Maintenance Login')];
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300.0,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (email) {
                  _email = email;
                },
              ),
            ),
            Container(
              width: 300.0,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (password) {
                  _password = password;
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            OutlinedTextButton(
              text: 'Login',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
