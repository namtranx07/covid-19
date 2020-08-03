
import 'package:flutter/material.dart';

class AppBarGradient extends StatelessWidget with PreferredSizeWidget {
  final AppBar child;

  AppBarGradient({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
          )
      ),
      child: child,
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}