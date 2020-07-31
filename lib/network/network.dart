import 'package:covid_19/network/http_error.dart';
import 'package:covid_19/network/http_logging_intercepter.dart';
import 'package:dio/dio.dart';

class Network {
  static Dio _dioDefault;
  static String _baseUrl;
  static List<Interceptor> _interceptors;
  static HttpError httpError;
  static bool enableLoggingView = false;

  static void init(String baseUrl,
      {List<Interceptor> interceptors, HttpError httpError}) {
    _baseUrl = baseUrl;
    _interceptors = interceptors;
    Network.httpError = httpError;
  }

  static Dio getDioDefault() {
    _dioDefault ??= getBaseDio(baseUrl: _baseUrl);
    return _dioDefault;
  }

  static Dio getBaseDio({String baseUrl}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );
    Dio dio = Dio(options);
    if (enableLoggingView) {
      dio.interceptors.add(HttpLoggingViewInterceptor());
    }
    _interceptors?.forEach((interceptor) => dio.interceptors.add(interceptor));
    return dio;
  }
}
