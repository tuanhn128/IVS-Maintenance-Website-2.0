/* Dummy data for simple instances of our customc lasses. Used for testing. */

import 'package:ivs_maintenance_2/models/town.dart';
import 'package:ivs_maintenance_2/models/town_problem.dart';
import 'package:ivs_maintenance_2/models/tech.dart';

class DummyData {
  static final Tech testUser = Tech(
    id: "testUser",
    name: "Tuan",
    email: "tuanhn@stanford.edu",
    team: "Red",
  );

  static final Town testTown = Town(
    id: "testTown",
    name: "Greenwich",
    numMachines: 21,
    contacts: "Lynn Giacomo",
    address: "Town Hall, 101 Field Point Rd., 06830",
    parkingNotes: "Park in Public parking (left side) of town hall.",
    buildingNotes:
        "Call ROV to get let into building  Come to Front door of Town Hall",
    scheduledTime: DateTime.utc(2021, 7, 16, 12),
    phoneNumbers: "203-622-7889/90-ofc, 914-714-2934",
    assignedTeam: "Red",
    systemsServiced: 21,
    actualStartTime: DateTime.utc(2021, 7, 16, 11, 30),
    // completed: true,
  );

  static final Town testTown2 = Town(
    id: "testTown2",
    name: "Norwalk",
    numMachines: 16,
    contacts: "Stuart and Karen",
    address: "Norwalk City Hall, 125 East Ave., 06856",
    parkingNotes: "",
    buildingNotes:
        "The loading dock has an intercom from which the building security can be contacted to let you in. Room #103.",
    phoneNumbers: "203-854-7763",
    scheduledTime: DateTime.utc(2021, 7, 16, 10),
    actualStartTime: DateTime.utc(2021, 7, 16, 10, 30),
    assignedTeam: "Blue",
  );

  static final TownProblem testProblem = TownProblem(
    id: "testProblem",
    itemName: "Printer",
    replaced: 1,
    unresolved: 0,
  );
}
