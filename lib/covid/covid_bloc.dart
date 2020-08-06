import 'package:covid_19/api/covidApiImpl.dart';
import 'package:covid_19/api/covid_latest_apiImpl.dart';
import 'package:covid_19/covid/covid_event.dart';
import 'package:covid_19/covid/covid_state.dart';
import 'package:covid_19/model/summary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  CovidApiImpl _covidApiImpl;
  CovidLatestApiImpl _covidLatestApiImpl;

  CovidBloc() : super(CovidState()) {
    _covidApiImpl = CovidApiImpl();
    _covidLatestApiImpl = CovidLatestApiImpl();
  }

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async* {
    switch (event.runtimeType) {
      case InitialEvent:
        final summaryData = await _covidApiImpl.covidSummary();
        final vnData = summaryData.countries.firstWhere(
            (element) => element.countryCode == "VN",
            orElse: () => null);
        yield state.copyWith(
          summary: summaryData,
          vnSummary: vnData,
          isLoading: false,
        );
        break;
      case SearchCountryEvent:
        final _event = event as SearchCountryEvent;
        bool noData = false;
        final data = state.summary.countries.firstWhere(
          (element) =>
              element.country.contains(_event.name.toLowerCase()) ||
              element.slug.contains(_event.name.toLowerCase()),
          orElse: () {
            noData = true;
            return null;
          },
        );
        yield state.copyWith(
          otherCountry: data,
          isLoading: false,
          noData: noData,
          changeIconSearch: true,
        );
        break;
      case ChangeIconSearch:
        final _event = event as ChangeIconSearch;
        yield state.copyWith(
          changeIconSearch: _event.change, isLoading: false);
        break;
    }
  }
}
