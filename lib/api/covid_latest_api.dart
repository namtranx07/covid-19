import 'package:covid_19/model/covid_latest.dart';
import 'package:covid_19/network/base_url.dart';
import 'package:covid_19/network/http_handle.dart';

abstract class CovidLatestApi {
  GET covidWorldMethod() => GET("/all");

  Future<CovidLatest> covidWorld();
}

class CovidLatestUrl extends BaseUrl {
  @override
  String dev() => "https://coronavirus-19-api.herokuapp.com";
}