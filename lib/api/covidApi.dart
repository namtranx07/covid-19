import 'package:covid_19/model/summary.dart';
import 'package:covid_19/network/http_handle.dart';

abstract class CovidApi {
  GET covidSummaryMethod() => GET("/summary");
  Future<Summary> covidSummary();
}
