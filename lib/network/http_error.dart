import 'package:dio/dio.dart';

class HttpError implements Exception {
  final int code;

  String message;
  Map body;

  HttpError({this.code, this.message,this.body});

  factory HttpError.error(Exception e,{defaultError = 'Server error, please try again!', }) {
    String message = defaultError;
    if (e is DioError && e.type != DioErrorType.DEFAULT) {
      Map data = e.response?.data;

      if(data != null && data is Map
          && data.containsKey('errors')
          && data['errors'] is String) {
        message = data['errors'];
      }
      return HttpError(
          code: e.response?.statusCode,
          body: data,
          message: message);
    }
    return HttpError(message: message);
  }

  void handleError(error){
    throw HttpError.error(error);
  }

  void withOutInternet({noInternetError = 'No Internet!'}) {
    throw HttpError(code: 10001, message: noInternetError);
  }

  @override
  String toString() {
    if (message == null) return '';
    return message.toString();
  }
}
