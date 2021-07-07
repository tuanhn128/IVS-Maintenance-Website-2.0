import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/models/town.dart';

class TownDetails extends StatelessWidget {
  const TownDetails({Key? key, required this.town}) : super(key: key);

  final Town town;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      child: Column(
        children: [
          DetailItem(label: "Contact Names", content: town.contacts),
          DetailItem(label: "Phone Info", content: town.phoneNumbers),
          DetailItem(label: "Parking Notes", content: town.parkingNotes),
          DetailItem(label: "Building Notes", content: town.buildingNotes),
        ],
      ),
    );
  }
}

/* Individual detail item. Aligns and wraps text such that the multiple lines 
of the content are all aligned. */
class DetailItem extends StatelessWidget {
  const DetailItem({Key? key, required this.label, required this.content})
      : super(key: key);

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
