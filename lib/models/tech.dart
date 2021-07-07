import 'package:cloud_firestore/cloud_firestore.dart';

class Tech {
  final String id;
  final String name;
  final String email;
  final String team;
  final bool admin;

  Tech({
    required this.id,
    required this.name,
    required this.email,
    this.team = "No assigned team",
    this.admin = false,
  });

  factory Tech.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tech(
      id: doc.id,
      name: data["name"],
      email: data["email"],
      team: data["team"] ?? "No assigned team",
      admin: data["admin"] ?? false,
    );
  }
}
