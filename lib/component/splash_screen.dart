import 'dart:async';

import 'package:covid_19/covid/covid_widget.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(body: initScreen(context)),
    );
  }

  Widget initScreen(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: FlareActor(
          "images/loading-animation.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "active",
          snapToEnd: false,
          antialias: true,
          shouldClip: false,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CovidWidget()));
  }
}
