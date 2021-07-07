import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/screens/admin/admin.dart';
import 'package:ivs_maintenance_2/screens/dashboard/dashboard.dart';
import 'package:ivs_maintenance_2/screens/town_report/town_report_home.dart';
import 'package:ivs_maintenance_2/screens/user_profile/user_profile.dart';
import 'package:tip_dialog/tip_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currScreenIndex = 0;
  final DashboardScreen dashboardScreen = DashboardScreen();
  final AdminScreen adminScreen = AdminScreen();
  final TownReportHome townReportScreen = TownReportHome();
  final UserProfile userProfileScreen = UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currScreenIndex == 0
                ? CupertinoIcons.house_fill
                : CupertinoIcons.house),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currScreenIndex == 1
                ? CupertinoIcons.doc_chart_fill
                : CupertinoIcons.doc_chart),
            label: 'Town Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currScreenIndex == 2
                ? CupertinoIcons.book_fill
                : CupertinoIcons.book),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currScreenIndex == 3
                ? CupertinoIcons.person_fill
                : CupertinoIcons.person),
            label: 'User Profile',
          ),
        ],
        currentIndex: _currScreenIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(),
        onTap: (index) {
          setState(() {
            _currScreenIndex = index;
          });
        },
      ),
      body: IndexedStack(
        children: [
          dashboardScreen,
          townReportScreen,
          adminScreen,
          userProfileScreen,
        ],
        index: _currScreenIndex,
      ),
    );
  }
}
