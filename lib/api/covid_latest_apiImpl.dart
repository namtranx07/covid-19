import 'package:covid_19/api/covid_latest_api.dart';
import 'package:covid_19/model/covid_latest.dart';
import 'package:covid_19/network/base_api.dart';
import 'package:covid_19/network/base_url.dart';

class CovidLatestApiImpl extends BaseAPI with CovidLatestApi {

  @override
  BaseUrl baseUrl() => CovidLatestUrl();

  @override
  Future<CovidLatest> covidWorld() {
    return sendApiRequest(covidWorldMethod()).then(
            (value) => CovidLatest.fromJson(value));
  }
}