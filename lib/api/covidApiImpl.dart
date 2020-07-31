import 'package:covid_19/api/covidApi.dart';
import 'package:covid_19/network/base_api.dart';
import 'package:covid_19/model/summary.dart';

class CovidApiImpl extends BaseAPI with CovidApi {

  @override
  Future<Summary> covidSummary() {
    return sendApiRequest(covidSummaryMethod()).then(
            (value) => Summary.fromJson(value));
  }

}