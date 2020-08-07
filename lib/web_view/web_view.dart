import 'dart:async';

import 'package:covid_19/resources/app_strings.dart';
import 'package:covid_19/utils/Utils.dart';
import 'package:covid_19/web_view/map_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum InfectionLevel { highest, high, medium, normal }

class WebViewWidget extends StatelessWidget {
  final UniqueKey key;
  final Completer<WebViewController> controller;
  final bool ignorePointer;

  WebViewWidget({
    this.key,
    this.controller,
    this.ignorePointer = false,
  });

  Widget _buildDescription(InfectionLevel level) {
    String title;
    Color markerColor;

    switch (level) {
      case InfectionLevel.highest:
        title = AppStrings.extensiveTransmissionLimited;
        markerColor = Color(0xFFC43460);
        break;
      case InfectionLevel.high:
        title = AppStrings.extensiveTransmissionNotLimited;
        markerColor = Color(0xFFEA6940);
        break;
      case InfectionLevel.medium:
        title = AppStrings.continuedTransmission;
        markerColor = Color(0xFFFCA624);
        break;
      default:
        title = AppStrings.limitedTransmission;
        markerColor = Color(0xFFF6DB68);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: markerColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplainWidget() {
    return Column(
      children: [
        _buildDescription(InfectionLevel.highest),
        _buildDescription(InfectionLevel.high),
        _buildDescription(InfectionLevel.medium),
        _buildDescription(InfectionLevel.normal),
      ],
    );
  }

  Widget _buildTrackingWeb() {
    return WebView(
      key: key,
      initialUrl:
          "https://vietnamese.cdc.gov/coronavirus/2019-ncov/travelers/map/08052020/map-coronavirus.html",
      onWebViewCreated: (c) => controller.complete(c),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.mapbox.com/') ||
            (request.url.startsWith("https://www.openstreetmap.org/"))) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
        controller.future.then((value) {
          value.evaluateJavascript(
              "document.getElementById('recommendations').style.display = 'none';");
          value.evaluateJavascript(
              "document.getElementsByClassName('mapboxgl-ctrl-geocoder--input')[0].placeholder = 'Tìm quốc gia';");
          value.evaluateJavascript(
              "document.getElementById('features').style.display = 'none';");
          value.evaluateJavascript(
              "document.getElementById('wordmark').style.display = 'none';");
        });
      },
      gestureNavigationEnabled: true,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(
          () => PanGestureRecognizer(),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ignorePointer
        ? Column(
            children: [
              GestureDetector(
                child: IgnorePointer(
                  child: Container(
                    child: _buildTrackingWeb(),
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                onTap: () => _openMapDetail(context),
                behavior: HitTestBehavior.translucent,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: _buildExplainWidget(),
              ),
            ],
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: _buildTrackingWeb(),
                  height: 400,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: _buildExplainWidget(),
                ),
              ],
            ),
          );
  }

  void _openMapDetail(
    BuildContext context,
  ) {
    fadeRouteTransition(
      context,
      MapDetail(),
    );
  }
}
