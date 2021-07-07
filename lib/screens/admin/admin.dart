import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/tech.dart';
import 'package:ivs_maintenance_2/models/user_data.dart';
import 'package:ivs_maintenance_2/screens/admin/tech_tab/admin_tech_tab.dart';
import 'package:ivs_maintenance_2/screens/admin/town_tab/admin_town_tab.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tech>(
      future: Provider.of<DatabaseService>(context, listen: false).getTechById(
          Provider.of<UserData>(context, listen: false).currentTechId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasData && !snapshot.data!.admin) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Admin Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 36.0,
                ),
              ),
            ),
            body: Center(
              child: Text('You are not an admin :('),
            ),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Admin Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 36.0,
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Towns'),
                  Tab(text: 'Techs'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AdminTownTab(),
                AdminTechTab(),
              ],
            ),
          ),
        );
      },
    );
  }
}
