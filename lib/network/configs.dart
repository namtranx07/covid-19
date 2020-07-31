
import 'app_http_error.dart';
import 'base_url.dart';
import 'network.dart';

class Configs {

  static String getDomain() {
    String _host = "";
    switch (currentEnvironment) {
      case Environment.DEV:
        _host = "https://api.covid19api.com/";
        break;
    }
    return _host;
  }

  static Environment getEnvironment() => currentEnvironment;


  static void configNetwork() {
    Network.init(getDomain(), httpError: AppHttpError());
  }
}
