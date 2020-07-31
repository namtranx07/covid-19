import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:connectivity/connectivity.dart';

import 'base_url.dart';
import 'http_error.dart';
import 'network.dart';

abstract class HttpAPI {
  final HttpError httpError;

  HttpAPI(this.httpError);

  BaseUrl baseUrl() => null;

  Dio _dio;

  Dio getDio(){
    if(_dio != null){
      return _dio;
    }
    else if(baseUrl() == null) {
      _dio = Network.getDioDefault();
    }else{
      _dio =  Network.getBaseDio(baseUrl: baseUrl().getUrl());
    }
    return _dio;
  }

  @protected
  Future sendApiRequest(Method method,
      {
        var body,
        Map<String, dynamic> queryParameters}) async {
    bool haveConnection = await _connectedWithInternet();
    if (!haveConnection) httpError.withOutInternet();
    var request = HttpRequest.newRequest(method,
        dio: getDio(),
        body: body,
        queryParameters: queryParameters);
    try {
      Response rawResponse = await request.send();
      return rawResponse.data;
    } catch (e) {
      httpError.handleError(e);
    }
  }

  Future<bool> _connectedWithInternet() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class HttpRequest {
  final Method method;
  Map<String, dynamic> headers;
  var body;
  Map<String, dynamic> queryParameters;
  Dio dio;

  HttpRequest(this.method,
      {Dio dio, Map<String, dynamic> headers, this.body, this.queryParameters})
      : dio = dio ?? Network.getDioDefault();

  factory HttpRequest.newRequest(Method method,
      {Dio dio,
        Map<String, String> headers,
        var body,
        Map<String, dynamic> queryParameters}) {
    return HttpRequest(method,
        dio: dio,
        headers: headers,
        body: body,
        queryParameters: queryParameters);
  }

  void addQueries(Map<String, dynamic> queryParameters) =>
      this.queryParameters = queryParameters;

  void addQuery(String key, var value) {
    queryParameters ??= {};
    queryParameters[key] = value;
  }

  void addParams(var body) => this.body = body;

  void addParam(String key, var value) {
    body ??= {};
    body[key] = value;
  }

  Future<Response> send() async {
    Future<Response> response;
    if (body != null) {
      print(body);
    }
    if (method is POST)
      response =
          dio.post(method.path, data: body, queryParameters: queryParameters);
    else if (method is GET)
      response = dio.get(method.path, queryParameters: queryParameters);
    else if (method is PUT)
      response =
          dio.put(method.path, data: body, queryParameters: queryParameters);
    else if (method is DELETE)
      response =
          dio.delete(method.path, data: body, queryParameters: queryParameters);

    return response;
  }
}

abstract class Method {
  String path;

  Method(this.path);

  addPath(String path) {
    this.path += '/$path';
    return this;
  }
}

class POST extends Method {
  POST(String url) : super(url);
}

class GET extends Method {
  GET(String url) : super(url);
}

class PUT extends Method {
  PUT(String url) : super(url);
}

class DELETE extends Method {
  DELETE(String url) : super(url);
}
