import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivs_maintenance_2/constants/constants.dart';
import 'package:ivs_maintenance_2/services/database_service.dart';
import 'package:ivs_maintenance_2/widgets/number_text_field.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class NewProblemDialog extends StatefulWidget {
  const NewProblemDialog({Key? key, required this.townId}) : super(key: key);

  final String townId;

  @override
  _NewProblemDialogState createState() => _NewProblemDialogState();
}

class _NewProblemDialogState extends State<NewProblemDialog> {
  final _formKey = GlobalKey<FormState>();
  String _itemName = kItemNames.first;
  int _replaced = 0;
  int _unresolved = 0;

  _submit() async {
    if (_formKey.currentState!.validate()) {
      TipDialogHelper.loading('Adding New Problem');
      String? newProblemId =
          await Provider.of<DatabaseService>(context, listen: false)
              .addProblemToTown(
        townId: widget.townId,
        itemName: _itemName,
        replaced: _replaced,
        unresolved: _unresolved,
      );
      if (newProblemId != null) {
        TipDialogHelper.success('New Problem Added!');
      } else {
        TipDialogHelper.fail('Error adding problem :(');
      }
      Navigator.of(context).pop();
    }
  }

  _getFormTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _getButton(String text, Color textColor, void Function()? onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
            side: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.all(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: Text(
          'New Problem',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  /* Item Name */
                  _getFormTitle('Item Name'),
                  DropdownButtonFormField(
                    items: kItemNames
                        .map((String name) => DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            ))
                        .toList(),
                    onChanged: (dynamic itemName) {
                      setState(() {
                        _itemName = itemName;
                      });
                    },
                    validator: (String? itemName) {
                      if (itemName == null) {
                        return "Please select an item";
                      }
                      return null;
                    },
                  ),
                  _getFormTitle('# Replaced'),
                  NumberTextField(
                    initialValue: 0,
                    onChanged: (String replacedString) {
                      _replaced = int.parse(
                          replacedString != "" ? replacedString : '0');
                    },
                  ),
                  _getFormTitle('# Unresolved'),
                  NumberTextField(
                    initialValue: 0,
                    onChanged: (String unresolvedString) {
                      _unresolved = int.parse(
                          unresolvedString != "" ? unresolvedString : '0');
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getButton(
                        'Cancel',
                        Colors.red,
                        () => Navigator.of(context).pop(),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      _getButton(
                        'Save',
                        Colors.green,
                        _submit,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
