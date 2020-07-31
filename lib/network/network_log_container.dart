import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NetWorkLogContainer {
  List<NetworkLog> logs = [];
  StreamController<NetworkLog> logController =
  StreamController<NetworkLog>.broadcast();
  static NetWorkLogContainer _instance;
  SharedPreferences prefs;

  static const String PREF_LOGS = "PREF_LOGS";

  NetWorkLogContainer._();

  static Future<NetWorkLogContainer> getInstance() async {
    if (_instance == null) {
      _instance = NetWorkLogContainer._();
      _instance.prefs = await SharedPreferences.getInstance();
      try {
        final cachedLogs = jsonDecode(_instance.prefs.get(PREF_LOGS)) as List;
        cachedLogs.forEach((map) => _instance.logs.add(NetworkLog.fromJson(map)));
      } catch (e) {
        print(e);
      }
    }
    return _instance;
  }

  void addApiLog(NetworkLog log) {
    logs.insert(0, log);
    logController.add(log);
  }

  void cache() {
    prefs.setString(PREF_LOGS, jsonEncode(logs));
  }
}

class NetworkLog {
  String url;
  String path;
  dynamic request;
  dynamic response;
  int statusCode;

  String method;

  NetworkLog({this.url, this.path, this.response, this.statusCode, this.method});

  NetworkLog.fromJson(Map json)
      : url = json['url'],
        request = json['request'],
        path = json['path'],
        statusCode = json['statusCode'],
        method = json['method'],
        response = json['response'];

  Map toJson() => {
    'url': url,
    'request': request,
    'response': response,
    'statusCode': statusCode,
    'method': method ,
    'path': path,
  };
}
