import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:provider/provider.dart';

class SelectTeamDropdown extends StatelessWidget {
  const SelectTeamDropdown({Key? key, this.onChanged}) : super(key: key);

  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Provider.of<DatabaseService>(context, listen: false)
          .getAllTeamNames(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        List<String> teams = snapshot.data ?? [];
        return DropdownButtonFormField(
          items: teams
              .map((String team) =>
                  DropdownMenuItem(value: team, child: Text(team)))
              .toList(),
          onChanged: onChanged,
          validator: (String? team) {
            if (team == null) return "Please select a team";
            return null;
          },
        );
      },
    );
  }
}
