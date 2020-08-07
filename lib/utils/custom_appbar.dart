
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

PreferredSize appBarMapDetail(BuildContext context,{Color color, Brightness brightness, double height = 0}) => PreferredSize(
    preferredSize: Size.fromHeight(height),
    child: AppBar(
        elevation: 0,
        brightness: brightness ?? Theme.of(context).brightness,
        backgroundColor: color ?? Colors.transparent
    )
);
