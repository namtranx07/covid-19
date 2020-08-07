import 'dart:async';

import 'package:covid_19/utils/custom_appbar.dart';
import 'package:covid_19/web_view/web_view.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapDetail extends StatefulWidget {
  MapDetail({
    Key key,
  }) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  final _appBarOptionSubject = BehaviorSubject<bool>()..sink.add(true);
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMapDetail(context, brightness: Brightness.light),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          WebViewWidget(
            key: _key,
            controller: _controller,
          ),
          StreamBuilder(
            stream: _appBarOptionSubject.stream,
            builder: (_, AsyncSnapshot<bool> snapshot) {
              final _isVisible = snapshot.hasData && snapshot.data;
              return _isVisible
                  ? _buildOption(
                      Icon(
                        Icons.close,
                        color: Colors.black45,
                      ),
                      action: () => Navigator.of(context).pop(),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _appBarOptionSubject.close();
    super.dispose();
  }

  Widget _buildOption(Widget icon, {String title, Function action}) {
    return GestureDetector(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.3),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          top: 70,
          left: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: title != null ? 5 : 0),
            title != null
                ? Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
