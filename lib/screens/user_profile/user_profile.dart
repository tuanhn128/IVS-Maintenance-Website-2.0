import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/services/auth_service.dart';
import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          TitleWidget(title: 'User Profile'),
        ];
      },
      body: Center(
        child: OutlinedTextButton(
          text: 'Sign Out',
          onPressed: () {
            try {
              TipDialogHelper.loading('Signing Out');
              Provider.of<AuthService>(context, listen: false).signOut();
              TipDialogHelper.dismiss();
            } catch (e) {
              TipDialogHelper.fail('Sign out failed :(');
            }
          },
        ),
      ),
    );
  }
}
