import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/dummy/dummy_data.dart';
import 'package:ivs_maintenance_2/helpers/helpers.dart';
import 'package:ivs_maintenance_2/models/tech.dart';
import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/models/user_data.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'dashboard_widgets/dashboard_greeting.dart';
import 'dashboard_widgets/dashboard_town.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _currentDay;

  @override
  void initState() {
    _currentDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tech>(
      future: Provider.of<DatabaseService>(context, listen: false).getTechById(
          Provider.of<UserData>(context, listen: false).currentTechId!),
      builder: (context, techSnapshot) {
        if (!techSnapshot.hasData) {
          return Center(child: CupertinoActivityIndicator());
        }
        Tech currTech = techSnapshot.data!;
        return StreamBuilder<List<Town>>(
          stream: Provider.of<DatabaseService>(context, listen: false)
              .getAllTownsStream(),
          builder: (context, townSnapshot) {
            if (!townSnapshot.hasData) {
              return Center(child: CupertinoActivityIndicator());
            }
            List<Town> allTowns = townSnapshot.data!;
            List<Town> currDayTowns = allTowns
                .where((town) =>
                    town.scheduledTime
                        .isAfter(Helpers.getStartOfDay(_currentDay)) &&
                    town.scheduledTime
                        .isBefore(Helpers.getEndOfDay(_currentDay)) &&
                    town.assignedTeam == currTech.team)
                .toList();
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  TitleWidget(title: 'IVS Maintenance Dashboard'),
                  SliverToBoxAdapter(
                    child: DashboardGreeting(
                      tech: currTech,
                      onNewDate: (DateTime newDate) {
                        setState(() {
                          _currentDay = newDate;
                        });
                      },
                      currentDate: _currentDay,
                    ),
                  ),
                ];
              },
              body: (currDayTowns.isNotEmpty)
                  ? ListView.builder(
                      itemCount: currDayTowns.length,
                      itemBuilder: (context, index) {
                        return DashboardTown(
                          town: currDayTowns[index],
                        );
                      },
                    )
                  : Center(
                      child: Text('No towns for today!'),
                    ),
            );
          },
        );
      },
    );
  }
}
