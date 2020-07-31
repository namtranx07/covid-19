import 'package:flutter/material.dart';

class CustomRouteWithoutAnimate<T> extends MaterialPageRoute<T> {
  CustomRouteWithoutAnimate({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) => child;
}

Future<dynamic> transferToNewScreen(context, Widget widget,
    {bool animation, bool rootNavigator = false}) {
  return Navigator
      .of(context, rootNavigator: rootNavigator)
      .push((animation ?? true)
      ? MaterialPageRoute(builder: (context) => widget)
      : CustomRouteWithoutAnimate(builder: (context) => widget),
  );
}

void transferAndRemoveAll(context, Widget screen, {bool rootNavigator = false}) {
  Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
          (Route<dynamic> route) => false);
}

extension NavigatorExtension on BuildContext {
  void push(Widget widget, {bool animation, bool rootNavigator = false, bool replace = false}) {
    if(replace){
      transferAndRemoveAll(this, widget, rootNavigator: rootNavigator);
    }else{
      transferToNewScreen(this, widget, animation: animation, rootNavigator: rootNavigator);
    }
  }

  pop<T>({bool rootNavigator = false, T result}) {
    Navigator.of(this,rootNavigator: rootNavigator).pop<T>(result);
  }

  BuildContext get firstChildContext {
    BuildContext result;
    visitChildElements((element) {
      result = element;
    });
    return result;
  }
}
