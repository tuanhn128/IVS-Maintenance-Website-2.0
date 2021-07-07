import 'package:cloud_firestore/cloud_firestore.dart';

class Town {
  final String id;
  final String name;
  final int numMachines;
  final String contacts;
  final String address;
  final String parkingNotes;
  final String buildingNotes;
  final DateTime scheduledTime;
  final DateTime? actualStartTime;
  final DateTime? finishTime;
  final String phoneNumbers;
  final int systemsServiced;
  final String techNotes;
  final String assignedTeam;
  final bool completed;
  final int numUnresolvedItems;

  Town({
    required this.id,
    required this.name,
    required this.numMachines,
    required this.contacts,
    required this.address,
    this.parkingNotes = "",
    this.buildingNotes = "",
    required this.scheduledTime,
    this.finishTime,
    this.actualStartTime,
    this.phoneNumbers = "",
    this.systemsServiced = 0,
    this.techNotes = "",
    this.assignedTeam = "No assigned team",
    this.completed = false,
    this.numUnresolvedItems = 0,
  });

  factory Town.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Town(
      id: doc.id,
      name: data["name"],
      numMachines: data["numMachines"],
      contacts: data["contacts"],
      address: data["address"],
      parkingNotes: data["parkingNotes"] ?? "",
      buildingNotes: data["buildingNotes"] ?? "",
      scheduledTime: data["scheduledTime"]?.toDate(),
      phoneNumbers: data["phoneNumbers"] ?? "",
      systemsServiced: data["systemsServiced"] ?? 0,
      techNotes: data["techNotes"] ?? "",
      assignedTeam: data["assignedTeam"] ?? "No assigned team",
      completed: data["completed"] ?? false,
      finishTime: data["finishTime"]?.toDate(),
      actualStartTime: data["actualStartTime"]?.toDate(),
      numUnresolvedItems: data["numUnresolvedItems"] ?? 0,
    );
  }

  /* Headers that will be in the town time data csv */
  static List<dynamic> getHeaderTitles() {
    return [
      "name",
      "numMachines",
      "systemsServiced",
      "minutesToComplete",
      "techNotes"
    ];
  }

  /* Data as dynamic list that corresponds to the headers in getHeaderTitles()*/
  List<dynamic> toDynamicList() {
    int? minutesToComplete;
    if (actualStartTime != null && finishTime != null) {
      Duration completionDuration = finishTime!.difference(actualStartTime!);
      minutesToComplete = completionDuration.inMinutes.round();
    }
    return [name, numMachines, systemsServiced, minutesToComplete, techNotes];
  }
}
