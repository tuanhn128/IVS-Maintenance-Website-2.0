import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/screens/admin/tech_tab/create_user.dart';
import 'package:ivs_maintenance_2/screens/admin/tech_tab/techs_table.dart';

import 'package:ivs_maintenance_2/widgets/outlined_text_button.dart';

class AdminTechTab extends StatefulWidget {
  const AdminTechTab({Key? key}) : super(key: key);

  @override
  _AdminTechTabState createState() => _AdminTechTabState();
}

class _AdminTechTabState extends State<AdminTechTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          OutlinedTextButton(
            text: 'Create User',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateUser()),
              );
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          TechsTable(),
        ],
      ),
    );
  }
}
