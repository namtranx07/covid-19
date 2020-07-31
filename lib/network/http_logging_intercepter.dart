import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'network_log_container.dart';

class HttpLoggingViewInterceptor extends Interceptor {
  NetWorkLogContainer netWorkLogContainer;

  @override
  Future onRequest(RequestOptions options) async {
    String headerFormat = JsonEncoder.withIndent('  ').convert(options.headers);
    debugPrint(
        '--------------------------------------------------------------');
    debugPrint('Request: ${options.baseUrl + options.path}');
    debugPrint('Headers: $headerFormat');
    if (options.data != null) {
      debugPrint('Request data: ${options.data}');
    }
    debugPrint(
        '--------------------------------------------------------------');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    try {
      netWorkLogContainer ??= await NetWorkLogContainer.getInstance();

      String url = response.request.baseUrl + response.request.path;
      debugPrint(
          '--------------------------------------------------------------');
      debugPrint('Response: $url');
      String bodyFormat = JsonEncoder.withIndent('  ').convert(response.data);
      debugPrint('$bodyFormat');
      debugPrint(
          '--------------------------------------------------------------');
      netWorkLogContainer.addApiLog(NetworkLog(
        url: url,
        path: response.request.path,
        response: response.data,
        statusCode: response.statusCode,
        method: response.request.method,
      ));
    } catch (e) {
      print(e);
    }
    return super.onResponse(response);
  }
}
