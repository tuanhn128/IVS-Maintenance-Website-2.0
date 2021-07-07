/* Back button that takes in a changesMade variable and warns user of losing 
changes */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangesMadeBackButton extends StatelessWidget {
  const ChangesMadeBackButton({Key? key, required this.changesMade})
      : super(key: key);

  final bool changesMade;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        if (changesMade) {
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('Changes Made'),
              content:
                  Text('Are you sure you want to leave and abandon changes?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Leave')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
              ],
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
