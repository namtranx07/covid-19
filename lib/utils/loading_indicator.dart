import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoadingIndicator extends RefreshIndicator {
  final OuterBuilder outerBuilder;
  final Widget releaseIcon,
      idleIcon,
      refreshingIcon,
      failedIcon,
      canTwoLevelIcon,
      twoLevelView;

  /// icon and text middle margin
  final double spacing;
  final IconPosition iconPos;

  const LoadingIndicator({
    Key key,
    RefreshStyle refreshStyle: RefreshStyle.Follow,
    double height: 60.0,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.outerBuilder,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.refreshingIcon,
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
  }) : super(
    key: key,
    refreshStyle: refreshStyle,
    completeDuration: completeDuration,
    height: height,
  );

  @override
  State createState() {
    return _LoadingIndicatorState();
  }
}

class _LoadingIndicatorState extends RefreshIndicatorState<LoadingIndicator> {

  Widget _buildIcon(mode) {
    Widget icon = mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == RefreshStatus.idle
        ? widget.idleIcon
        : mode == RefreshStatus.failed
        ? widget.failedIcon
        : mode == RefreshStatus.canTwoLevel
        ? widget.canTwoLevelIcon
        : mode == RefreshStatus.canTwoLevel
        ? widget.canTwoLevelIcon
        : mode == RefreshStatus.refreshing
        ? widget.refreshingIcon ??
        SizedBox(
          width: 25.0,
          height: 25.0,
          child: AppLayoutLoading(),
        )
        : widget.twoLevelView;
    return icon ?? Container();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
          widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
      child: Center(child: container),
      height: widget.height,
    );
  }
}

class AppLayoutLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: buildActivityIndicator(),
      ),
    );
  }
}

Widget buildActivityIndicator() {
  if (Platform.isIOS) {
    return CupertinoActivityIndicator();
  }
  return Center(
    child: Container(
      color: Colors.transparent,
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    ),
  );
}