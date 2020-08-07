import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast(message) {
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

void fadeRouteTransition(BuildContext context, Widget child) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, ___, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    ),
  );
}