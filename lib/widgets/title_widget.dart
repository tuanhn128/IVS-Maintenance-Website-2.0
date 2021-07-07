import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title, this.leading})
      : super(key: key);

  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 36.0,
        ),
      ),
      centerTitle: true,
    );
  }
}
