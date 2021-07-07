/* Multi-line rectangular text field (like notes text field on town report).
This widget includes the text field and the title */
import 'package:flutter/material.dart';
import 'package:ivs_maintenance_2/widgets/form_item_title.dart';

class MultiLineTextField extends StatelessWidget {
  const MultiLineTextField(
      {Key? key,
      required this.title,
      this.onChanged,
      required this.initialValue})
      : super(key: key);

  final String title;
  final Function(String?)? onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormItemTitle(title: title),
        Container(
          width: 450,
          child: TextFormField(
            minLines: 3,
            maxLines: 6,
            onChanged: onChanged,
            initialValue: initialValue,
            style: TextStyle(
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  5.0,
                ),
              ),
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}
