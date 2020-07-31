
import 'package:covid_19/network/network.dart';

import 'http_handle.dart';

abstract class BaseAPI extends HttpAPI {
  BaseAPI() : super(Network.httpError);
}