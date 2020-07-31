import 'package:dio/dio.dart';

import 'http_error.dart';

class AppHttpError extends HttpError {
  final int code;
  String message;
  Map body;

  AppHttpError({this.code, this.message, this.body});

  @override
  void handleError(e) {
    String message = "Server error, please try again!";
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          message = 'Connect timeout, cannot connect to server!';
          break;
        case DioErrorType.DEFAULT:
          message = e.error?.toString();
          break;
        default:
          break;
      }
      Map data = e.response?.data;
      if (data != null && data is Map){
        if (data.containsKey("message") && data["message"] is String) {
          message = data["message"];
        } else if (data.containsKey("errors") && data["errors"] is String){
          message = data["errors"];
        }
      }
      throw HttpError(
        code: e.response?.statusCode,
        message: message,
      );
    } else {
      throw HttpError(
        code: 999,
        message: message,
      );
    }
  }
}
