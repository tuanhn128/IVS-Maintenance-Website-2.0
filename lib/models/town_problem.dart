import 'package:cloud_firestore/cloud_firestore.dart';

class TownProblem {
  final String id;
  final String itemName;
  final int replaced;
  final int unresolved;

  TownProblem({
    required this.id,
    required this.itemName,
    this.replaced = 0,
    this.unresolved = 0,
  });

  factory TownProblem.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TownProblem(
      id: doc.id,
      itemName: data["itemName"],
      replaced: data["replaced"] ?? 0,
      unresolved: data["unresolved"] ?? 0,
    );
  }
}
